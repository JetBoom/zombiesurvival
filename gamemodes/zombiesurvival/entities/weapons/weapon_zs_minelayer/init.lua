INC_SERVER()

SWEP.Primary.Projectile = "projectile_impactmine"
SWEP.Primary.ProjVelocity = 600

function SWEP:PhysModify(physobj)
	physobj:AddAngleVelocity(VectorRand():GetNormalized() * 90)
end
