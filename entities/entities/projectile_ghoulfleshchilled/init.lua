INC_SERVER()

function ENT:Initialize()
	self.DeathTime = CurTime() + 30

	self:SetModel("models/props/cs_italy/orange.mdl")
	self:SetMaterial("models/seagull/seagull")
	self:PhysicsInitSphere(1)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetColor(Color(0, 125, 255, 255))
	self:SetupGenericProjectile(true)
end

function ENT:Think()
	if self.PhysicsData then
		self:Hit(self.PhysicsData.HitPos, self.PhysicsData.HitNormal, self.PhysicsData.HitEntity)
	end

	if self.DeathTime <= CurTime() then
		self:Remove()
	end
end

function ENT:Hit(vHitPos, vHitNormal, eHitEntity)
	if self.Exploded then return end
	self.Exploded = true
	self.DeathTime = 0

	local owner = self:GetOwner()
	if not owner:IsValid() then owner = self end

	vHitPos = vHitPos or self:GetPos()
	vHitNormal = vHitNormal or Vector(0, 0, 1)

	if eHitEntity:IsValidLivingPlayer() and gamemode.Call("PlayerShouldTakeDamage", eHitEntity, owner) then
		eHitEntity:GiveStatus("frost", 5)
	end

	local effectdata = EffectData()
		effectdata:SetOrigin(vHitPos)
		effectdata:SetNormal(vHitNormal)
	util.Effect("hit_frost", effectdata)
end

function ENT:PhysicsCollide(data, phys)
	if not self:HitFence(data, phys) then
		self.PhysicsData = data
	end

	self:NextThink(CurTime())
end
