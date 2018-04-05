AddCSLuaFile()

SWEP.Base = "weapon_zs_basemelee"

if CLIENT then
	SWEP.PrintName = "Food"

	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false

	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false
end

SWEP.ViewModel = "models/weapons/c_stunstick.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.UseHands = true

SWEP.HoldType = "slam"

SWEP.Primary.ClipSize = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "watermelon"
SWEP.Primary.Delay = 1
SWEP.Primary.DefaultClip = 1

SWEP.HealthValue = 15
SWEP.EatTime = 1

SWEP.AmmoIfHas = true