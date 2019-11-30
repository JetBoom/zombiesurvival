AddCSLuaFile()

SWEP.Base = "weapon_zs_gunturret"

SWEP.PrintName = translate.Get"dpl_blastturret_name"
SWEP.Description = translate.Get"dpl_blastturret_desc"

SWEP.Primary.Damage = 6.75

SWEP.GhostStatus = "ghost_gunturret_buckshot"
SWEP.DeployClass = "prop_gunturret_buckshot"
SWEP.TurretAmmoType = "buckshot"
SWEP.TurretAmmoStartAmount = 25
SWEP.TurretSpread = 5

SWEP.Primary.Ammo = "turret_buckshot"

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_TURRET_SPREAD, -0.9)
