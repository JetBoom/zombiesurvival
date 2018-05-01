AddCSLuaFile()

SWEP.Base = "weapon_zs_gunturret"

SWEP.PrintName = "Rocket Turret"
SWEP.Description = "An automated turret that fires explosive missiles.\nPress PRIMARY ATTACK to deploy the turret.\nPress SECONDARY ATTACK and RELOAD to rotate the turret.\nPress USE on a deployed turret to give it some of your explosive ammunition.\nPress USE on a deployed turret with no owner (blue light) to reclaim it."

SWEP.Primary.Damage = 104

SWEP.GhostStatus = "ghost_gunturret_rocket"
SWEP.DeployClass = "prop_gunturret_rocket"
SWEP.TurretAmmoType = "impactmine"
SWEP.TurretAmmoStartAmount = 12
SWEP.TurretSpread = 1

SWEP.Primary.Ammo = "turret_rocket"

SWEP.Tier = 4

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_TURRET_SPREAD, -0.45)
