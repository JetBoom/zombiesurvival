INC_SERVER()

function ENT:Initialize()
	self.Bounces = 0

	self:SetModel("models/dav0r/hoverball.mdl")
	self:PhysicsInitSphere(1)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetModelScale(0.05, 0)
	self:SetupGenericProjectile(true)

	self:Fire("kill", "", 2)
end

function ENT:PhysicsUpdate(phys)
	self:ProjectileTraceAhead(phys)
end

function ENT:Explode(hitpos, hitnormal)
	if self.Exploded then return end
	self.Exploded = true

	hitpos = hitpos or self:GetPos()
	hitnormal = hitnormal or self:GetForward()
end

function ENT:PhysicsCollide(data, phys)
	if self.HitData then return end

	if self.Bounces <= 1 and data.HitEntity and data.HitEntity:IsWorld() then
		local normal = data.OurOldVelocity:GetNormalized()
		phys:SetVelocityInstantaneous((2 * data.HitNormal * data.HitNormal:Dot(normal * -1) + normal) * 500)

		self:EmitSound("physics/metal/metal_box_impact_bullet3.wav", 65, 250)

		self.Bounces = self.Bounces + 1
	else
		self.HitData = data
	end

	self:NextThink(CurTime())
end

function ENT:Think()
	local owner = self:GetOwner()
	if not owner:IsValid() then owner = self end

	if self.Touched and not self.Damaged then
		self.Damaged = true

		local tr = self.Touched

		self:DealProjectileTraceDamage((self.ProjDamage or 22)/(self.Bounces + 1), tr, owner)
		util.Blood(tr.HitPos, math.max(0, 15), -self:GetForward(), math.Rand(100, 300), true)

		self:Remove()
	elseif self.HitData then
		self:Remove()
	end
end
