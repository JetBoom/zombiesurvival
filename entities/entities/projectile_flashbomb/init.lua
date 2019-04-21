INC_SERVER()

function ENT:Initialize()
	self:SetModel("models/weapons/w_eq_flashbang_thrown.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:SetMass(1)
		phys:SetMaterial("metal")
	end

	self.DieTime = CurTime() + self.LifeTime
	self:NextThink(self.DieTime)
end

function ENT:PhysicsCollide(data, phys)
	if 20 < data.Speed and 0.25 < data.DeltaTime then
		self:EmitSound("weapons/flashbang/grenade_hit1.wav")
	end
end

function ENT:Think()
	if CurTime() >= self.DieTime then
		self:Remove()
	end
end

function ENT:OnRemove()
	self:Explode()
end

function ENT:Explode()
	if self.Exploded then return end
	self.Exploded = true

	local owner = self:GetOwner()
	local pos = self:GetPos()

	for _, ent in pairs(ents.FindInSphere(pos, self.Radius)) do
		if ent:IsValid() and ent:IsPlayer() and ent:Alive() and (ent:Team() == TEAM_UNDEAD or ent == owner) then
			local eyepos = ent:EyePos()
			if TrueVisibleFilters(pos, eyepos, self, ent) then
				local eyevec = ent:GetAimVector()
				local strength = (1 - eyepos:Distance(pos) / self.Radius) ^ 0.5 * (0.3 + math.Clamp((pos - eyepos):GetNormalized():Dot(eyevec), 0, 1) * 0.7)

				ent:AddLegDamage(strength)
				local time = (0.5 + strength * 1.5) * (ent.VisionAlterDurationMul or 1)
				ent:ScreenFade(SCREENFADE.IN, nil, time, time)
				ent:SetDSP(36)
				if strength > 0.4 then ent:GiveStatus("disorientation", time * 2) end

				if ent:Team() == TEAM_UNDEAD then
					ent:TakeDamage(1, owner, self)
				end
			end
		end
	end

	self:EmitSound("weapons/flashbang/flashbang_explode2.wav")

	local effectdata = EffectData()
		effectdata:SetOrigin(pos)
	util.Effect("HelicopterMegaBomb", effectdata)
end
