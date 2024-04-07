INC_SERVER()

ENT.NextWaterDamage = 0
ENT.NextJump = 0

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetUseType(SIMPLE_USE)

	self:PhysicsInit(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMass(self.Mass)
		phys:EnableDrag(false)
		phys:EnableMotion(true)
		phys:Wake()
		phys:SetBuoyancyRatio(0.8)
		phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
	end

	self:StartMotionController()

	self:SetMaxObjectHealth(self.MaxHealth)
	self:SetObjectHealth(self:GetMaxObjectHealth())

	self.LastThink = CurTime()
	self.NextTouch = {}

	self:UseClientSideAnimation(true)

	local ent = ents.Create("fhb")
	if ent:IsValid() then
		ent:SetPos(self:GetPos())
		ent:SetAngles(self:GetAngles())
		ent:SetParent(self)
		ent:SetOwner(self)
		ent.Size = self.HitBoxSize
		ent:Spawn()
		ent.IgnoreMelee = false
	end

	self:SetCustomCollisionCheck(true)
	self:CollisionRulesChanged()

	hook.Add("SetupPlayerVisibility", self, self.SetupPlayerVisibility)
end

function ENT:SetupPlayerSkills()
	local owner = self:GetObjectOwner()
	local newmaxhealth = self.MaxHealth
	local currentmaxhealth = self:GetMaxObjectHealth()
	local defaults = scripted_ents.Get(self:GetClass())
	local hitdamage = defaults.HitDamage
	local maxspeed = defaults.MaxSpeed
	local acceleration = defaults.Acceleration
	local loaded = false

	if owner:IsValid() then
		newmaxhealth = newmaxhealth * owner:GetTotalAdditiveModifier("ControllableHealthMul")
		maxspeed = maxspeed * (owner.ControllableSpeedMul or 1)
		acceleration = acceleration * (owner.ControllableHandlingMul or 1)
		loaded = owner:IsSkillActive(SKILL_LOADEDHULL)
	end

	newmaxhealth = math.ceil(newmaxhealth)

	self:SetMaxObjectHealth(newmaxhealth)
	self:SetObjectHealth(self:GetObjectHealth() / currentmaxhealth * newmaxhealth)

	self.HitDamage = hitdamage
	self.MaxSpeed = maxspeed
	self.Acceleration = acceleration

	if loaded then
		if not IsValid(self.LoadedProp) then
			local ent = ents.Create("prop_dynamic_override")
			if ent:IsValid() then
				ent:SetModel("models/props_junk/propane_tank001a.mdl")
				ent:SetModelScale(0.5, 0)
				ent:SetParent(self)
				ent:SetOwner(self)
				ent:SetLocalPos(Vector(-7, 0, -8.5))
				ent:SetLocalAngles(Angle(-40, 0, 0))
				ent:Spawn()

				self.LoadedProp = ent
			end
		end
	elseif IsValid(self.LoadedProp) then
		self.LoadedProp:Remove()
	end
end

function ENT:SetObjectHealth(health)
	self:SetDTFloat(0, health)

	if health <= 0 then
		self:Destroy()
	end
end

function ENT:OnTakeDamage(dmginfo)
	if dmginfo:GetDamage() <= 0 then return end

	local attacker = dmginfo:GetAttacker()
	if attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN then return end

	self:TakePhysicsDamage(dmginfo)

	if dmginfo:GetDamageType() == DMG_ACID then
		dmginfo:SetDamage(dmginfo:GetDamage() * 2)
	end

	self:SetObjectHealth(self:GetObjectHealth() - dmginfo:GetDamage())

	if attacker:IsValidZombie() and dmginfo:GetInflictor().MeleeDamage then
		self:EmitSound("npc/roller/mine/rmine_predetonate.wav")
	end

	local effectdata = EffectData()
		effectdata:SetOrigin(self:NearestPoint(dmginfo:GetDamagePosition()))
		effectdata:SetNormal(VectorRand():GetNormalized())
		effectdata:SetMagnitude(4)
		effectdata:SetScale(1.33)
	util.Effect("sparks", effectdata)
end

function ENT:Use(pl)
	if pl == self:GetObjectOwner() and pl:Team() == TEAM_HUMAN and pl:Alive() then
		self:OnPackedUp(pl)
	end
end

function ENT:PhysicsCollide(data, phys)
	self.HitData = data
	self:NextThink(CurTime())
end

function ENT:OnPackedUp(pl)
	pl:GiveEmptyWeapon(self.WeaponClass)
	pl:GiveAmmo(1, self.AmmoType)

	pl:PushPackedItem(self:GetClass(), self:GetObjectHealth())

	self:Remove()
end

local trace = {mask = MASK_SOLID}
function ENT:PhysicsSimulate(phys, frametime)
	phys:Wake()

	local owner = self:GetObjectOwner()
	if not owner:IsValid() or self.DisableControlUntil and CurTime() < self.DisableControlUntil then return SIM_NOTHING end

	local vel = phys:GetVelocity()
	local movedir = Vector(0, 0, 0)
	local aimangles = owner:EyeAngles()
	local onground = false

	if self:BeingControlled() then
		trace.filter = self
		trace.start = self:GetPos()
		trace.endpos = trace.start + Vector(0, 0, self:OBBMins().z - 8)
		local tr = util.TraceLine(trace)
		onground = tr.Hit

		if owner:KeyDown(IN_FORWARD) then
			movedir = movedir + aimangles:Forward()
		end
		if owner:KeyDown(IN_BACK) then
			movedir = movedir - aimangles:Forward()
		end
		if owner:KeyDown(IN_MOVERIGHT) then
			movedir = movedir + aimangles:Right()
		end
		if owner:KeyDown(IN_MOVELEFT) then
			movedir = movedir - aimangles:Right()
		end

		if owner:KeyDown(IN_BULLRUSH) and onground and self.NextJump < CurTime() and vel:Length() <= 48 then
			vel.z = vel.z + 180
			self.NextJump = CurTime() + 1
		end
	end

	if movedir == vector_origin then
		vel = vel * (1 - frametime * self.IdleDrag)
	else
		movedir.z = math.min(0, math.abs(movedir.z))
		movedir:Normalize()

		vel = vel + frametime * self.Acceleration * 0.55 * math.Clamp((self:GetObjectHealth() / self:GetMaxObjectHealth() + 1) / 2, 0.5, 1) * (onground and 1 or 0.1) * movedir
	end

	if vel:Length() > self.MaxSpeed then
		vel:Normalize()
		vel = vel * self.MaxSpeed
	end

	phys:SetDragCoefficient(10)
	phys:SetVelocityInstantaneous(vel)
	phys:AddAngleVelocity(vel * 0.15)

	self:SetPhysicsAttacker(owner)

	return SIM_NOTHING
end

function ENT:Destroy()
	if self.Destroyed then return end
	self.Destroyed = true

	local epicenter = self:LocalToWorld(self:OBBCenter())

	if self:GetObjectOwner():IsValidLivingHuman() then
		self:GetObjectOwner():SendDeployableLostMessage(self)
	end

	self:EmitSound("npc/manhack/gib.wav")

	local effectdata = EffectData()
		effectdata:SetOrigin(epicenter)
		effectdata:SetNormal(Vector(0, 0, 1))
		effectdata:SetMagnitude(5)
		effectdata:SetScale(1.5)
	util.Effect("sparks", effectdata)

	local owner = self:GetObjectOwner()
	if owner:IsValidLivingHuman() and owner:IsSkillActive(SKILL_LOADEDHULL) then
		effectdata = EffectData()
			effectdata:SetOrigin(epicenter)
			effectdata:SetNormal(Vector(0, 0, -1))
		util.Effect("decal_scorch", effectdata)

		self:EmitSound("npc/env_headcrabcanister/explosion.wav", 100, 100)
		ParticleEffect("dusty_explosion_rockets", epicenter, angle_zero)

		util.BlastDamagePlayer(self, owner, epicenter, 128, 225, DMG_ALWAYSGIB)
	else
		util.Effect("HelicopterMegaBomb", effectdata, true, true)
	end
end

ENT.PhysDamageImmunity = 0
function ENT:Think()
	if self.Destroyed then
		if not self.CreatedDebris then
			self.CreatedDebris = true

			local ent = ents.Create("prop_physics")
			if ent:IsValid() then
				ent:SetPos(self:GetPos())
				ent:SetAngles(self:GetAngles())
				ent:SetModel(self:GetModel())
				ent:Spawn()
				local phys = ent:GetPhysicsObject()
				if phys:IsValid() then
					phys:SetVelocityInstantaneous(self:GetVelocity())
				end

				ent:Fire("break")
				ent:Fire("kill", "", 0.05)
			end
		end

		self:Remove()
		return
	end

	local owner = self:GetObjectOwner()
	if owner:IsValid() then
		self:SetPhysicsAttacker(owner)

		if not owner:Alive() or owner:Team() ~= TEAM_HUMAN then
			self:Destroy()
			return
		end
	else
		self:Destroy()
		return
	end

	if self.ChangeBackTime and self.ChangeBackTime < CurTime() then
		self:SetModel("models/roller.mdl")
		self:EmitSound("npc/roller/mine/rmine_blades_out1.wav", 65, 80)
		self.ChangeBackTime = nil
	end

	if self:WaterLevel() >= 2 and CurTime() >= self.NextWaterDamage then
		self.NextWaterDamage = CurTime() + 0.2

		self:TakeDamage(10)
	end

	local data = self.HitData
	if data then
		self.HitData = nil
		self:ThreadSafePhysicsCollide(data)
	end
end

function ENT:ThreadSafePhysicsCollide(data)
	local owner = self:GetObjectOwner()
	if not owner:IsValidLivingHuman() then return end

	local hitflesh = false
	local ent = data.HitEntity

	if ent and ent:IsValid() and CurTime() >= (self.NextTouch[ent] or 0) then
		self.NextTouch[ent] = CurTime() + self.HitCooldown

		if ent:IsPlayer() and ent:Team() == TEAM_UNDEAD and ent:Alive() then
			ent:TakeSpecialDamage(self.HitDamage, DMG_SLASH, owner, self)
			hitflesh = true
		else
			local physattacker = ent:GetPhysicsAttacker()
			if physattacker:IsValid() and physattacker:Team() == TEAM_HUMAN then
				self.PhysDamageImmunity = CurTime() + 0.5
			end
		end
	end

	local effectdata = EffectData()
		effectdata:SetOrigin(self:NearestPoint(data.HitPos))
		effectdata:SetNormal(data.HitNormal)

	if hitflesh then
		self:EmitHitFleshSound()

		local dir = (self:GetPos() - data.HitPos):GetNormalized()

		util.Blood(data.HitPos, math.random(10, 14), dir, 200)

		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			dir.z = dir.z + 0.5

			phys:AddVelocity(dir * self.BounceFleshVelocity)
		end

		effectdata:SetStart(ent:WorldSpaceCenter())
		effectdata:SetEntity(self)
		util.Effect("tracer_zapper", effectdata)

		self:SetModel("models/roller_spikes.mdl")
		self.ChangeBackTime = CurTime() + 0.25
		self.DisableControlUntil = CurTime() + 1
	elseif data.DeltaTime > 0.33 and data.Speed > 200 then
		self:EmitHitSound()

		effectdata:SetMagnitude(2)
		effectdata:SetScale(1)
		util.Effect("sparks", effectdata)
	end
end

function ENT:EmitHitFleshSound()
	self:EmitSound("npc/roller/mine/rmine_explode_shock1.wav")
end

function ENT:EmitHitSound()
	self:EmitSound("npc/manhack/grind"..math.random(5)..".wav")
end

function ENT:SetupPlayerVisibility(pl)
	if pl ~= self:GetObjectOwner() then return end

	AddOriginToPVS(self:GetPos())
end
