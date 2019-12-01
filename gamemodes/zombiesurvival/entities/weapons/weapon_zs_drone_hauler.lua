AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_drone")

SWEP.Base = "weapon_zs_drone"

SWEP.PrintName = ""..translate.Get"dpl_haulerdrone_name"
SWEP.Description = ""..translate.Get"dpl_haulerdrone_desc"

SWEP.Primary.Ammo = "drone_hauler"

SWEP.DeployClass = "prop_drone_hauler"
SWEP.DeployAmmoType = false
SWEP.ResupplyAmmoType = nil
