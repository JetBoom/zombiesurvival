AddCSLuaFile()

SWEP.PrintName = "'IMI Galil' Assault Rifle"
SWEP.Description = "assault rifle commonly made and used in isreal fast shoting with a larger clip than ak ."

SWEP.Slot = 2
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "v_weapon.galil"
	SWEP.HUD3DPos = Vector(1, 0, 6)
	SWEP.HUD3DScale = 0.015
end


SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/cstrike/c_rif_galil.mdl"
SWEP.WorldModel = "models/weapons/w_rif_galil.mdl"
SWEP.UseHands = true

SWEP.ReloadSound = Sound("Weapon_Galil.Clipout")
SWEP.Primary.Sound = Sound("Weapon_Galil.Single")
SWEP.Primary.Damage = 21.50
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.11

SWEP.Primary.ClipSize = 35
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 2.65
SWEP.ConeMin = 1.275

SWEP.WalkSpeed = SPEED_FAST

SWEP.Tier = 3

SWEP.IronSightsPos = Vector(-6.6, 20, 3.1)

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.344)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.172)
