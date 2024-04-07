INC_SERVER()

ENT.PointsMultiplier = 1.25

function ENT:Initialize()
	self.Bounces = 0

	self:SetModel("models/dav0r/hoverball.mdl")
	self:PhysicsInitSphere(2)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetModelScale(self.Branch and 0.15 or 0.25, 0)
	self:SetupGenericProjectile(false)

	self:Fire("kill", "", 3)
	self.Creation = UnPredictedCurTime()
end

function ENT:PhysicsUpdate(phys)
	self:ProjectileTraceAhead(phys)

	if not self.Branch then return end

	local livetime = UnPredictedCurTime() - self.Creation
	local vel = phys:GetVelocity()
	local physang = vel:Angle()
	local vr = physang:Right() * math.cos(CurTime() * 5) * (1 + livetime) * 3 * (self.ShotMarker == 0 and 1 or -1)

	local newvel = vel + vr

	phys:SetVelocityInstantaneous(newvel)
end

function ENT:PhysicsCollide(data, phys)
	if self.HitData then return end

	if self.Bounces <= 1 and data.HitEntity and data.HitEntity:IsWorld() then
		local normal = data.OurOldVelocity:GetNormalized()
		phys:SetVelocityInstantaneous((2 * data.HitNormal * data.HitNormal:Dot(normal * -1) + normal) * 700)

		self:EmitSound("ambient/levels/citadel/weapon_disintegrate3.wav", 70, 210)

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

		if self.PointsMultiplier then
			POINTSMULTIPLIER = self.PointsMultiplier
		end
		self:DealProjectileTraceDamage(self.ProjDamage or 77, tr, owner)
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
