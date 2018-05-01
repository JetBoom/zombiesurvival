AddCSLuaFile()

SWEP.Base = "weapon_zs_baseshotgun"

SWEP.PrintName = "'Sweeper' Shotgun"
SWEP.Description = "A pump shotgun with a modest shell number and packs a hefty punch."

if CLIENT then
	SWEP.ViewModelFlip = false

	SWEP.HUD3DBone = "v_weapon.M3_PARENT"
	SWEP.HUD3DPos = Vector(-1, -4, -3)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.015
end

SWEP.Base = "weapon_zs_baseshotgun"

SWEP.HoldType = "shotgun"

SWEP.ViewModel = "models/weapons/cstrike/c_shot_m3super90.mdl"
SWEP.WorldModel = "models/weapons/w_shot_m3super90.mdl"
SWEP.UseHands = true

SWEP.ReloadDelay = 0.45

SWEP.Primary.Sound = Sound("Weapon_M3.Single")
SWEP.Primary.Damage = 14.75
SWEP.Primary.NumShots = 8
SWEP.Primary.Delay = 0.87

SWEP.Primary.ClipSize = 6
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "buckshot"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 5
SWEP.ConeMin = 3.75

SWEP.FireAnimSpeed = 1.2
SWEP.WalkSpeed = SPEED_SLOWER

SWEP.Tier = 4
SWEP.MaxStock = 3

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 1)
