INC_SERVER()

SWEP.NextAura = 0
function SWEP:Think()
	if self.IdleAnimation and self.IdleAnimation <= CurTime() then
		self.IdleAnimation = nil
		self:SendWeaponAnim(ACT_VM_IDLE)
	end

	if self.NextAura <= CurTime() then
		self.NextAura = CurTime() + 2

		local origin = self:GetOwner():LocalToWorld(self:GetOwner():OBBCenter())
		for _, ent in pairs(ents.FindInSphere(origin, 40)) do
			if ent and ent:IsValidLivingHuman() and TrueVisible(origin, ent:NearestPoint(origin)) then
				ent:PoisonDamage(1, self:GetOwner(), self)
			end
		end
	end
end
