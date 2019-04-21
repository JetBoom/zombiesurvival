INC_SERVER()

ENT.NextWaterDamage = 0

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

		local Constraint = ents.Create("phys_keepupright")
		Constraint:SetAngles(Angle(0, 0, 0))
		Constraint:SetKeyValue("angularlimit", 5)
		Constraint:SetPhysConstraintObjects(phys, phys)
		Constraint:Spawn()
		Constraint:Activate()
		self:DeleteOnRemove(Constraint)
	end

	self:StartMotionController()

	self:SetMaxObjectHealth(self.MaxHealth)
	self:SetObjectHealth(self:GetMaxObjectHealth())

	self.LastThink = CurTime()

	self.NextTouch = {}

	self:SetBodygroup(1, 1)
	self:SetBodygroup(2, 1)
	self:SetSequence(1)
	self:SetPlaybackRate(1)
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

	ent = ents.Create("env_projectedtexture")
	if ent:IsValid() then
		ent:SetPos(self:GetRedLightPos())
		ent:SetAngles(self:GetRedLightAngles())
		ent:SetKeyValue("enableshadows", 0)
		ent:SetKeyValue("farz", 400)
		ent:SetKeyValue("nearz", 8)
		ent:SetKeyValue("lightfov", 80)
		local owner = self:GetObjectOwner()
		if owner:IsValid() and owner:IsPlayer() then
			local vcol = owner:GetPlayerColor()
			if vcol then
				if vcol == vector_origin then
					vcol.x = 1 vcol.y = 1 vcol.z = 1
				end
				vcol:Normalize()
				vcol = (vcol * 2 + Vector(1, 1, 1)) / 3
				vcol.x = math.Clamp(math.ceil(vcol.x * 255), 0, 255)
				vcol.y = math.Clamp(math.ceil(vcol.y * 255), 0, 255)
				vcol.z = math.Clamp(math.ceil(vcol.z * 255), 0, 255)
				ent:SetKeyValue("lightcolor", vcol.x.." "..vcol.y.." "..vcol.z.." "..255)
			else
				ent:SetKeyValue("lightcolor", "200 220 255 255")
			end
		else
			ent:SetKeyValue("lightcolor", "200 220 255 255")
		end
		ent:SetParent(self)
		ent:Spawn()
		ent:Input("SpotlightTexture", NULL, NULL, "effects/flashlight001")
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
		newmaxhealth = newmaxhealth * owner:GetTotalAdditiveModifier("ControllableHealthMul", "ManhackHealthMul")
		hitdamage = hitdamage * (owner.ManhackDamageMul or 1)
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
				ent:SetLocalPos(Vector(-5, 0, -6.5))
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
		self:EmitSound("npc/manhack/bat_away.wav")
	else
		self:EmitSound("npc/manhack/gib.wav")
	end

	local effectdata = EffectData()
		effectdata:SetOrigin(self:NearestPoint(dmginfo:GetDamagePosition()))
		effectdata:SetNormal(VectorRand():GetNormalized())
		effectdata:SetMagnitude(4)
		effectdata:SetScale(1.33)
	util.Effect("sparks", effectdata)
end

function ENT:Use(pl)
	if pl == self:GetObjectOwner() and pl:Team() == TEAM_HUMAN and pl:Alive() and self:GetVelocity():Length() <= self.HoverSpeed then
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

function ENT:PhysicsSimulate(phys, frametime)
	phys:Wake()

	local owner = self:GetObjectOwner()
	if not owner:IsValid() or self.DisableControlUntil and CurTime() < self.DisableControlUntil then return SIM_NOTHING end

	local vel = phys:GetVelocity()
	local movedir = Vector(0, 0, 0)
	local eyeangles = owner:SyncAngles()
	local aimangles = owner:EyeAngles()

	local trace = {mask = MASK_HOVER, filter = self, start = self:GetPos()}
	local tr, tr2

	if self:BeingControlled() then
		trace.endpos = trace.start - Vector(0, 0, self.HoverHeight * 0.333)
		tr = util.TraceLine(trace)

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
		if owner:KeyDown(IN_BULLRUSH) then
			movedir = movedir + Vector(0, 0, 0.5)
		end
		if owner:KeyDown(IN_GRENADE1) then
			movedir = movedir - Vector(0, 0, 0.5)
		end
		trace.endpos = trace.start + Vector(0, 0, self.HoverHeight * 0.5)
		tr2 = util.TraceLine(trace)

		if tr.Hit and not tr2.Hit then
			movedir.z = 0.5
		end
	end

	if movedir == vector_origin then
		vel = vel * (1 - frametime * self.IdleDrag)
	else
		movedir:Normalize()

		vel = vel + frametime * self.Acceleration * math.Clamp((self:GetObjectHealth() / self:GetMaxObjectHealth() + 1) / 2, 0.5, 1) * movedir
	end

	if vel:Length() > self.MaxSpeed then
		vel:Normalize()
		vel = vel * self.MaxSpeed
	end

	if movedir == vector_origin and vel:Length() <= self.HoverSpeed then
		trace.endpos = trace.start + Vector(0, 0, self.HoverHeight * -2)
		tr = util.TraceLine(trace)

		local hoverdir = (trace.start - tr.HitPos):GetNormalized()
		local hoverfrac = (0.5 - tr.Fraction) * 2
		vel = vel + frametime * hoverfrac * self.HoverForce * hoverdir
	end

	phys:EnableGravity(false)
	phys:SetAngleDragCoefficient(10000)
	phys:SetVelocityInstantaneous(vel)

	local diff = math.AngleDifference(eyeangles.yaw, phys:GetAngles().yaw)
	local z = math.Clamp(diff, -32, 32) * frametime * 10
	local curz = phys:GetAngleVelocity().z
	z = z - curz * (frametime * math.min(1, math.abs(z - curz) ^ 2 * 0.02))

	phys:AddAngleVelocity(Vector(0, 0, z))

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
	local hitentity = false
	local ent = data.HitEntity

	if ent and ent:IsValid() and CurTime() >= (self.NextTouch[ent] or 0) then
		--if ent.LastHeld and CurTime() < ent.LastHeld + 0.1 then return end
		local nest = ent.ZombieConstruction

		hitentity = true

		self.NextTouch[ent] = CurTime() + self.HitCooldown

		ent:TakeSpecialDamage(self.HitDamage, DMG_SLASH, owner, self)

		if ent:IsPlayer() and ent:Team() == TEAM_UNDEAD and ent:Alive() or nest then
			hitflesh = true
		else
			local physattacker = ent:GetPhysicsAttacker()
			if physattacker:IsValid() and physattacker:Team() == TEAM_HUMAN then
				self.PhysDamageImmunity = CurTime() + 0.5
			end
		end
	end

	if hitflesh then
		self:EmitHitFleshSound()

		local dir = (self:GetPos() - data.HitPos):GetNormalized()

		util.Blood(data.HitPos, math.random(10, 14), dir, 200)

		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:AddVelocity(dir * self.BounceFleshVelocity)
		end
	elseif data.DeltaTime > 0.33 and data.Speed > 32 then
		self:EmitHitSound()

		local effectdata = EffectData()
			effectdata:SetOrigin(self:NearestPoint(data.HitPos))
			effectdata:SetNormal(data.HitNormal)
			effectdata:SetMagnitude(2)
			effectdata:SetScale(1)
		util.Effect("sparks", effectdata)
	end

	if hitentity then return end

	local dir = (self:GetPos() - data.HitPos):GetNormalized()

	if data.Speed > self.HoverSpeed then
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:AddVelocity(dir * self.BounceVelocity)
		end
	end

	if ((not owner:IsSkillActive(SKILL_STABLEHULL) and data.Speed >= self.MaxSpeed * 0.75) or (self.LastShadeLaunch and self.LastShadeLaunch + 2 > CurTime())) and
		ent and ent:IsWorld() and CurTime() >= self.PhysDamageImmunity then
		self:TakeDamage(math.Clamp(data.Speed * self.SelfDamageMul, 0, 40))
	end
end

function ENT:EmitHitFleshSound()
	self:EmitSound("npc/manhack/grind_flesh"..math.random(3)..".wav")
end

function ENT:EmitHitSound()
	self:EmitSound("npc/manhack/grind"..math.random(5)..".wav")
end

function ENT:SetupPlayerVisibility(pl)
	if pl ~= self:GetObjectOwner() then return end

	AddOriginToPVS(self:GetPos())
end

if CLIENT then return end

local fhbENT = {}

fhbENT.Type = "anim"

fhbENT.FHB = true

fhbENT.IgnoreMelee = true
fhbENT.IgnoreBullets = true

function fhbENT:Initialize()
	local size = self.Size or 16

	self:SetNoDraw(true)
	self:DrawShadow(false)

	self:SetCollisionGroup(COLLISION_GROUP_WORLD)

	local vecsize = Vector(size, size, size)
	self:PhysicsInitBox(vecsize * -1, vecsize)
	self:SetSolid(SOLID_BBOX)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetCollisionBounds(vecsize * -1, vecsize)

	self:SetUseType(SIMPLE_USE)
end

function fhbENT:Use(ent)
	local parent = self:GetParent()
	if parent:IsValid() then
		parent:Use(ent, ent, 0, 0)
	end
end

function fhbENT:UpdateTransmitState()
	return TRANSMIT_NEVER
end

scripted_ents.Register(fhbENT, "fhb")
