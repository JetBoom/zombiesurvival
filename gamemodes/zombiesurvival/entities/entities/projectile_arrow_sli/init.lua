INC_SERVER()

function ENT:Initialize()
	self:SetModel("models/Items/CrossbowRounds.mdl")
	self:PhysicsInitSphere(1)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetModelScale(0.55, 0)
	self:SetupGenericProjectile(true)

	self.TimeCreated = CurTime()
end

function ENT:Think()
	self:NextThink(CurTime())

	local owner = self:GetOwner()
	if not owner:IsValid() then owner = self end

	if self.Touched and not self.Damaged then
		self.Damaged = true

		local airtime = CurTime() - self.TimeCreated
		local dmgmul = math.Clamp(1 + airtime * 1.2, 1, 1.6)
		local alt2 = self:GetDTBool(1)

		local tr = self.Touched

		self:DealProjectileTraceDamage((self.ProjDamage or 66) * (alt2 and dmgmul or 1), tr, owner)

		util.Blood(tr.Entity:WorldSpaceCenter(), math.max(0, 15), -self:GetForward(), math.Rand(100, 300), true)

		self:EmitSound("weapons/crossbow/hitbod"..math.random(2)..".wav", 75, 80)
		self:Remove()
	elseif self.HitData then
		self:Remove()
	end
	return true
end
