INC_SERVER()

ENT.Damage = 4

function ENT:Initialize()
	self.DeathTime = CurTime() + 30

	self:DrawShadow(false)
	self:PhysicsInitSphere(1)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetupGenericProjectile(true)
end

function ENT:Think()
	if self.PhysicsData then
		self:Explode(self.PhysicsData.HitPos, self.PhysicsData.HitNormal, self.PhysicsData.HitEntity)
	end

	if self.DeathTime <= CurTime() then
		self:Remove()
	end
end

function ENT:Explode(vHitPos, vHitNormal, eHitEntity)
	if self.Exploded then return end
	self.Exploded = true
	self.DeathTime = 0

	local owner = self:GetOwner()
	if not owner:IsValid() then owner = self end

	vHitPos = vHitPos or self:GetPos()
	vHitNormal = vHitNormal or Vector(0, 0, 1)

	if eHitEntity:IsValid() then
		eHitEntity:PoisonDamage(self.Damage, owner, self)
	end

	local effectdata = EffectData()
		effectdata:SetOrigin(vHitPos)
		effectdata:SetNormal(vHitNormal)
	util.Effect("hit_flesh", effectdata)
end

function ENT:PhysicsCollide(data, phys)
	if not self:HitFence(data, phys) then
		self.PhysicsData = data
	end

	self:NextThink(CurTime())
end
