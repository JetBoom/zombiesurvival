AddCSLuaFile()

if CLIENT then
SWEP.WepSelectIcon = surface.GetTextureID( "csgo/econ/weapons/base_weapons/weapon_mag7" )
SWEP.DrawWeaponInfoBox	= false
SWEP.BounceWeaponIcon = false
killicon.Add( "weapon_csgo_mag7", "csgo/econ/weapons/base_weapons/weapon_mag7", Color( 255, 255, 255, 255 ) )
end



SWEP.Base = "weapon_zs_baseshotgun"

SWEP.PrintName = "'MAG7' Shotgun"
SWEP.Description = "a cliped shotgun with 7 rounds singal fire with high damage."

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "v_weapon.galil"
	SWEP.HUD3DPos = Vector(1, 0, 6)
	SWEP.HUD3DScale = 0.015
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "shotgun"

SWEP.ViewModelFOV = 60
SWEP.ViewModel = "models/csgo/weapons/v_shot_mag7.mdl"
SWEP.WorldModel = "models/csgo/weapons/w_shot_mag7.mdl"
SWEP.ViewModelFlip = false
SWEP.UseHands = true

SWEP.ReloadDelay = 0.45

SWEP.Primary.Sound = Sound("Weapon_CSGO_Mag7.Single")
SWEP.Primary.Damage = 12.5
SWEP.Primary.NumShots = 7
SWEP.Primary.Delay = 0.75
SWEP.Primary.ClipSize = 8
SWEP.Primary.Ammo = "buckshot"




SWEP.WalkSpeed = SPEED_FAST

SWEP.Tier = 3

GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 5
SWEP.ConeMin = 3.75

SWEP.FireAnimSpeed = 1.2

SWEP.Tier = 3
SWEP.MaxStock = 3
SWEP.Slot = 3

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 1)



