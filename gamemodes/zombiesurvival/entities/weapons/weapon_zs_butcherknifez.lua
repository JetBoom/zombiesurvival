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

function SWEP:PostOnMeleeHit(hitent, hitflesh, tr)
	self.MeleeDamage = 24
end
