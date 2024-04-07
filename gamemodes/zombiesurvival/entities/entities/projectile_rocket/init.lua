INC_SERVER()

function ENT:Initialize()
	self.DieTime = CurTime() + 4

	self:SetModel("models/weapons/w_missile_closed.mdl")
	self:PhysicsInitSphere(1)
	self:SetSolid(SOLID_VPHYSICS)

	if self:GetDTBool(0) then
		self:SetModelScale(0.4, 0)
	end

	self:SetupGenericProjectile(false)
end

function ENT:Think()
	if self.PhysicsData then
		self:Explode()
	end

	if self.Exploded then
		local pos = self:GetPos()
		local alt = self:GetDTBool(0)

		if not alt then
			local effectdata = EffectData()
				effectdata:SetOrigin(pos)
			util.Effect("Explosion", effectdata)
			util.Effect("explosion_rocket", effectdata)
		else
			self:EmitSound(")weapons/explode5.wav", 80, 130)
		end

		self:Remove()
	elseif self.DieTime <= CurTime() then
		self:Explode()
	end
end

function ENT:Explode()
	if self.Exploded then return end
	self.Exploded = true

	local owner = self:GetOwner()
	if owner:IsValidHuman() then
		local pos = self:GetPos()

		local source = self:ProjectileDamageSource()
		util.BlastDamagePlayer(source, owner, pos, 85, self.ProjDamage, DMG_ALWAYSGIB, self.ProjTaper)
	end
end

function ENT:PhysicsCollide(data, phys)
	self.PhysicsData = data
	self:NextThink(CurTime())
end
