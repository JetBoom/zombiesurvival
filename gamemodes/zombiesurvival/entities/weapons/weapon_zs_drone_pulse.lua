AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_drone")

SWEP.Base = "weapon_zs_drone"

SWEP.PrintName = "Pulse Drone"
SWEP.Description = "A deployable, remotely controlled device.\nIdeal for scouting, retrieval, and targeted attacks.\nUses projectiles instead of bullets."

SWEP.Primary.Ammo = "pulse_cutter"

SWEP.DeployClass = "prop_drone_pulse"
SWEP.DeployAmmoType = "pulse"
SWEP.ResupplyAmmoType = "pulse"
