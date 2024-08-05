AddCSLuaFile()

SWEP.Base = "weapon_zs_butcherknife"

SWEP.ZombieOnly = true
SWEP.MeleeDamage = 30
SWEP.Primary.Delay = 0.4

function SWEP:OnMeleeHit(hitent, hitflesh, tr)
	if not hitent:IsPlayer() then
		self.MeleeDamage = 11
	end
end

SWEP.MeleeCount = 0

function SWEP:PostOnMeleeHit(hitent, hitflesh, tr)
	self.MeleeDamage = 30
	self.MeleeCount = self.MeleeCount + 1
end
