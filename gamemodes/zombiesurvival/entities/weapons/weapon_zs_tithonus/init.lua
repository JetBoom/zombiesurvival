INC_SERVER()

SWEP.Primary.Projectile = "projectile_tithonus"
SWEP.Primary.ProjVelocity = 1100

function SWEP:Think()
	self:CheckCharge()

	if self:GetReloadFinish() > 0 then
		if CurTime() >= self:GetReloadFinish() then
			self:FinishReload()
		end
	elseif self.IdleAnimation and self.IdleAnimation <= CurTime() then
		self.IdleAnimation = nil
		self:SendWeaponAnim(ACT_VM_IDLE)
	end
end
