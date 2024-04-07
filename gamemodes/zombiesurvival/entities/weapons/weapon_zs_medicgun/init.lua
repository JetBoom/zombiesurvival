INC_SERVER()

SWEP.Primary.Projectile = "projectile_healdart"
SWEP.Primary.ProjVelocity = 2000

function SWEP:EntModify(ent)
	local owner = self:GetOwner()

	ent:SetSeeked(self:GetSeekedPlayer() or nil)
	ent.Heal = self.Heal * (owner.MedDartEffMul or 1)
	ent.BuffDuration = self.BuffDuration
end
