AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

ENT.NextWaterDamage = 0

function ENT:Initialize()
	self:SetModel("models/combine_scanner.mdl")
	self:SetUseType(SIMPLE_USE)

	self:PhysicsInit(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMass(75)
		phys:EnableDrag(false)
		phys:EnableMotion(true)
		phys:Wake()
		phys:SetBuoyancyRatio(0.8)

		local Constraint = ents.Create("phys_keepupright")
		Constraint:SetAngles(Angle(0, 0, 0))
		Constraint:SetKeyValue("angularlimit", 2)
		Constraint:SetPhysConstraintObjects(phys, phys)
		Constraint:Spawn()
		Constraint:Activate()
		self:DeleteOnRemove(Constraint)
	end

	self:StartMotionController()

	self:SetMaxObjectHealth(100)
	self:SetObjectHealth(self:GetMaxObjectHealth())

	self.LastThink = CurTime()

	self:SetSequence(2)
	self:SetPlaybackRate(1)
	self:UseClientSideAnimation(true)

	--[[local ent = ents.Create("fhb")
	if ent:IsValid() then
		ent:SetPos(self:GetPos())
		ent:SetAngles(self:GetAngles())
		ent:SetParent(self)
		ent:SetOwner(self)
		ent.Size = 9
		ent:Spawn()
	end]]

	self:CollisionRulesChanged()

	hook.Add("SetupPlayerVisibility", self, self.SetupPlayerVisibility)
end

function ENT:SetObjectHealth(health)
	self:SetDTFloat(0, health)

	if health <= 0 then
		self:Destroy()
	end
end

function ENT:OnTakeDamage(dmginfo)
	--if dmginfo:GetDamageType() ~= DMG_CRUSH and not self._AllowDamage then return end

	local attacker = dmginfo:GetAttacker()
	if not (attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN) then
		self:TakePhysicsDamage(dmginfo)

		self:SetObjectHealth(self:GetObjectHealth() - dmginfo:GetDamage())

		--self:EmitSound("npc/scanner/scanner_pain"..math.random(2)..".wav", 0.65, math.Rand(120, 130))
		self:EmitSound("npc/manhack/gib.wav")

		local effectdata = EffectData()
			effectdata:SetOrigin(self:NearestPoint(dmginfo:GetDamagePosition()))
			effectdata:SetNormal(VectorRand():GetNormalized())
			effectdata:SetMagnitude(4)
			effectdata:SetScale(1.33)
		util.Effect("sparks", effectdata)
	end
end

function ENT:Use(pl)
	if pl == self:GetOwner() and pl:Team() == TEAM_HUMAN and pl:Alive() and self:GetVelocity():Length() <= self.HoverSpeed then
		self:OnPackedUp(pl)
	end
end

function ENT:PhysicsCollide(data, phys)
	self.HitData = data
	self:NextThink(CurTime())
end

function ENT:OnPackedUp(pl)
	pl:GiveEmptyWeapon("weapon_zs_drone")
	pl:GiveAmmo(1, "drone")

	pl:PushPackedItem(self:GetClass(), self:GetObjectHealth())

	self:Remove()
end

function ENT:PhysicsSimulate(phys, frametime)
	phys:Wake()

	local owner = self:GetOwner()
	if not owner:IsValid() then return SIM_NOTHING end

	local vel = phys:GetVelocity()
	local movedir = Vector()
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
	phys:AddAngleVelocity(Vector(0, 0, math.Clamp(math.AngleDifference(eyeangles.yaw, phys:GetAngles().yaw), -32, 32) * frametime * 3))

	return SIM_NOTHING
end

function ENT:Destroy()
	if self.Destroyed then return end
	self.Destroyed = true

	self:EmitSound("npc/manhack/gib.wav")

	local effectdata = EffectData()
		effectdata:SetOrigin(self:LocalToWorld(self:OBBCenter()))
	util.Effect("HelicopterMegaBomb", effectdata, true, true)
		effectdata:SetNormal(Vector(0, 0, 1))
		effectdata:SetMagnitude(5)
		effectdata:SetScale(1.5)
	util.Effect("sparks", effectdata)
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

	local owner = self:GetOwner()
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
	if not data then return end
	self.HitData = nil

	local ent = data.HitEntity
	if ent and ent:IsValid() then
		local physattacker = ent:GetPhysicsAttacker()
		if physattacker:IsValid() and physattacker:Team() == TEAM_HUMAN then
			self.PhysDamageImmunity = CurTime() + 0.5
		end
	end

	local dir = (self:GetPos() - data.HitPos):GetNormalized()

	if data.Speed > self.HoverSpeed then
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:AddVelocity(dir * 50)
		end
	end

	if data.Speed >= self.MaxSpeed * 0.75 and ent and ent:IsWorld() and CurTime() >= self.PhysDamageImmunity then
		self:TakeDamage(math.Clamp(data.Speed * 0.11, 0, 40))
	end
end

function ENT:SetupPlayerVisibility(pl)
	if pl ~= self:GetOwner() then return end

	AddOriginToPVS(self:GetPos())
end
