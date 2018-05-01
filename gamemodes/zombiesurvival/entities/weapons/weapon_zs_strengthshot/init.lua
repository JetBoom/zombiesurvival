INC_SERVER()

SWEP.Primary.Projectile = "projectile_strengthdart"
SWEP.Primary.ProjVelocity = 2000

function SWEP:EntModify(ent)
	ent:SetSeeked(self:GetSeekedPlayer() or nil)
	ent.BuffDuration = self.BuffDuration
end
