INC_SERVER()

ENT.PointsMultiplier = 1.25

function ENT:Initialize()
	self:SetModel("models/dav0r/hoverball.mdl")
	self:PhysicsInitSphere(1)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetModelScale(0.25, 0)
	self:SetupGenericProjectile(false)

	self:Fire("kill", "", 1)
end

function ENT:PhysicsUpdate(phys)
	self:ProjectileTraceAhead(phys)
end

function ENT:PhysicsCollide(data, phys)
	if self.HitData then return end
	self.HitData = data
	self:NextThink(CurTime())
end

function ENT:Think()
	local owner = self:GetOwner()
	if not owner:IsValid() then owner = self end

	if self.Touched and not self.Damaged then
		self.Damaged = true

		local tr = self.Touched

		if self.PointsMultiplier then
			POINTSMULTIPLIER = self.PointsMultiplier
		end
		self:DealProjectileTraceDamage(self.ProjDamage or 19, tr, owner)
		if tr.Entity:IsPlayer() then
			tr.Entity:AddLegDamageExt(5.5, owner, source, SLOWTYPE_PULSE)
		end
		if self.PointsMultiplier then
			POINTSMULTIPLIER = nil
		end

		util.Blood(tr.Entity:WorldSpaceCenter(), math.max(0, 15), -self:GetForward(), math.Rand(100, 300), true)

		self:Remove()
	elseif self.HitData then
		self:Remove()
	end
end
