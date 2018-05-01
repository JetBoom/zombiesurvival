AddCSLuaFile()

SWEP.Base = "weapon_zs_gunturret"

SWEP.PrintName = "Assault Turret"
SWEP.Description = "A heavier turret that uses assault rifle ammo.\nPress PRIMARY ATTACK to deploy the turret.\nPress SECONDARY ATTACK and RELOAD to rotate the turret.\nPress USE on a deployed turret to give it some of your buckshot ammunition.\nPress USE on a deployed turret with no owner (blue light) to reclaim it."

SWEP.Primary.Damage = 22.5

SWEP.GhostStatus = "ghost_gunturret_assault"
SWEP.DeployClass = "prop_gunturret_assault"

SWEP.TurretAmmoType = "ar2"
SWEP.TurretAmmoStartAmount = 100
SWEP.TurretSpread = 2

SWEP.Tier = 4

SWEP.Primary.Ammo = "turret_assault"

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_TURRET_SPREAD, -0.5)
