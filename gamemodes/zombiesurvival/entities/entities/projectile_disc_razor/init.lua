INC_SERVER()

function ENT:Initialize()
	self.Bounces = self.Secondary and 4 or 0

	self:SetModel("models/props_junk/sawblade001a.mdl")
	self:PhysicsInitSphere(1)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetModelScale(0.25, 0)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetupGenericProjectile(false)

	self:Fire("kill", "", 3)
end

function ENT:PhysicsUpdate(phys)
	self:ProjectileTraceAhead(phys)
end

function ENT:PhysicsCollide(data, phys)
	if self.HitData then return end

	if self.Bounces <= 3 and data.HitEntity and data.HitEntity:IsWorld() then
		local normal = data.OurOldVelocity:GetNormalized()
		phys:SetVelocityInstantaneous((2 * data.HitNormal * data.HitNormal:Dot(normal * -1) + normal) * 1500)

		self:EmitSound("physics/metal/sawblade_stick3.wav", 70, 250)

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
		local tr = self.Touched

		self.Damaged = true
		self:DealProjectileTraceDamage(self.ProjDamage or 77, tr, owner)

		util.Blood(tr.Entity:WorldSpaceCenter(), math.max(0, 15), -self:GetForward(), math.Rand(100, 300), true)

		self:Remove()
	elseif self.HitData then
		self:Remove()
	end
end
