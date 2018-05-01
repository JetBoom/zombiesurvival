INC_SERVER()

ENT.NextWaterDamage = 0

function ENT:Initialize()
	self:SetModel("models/shield_scanner.mdl")
	self:SetUseType(SIMPLE_USE)

	self:PhysicsInitBox(Vector(-30, -17, -14.15), Vector(18.29, 11.86, 15))
	self:PhysicsInit(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMaterial("metal")
		phys:SetMass(75)
		phys:EnableDrag(false)
		phys:EnableMotion(true)
		phys:Wake()
		phys:SetBuoyancyRatio(0.8)
		phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)

		local Constraint = ents.Create("phys_keepupright")
		Constraint:SetAngles(Angle(0, 0, 0))
		Constraint:SetKeyValue("angularlimit", 2)
		Constraint:SetPhysConstraintObjects(phys, phys)
		Constraint:Spawn()
		Constraint:Activate()
		self:DeleteOnRemove(Constraint)
	end

	self:StartMotionController()

	self:SetMaxObjectHealth(self.MaxHealth)
	self:SetObjectHealth(self:GetMaxObjectHealth())

	self.LastThink = CurTime()

	self:ResetSequence(5)
	self:SetPlaybackRate(1)
	self:UseClientSideAnimation(true)
	self:SetCustomCollisionCheck(true)
	self:CollisionRulesChanged()

	hook.Add("SetupPlayerVisibility", self, self.SetupPlayerVisibility)
end

function ENT:SetupPlayerSkills()
	local owner = self:GetObjectOwner()
	local newmaxhealth = self.MaxHealth
	local currentmaxhealth = self:GetMaxObjectHealth()
	local defaults = scripted_ents.Get(self:GetClass())
	local maxspeed = defaults.MaxSpeed
	local acceleration = defaults.Acceleration
	local loaded = false

	if owner:IsValid() then
		newmaxhealth = newmaxhealth * (owner.ControllableHealthMul or 1)
		maxspeed = maxspeed * owner:GetTotalAdditiveModifier("ControllableSpeedMul", "DroneSpeedMul")
		acceleration = acceleration * (owner.ControllableHandlingMul or 1)
		loaded = owner:IsSkillActive(SKILL_LOADEDHULL)
	end

	newmaxhealth = math.ceil(newmaxhealth)

	self:SetMaxObjectHealth(newmaxhealth)
	self:SetObjectHealth(self:GetObjectHealth() / currentmaxhealth * newmaxhealth)

	self.MaxSpeed = maxspeed
	self.Acceleration = acceleration

	if loaded then
		if not IsValid(self.LoadedProp) then
			local ent = ents.Create("prop_dynamic_override")
			if ent:IsValid() then
				ent:SetModel("models/props_junk/propane_tank001a.mdl")
				ent:SetModelScale(0.65, 0)
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

function ENT:OnRemove()
	self:RestoreGrappledEntityProperties()
end

function ENT:RestoreGrappledEntityProperties()
	local ent = self.GrappledEnt
	if IsValid(ent) and ent._OriginalMass then
		local phys = ent:GetPhysicsObject()
		if phys:IsValid() then
			phys:SetMass(ent._OriginalMass)
			phys:ClearGameFlag(FVPHYSICS_PLAYER_HELD)
			phys:ClearGameFlag(FVPHYSICS_NO_IMPACT_DMG)
			phys:ClearGameFlag(FVPHYSICS_NO_NPC_IMPACT_DMG)
			ent._OriginalMass = nil

			local owner = self:GetObjectOwner()
			if owner:IsValidPlayer() then
				ent:SetPhysicsAttacker(owner)
			end
		end
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

	self:EmitSound("npc/scanner/scanner_pain"..math.random(2)..".wav", 65, math.Rand(120, 130))

	local effectdata = EffectData()
		effectdata:SetOrigin(self:NearestPoint(dmginfo:GetDamagePosition()))
		effectdata:SetNormal(VectorRand():GetNormalized())
		effectdata:SetMagnitude(4)
		effectdata:SetScale(1.33)
	util.Effect("sparks", effectdata)
end

function ENT:Use(activator, caller)
end

function ENT:AltUse(activator, tr)
	self:PackUp(activator)
end

function ENT:PhysicsCollide(data, phys)
	self.HitData = data
	self:NextThink(CurTime())
end

function ENT:OnPackedUp(pl)
	pl:GiveEmptyWeapon(self.SWEP)
	pl:GiveAmmo(1, self.DeployableAmmo)

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

	if self:BeingControlled() then
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
		local angdiff = math.AngleDifference(eyeangles.yaw, phys:GetAngles().yaw)
		if math.abs(angdiff) > 4 then
			phys:AddAngleVelocity(Vector(0, 0, math.Clamp(angdiff, -64, 64) * frametime * 100 - phys:GetAngleVelocity().z * 0.95))
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
		local trace = {mask = MASK_HOVER, filter = self}
		trace.start = self:GetPos()
		trace.endpos = trace.start + Vector(0, 0, self.HoverHeight * -2)
		local tr = util.TraceLine(trace)

		local hoverdir = (trace.start - tr.HitPos):GetNormalized()
		local hoverfrac = (0.5 - tr.Fraction) * 2
		vel = vel + frametime * hoverfrac * self.HoverForce * hoverdir
	end

	phys:EnableGravity(false)
	phys:SetAngleDragCoefficient(20000)
	phys:SetVelocityInstantaneous(vel)

	self:SetPhysicsAttacker(owner)

	return SIM_NOTHING
end

function ENT:Destroy()
	if self.Destroyed then return end
	self.Destroyed = true

	local pos = self:LocalToWorld(self:OBBCenter())

	self:EmitSound("npc/scanner/scanner_explode_crash2.wav")

	local effectdata = EffectData()
		effectdata:SetOrigin(pos)
		effectdata:SetNormal(Vector(0, 0, 1))
		effectdata:SetMagnitude(5)
		effectdata:SetScale(1.5)
	util.Effect("sparks", effectdata)

	local owner = self:GetObjectOwner()
	if owner:IsValidLivingHuman() and owner:IsSkillActive(SKILL_LOADEDHULL) then
		effectdata = EffectData()
			effectdata:SetOrigin(pos)
			effectdata:SetNormal(Vector(0, 0, -1))
		util.Effect("decal_scorch", effectdata)

		self:EmitSound("npc/env_headcrabcanister/explosion.wav", 100, 100)
		ParticleEffect("dusty_explosion_rockets", pos, angle_zero)

		util.BlastDamagePlayer(self, owner, pos, 128, 225, DMG_ALWAYSGIB)
	else
		util.Effect("HelicopterMegaBomb", effectdata, true, true)
	end
end

ENT.GrappledEnt = nil
local carryclasses = {"prop_ammo", "prop_weapon", "prop_invitem", "prop_physics", "prop_physics_multiplayer", "func_physbox"}
function ENT:RopeAttach()
	if CurTime() < self:GetNextFire() then return end
	self:SetNextFire(CurTime() + 0.5)

	if self:IsGrappling() then
		constraint.RemoveConstraints(self, "Rope")
		self:EmitSound("npc/scanner/scanner_scan1.wav")
		self:RestoreGrappledEntityProperties()
		self:SetGrappling(false)
		self.GrappledEnt = nil

		return
	end

	local owner = self:GetObjectOwner()
	local start = self:GetCameraPosition()
	local filter = self:GetTraceFilter()
	local tr = util.TraceLine({start = start, endpos = start + owner:EyeAngles():Forward() * 128, mask = MASK_SOLID, filter = filter})

	local ropetraceent = tr.Entity
	if tr.Hit and ropetraceent and ropetraceent:IsValid() then
		local entclass = ropetraceent:GetClass()
		if table.HasValue(carryclasses, entclass) then
			local phys = ropetraceent:GetPhysicsObject()
			if phys:IsValid() and phys:GetMass() <= self.CarryMass and phys:IsMoveable() and not phys:HasGameFlag(FVPHYSICS_PLAYER_HELD) and (ropetraceent:OBBMins():Length() + ropetraceent:OBBMaxs():Length() < CARRY_DRAG_VOLUME or ropetraceent.NoVolumeCarryCheck) and not constraint.HasConstraints(ropetraceent) then
				local rope = constraint.Rope(self, ropetraceent, 0, tr.PhysicsBone, vector_origin, WorldToLocal(tr.HitPos, angle_zero, ropetraceent:GetPos(), ropetraceent:GetAngles()), 0, 140, 2000, 1.5, "cable/rope.vmt", false)
				if not rope then
					return
				end
				self.GrappleCheckTime = CurTime() + 2
				self.GrappledEnt = ropetraceent
				self.GrappleRope = rope
				self:EmitSound("ambient/machines/catapult_throw.wav")
				self:SetGrappling(true)

				ropetraceent._OriginalMass = ropetraceent._OriginalMass or phys:GetMass()
				phys:SetMass(2)
				phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
				phys:AddGameFlag(FVPHYSICS_NO_NPC_IMPACT_DMG)
				phys:AddGameFlag(FVPHYSICS_PLAYER_HELD)
			end
		end
	else
		self:EmitSound("npc/scanner/scanner_scan4.wav", 55)
	end
end

ENT.PhysDamageImmunity = 0
ENT.GrappleCheckTime = 0
function ENT:Think()
	if self.Destroyed then
		if not self.CreatedDebris then
			self.CreatedDebris = true

			if self:GetObjectOwner():IsValidLivingHuman() then
				self:GetObjectOwner():SendDeployableLostMessage(self)
			end

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
		if IsValid(self.GrappledEnt) then
			self.GrappledEnt:SetPhysicsAttacker(owner)
		end

		if not owner:Alive() or owner:Team() ~= TEAM_HUMAN then
			self:Destroy()
			return
		end
	else
		self:Destroy()
		return
	end

	if self:BeingControlled() and owner:KeyDown(IN_ATTACK) then
		self:RopeAttach()
	end

	if self.GrappleCheckTime <= CurTime() and self:IsGrappling() then
		if not IsValid(self.GrappledEnt) or not IsValid(self.GrappleRope) then
			constraint.RemoveConstraints(self, "Rope")
			self:EmitSound("npc/scanner/scanner_alert1.wav")
			self:SetGrappling(false)
			self:RestoreGrappledEntityProperties()
			self.GrappledEnt = nil
			self.GrappleRope = nil
		end
		self.GrappleCheckTime = CurTime() + 2
	end

	if self:WaterLevel() >= 2 and CurTime() >= self.NextWaterDamage then
		self.NextWaterDamage = CurTime() + 0.2

		self:TakeDamage(10)
	end

	self:NextThink(CurTime())

	local data = self.HitData
	if not data then return true end
	self.HitData = nil

	local ent = data.HitEntity
	if ent and ent:IsValid() then
		local physattacker = ent:GetPhysicsAttacker()
		if physattacker:IsValid() and physattacker:Team() == TEAM_HUMAN then
			self.PhysDamageImmunity = CurTime() + 0.5
		end
	end

	if data.Speed > self.HoverSpeed then
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			local dir = self:GetPos() - data.HitPos
			dir:Normalize()
			phys:AddVelocity(dir * 20)
		end
	end

	if ((not owner:IsSkillActive(SKILL_STABLEHULL) and data.Speed >= self.MaxSpeed * 0.75) or (self.LastShadeLaunch and self.LastShadeLaunch + 2 > CurTime())) and
	 	ent and ent:IsWorld() and CurTime() >= self.PhysDamageImmunity then
		self:TakeDamage(math.Clamp(data.Speed * 0.11, 0, 40))
	end

	return true
end

function ENT:SetupPlayerVisibility(pl)
	if pl ~= self:GetObjectOwner() then return end

	AddOriginToPVS(self:GetPos())
	AddOriginToPVS(self:GetPos() + pl:GetAimVector() * 1024)
end

function ENT:SetObjectHealth(health)
	self:SetDTFloat(0, health)

	if health <= 0 and not self.Destroyed then
		self.Destroyed = true
	end
end

function ENT:SetNextFire(tim)
	self:SetDTFloat(2, tim)
end

function ENT:SetMaxObjectHealth(health)
	self:SetDTFloat(1, health)
end

function ENT:SetGrappling(onoff)
	self:SetDTBool(1, onoff)
end
