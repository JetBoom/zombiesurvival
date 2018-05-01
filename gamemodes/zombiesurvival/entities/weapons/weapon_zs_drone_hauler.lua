AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_drone")

SWEP.Base = "weapon_zs_drone"

SWEP.PrintName = "Hauler Drone"
SWEP.Description = "A hauling drone.\nIdeal for scouting and retrieval.\nCarries props and items around at immense speeds, but cannot attack."

SWEP.Primary.Ammo = "drone_hauler"

SWEP.DeployClass = "prop_drone_hauler"
SWEP.DeployAmmoType = false
SWEP.ResupplyAmmoType = nil
