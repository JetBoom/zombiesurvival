AddCSLuaFile()

SWEP.Base = "weapon_zs_gunturret"

SWEP.PrintName = translate.Get"dpl_assaultturret_name"
SWEP.Description = translate.Get"dpl_assaultturret_desc"

SWEP.Primary.Damage = 22.5

SWEP.GhostStatus = "ghost_gunturret_assault"
SWEP.DeployClass = "prop_gunturret_assault"

SWEP.TurretAmmoType = "ar2"
SWEP.TurretAmmoStartAmount = 100
SWEP.TurretSpread = 2

SWEP.Tier = 4

SWEP.Primary.Ammo = "turret_assault"

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_TURRET_SPREAD, -0.5)
