AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'Crackler' Assault Rifle"
	SWEP.Slot = 2
	SWEP.SlotPos = 0

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "v_weapon.famas"
	SWEP.HUD3DPos = Vector(1.1, -3.5, 10)
	SWEP.HUD3DScale = 0.02
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/cstrike/c_rif_famas.mdl"
SWEP.WorldModel = "models/weapons/w_rif_famas.mdl"
SWEP.UseHands = true

SWEP.ReloadSound = Sound("Weapon_FAMAS.Clipout")
SWEP.Primary.Sound = Sound("Weapon_FAMAS.Single")
SWEP.Primary.Damage = 16
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.175

SWEP.Primary.ClipSize = 22
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 0.045
SWEP.ConeMin = 0.019

SWEP.WalkSpeed = SPEED_SLOW

SWEP.IronSightsPos = Vector(-3, 3, 2)
