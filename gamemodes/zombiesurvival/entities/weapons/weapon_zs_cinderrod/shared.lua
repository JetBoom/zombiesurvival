SWEP.PrintName = "'Cinderrod' Zip Gun"

SWEP.Base = "weapon_zs_blareduct"

SWEP.Primary.Damage = 54
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 1.5

SWEP.ConeMax = 7.5
SWEP.ConeMin = 6.5

SWEP.ReloadSpeed = 0.35
SWEP.ReloadDelay = 0.45

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.15, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RECOIL, -32.5)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -1)
