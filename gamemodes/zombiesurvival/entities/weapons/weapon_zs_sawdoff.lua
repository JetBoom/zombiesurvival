AddCSLuaFile()

SWEP.Base = "weapon_zs_baseshotgun"

SWEP.PrintName = "'sawdoff' Shotgun"
SWEP.Description = "A basic shotgun that can deal significant amounts of damage at close range."

if CLIENT then
	SWEP.ViewModelFlip = false

	SWEP.HUD3DBone = "v_weapon.M3_PARENT"
	SWEP.HUD3DPos = Vector(-1, -4, -3)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.015
end


SWEP.HoldType = "shotgun"

SWEP.Tier = 2

SWEP.ViewModel = "models/csgo/weapons/v_shot_sawedoff.mdl"
SWEP.WorldModel = "models/csgo/weapons/w_shot_sawedoff.mdl"
SWEP.UseHands = true

SWEP.ReloadDelay = 0.4

SWEP.Primary.Sound = Sound( "Weapon_CSGO_Sawedoff.Single" )
SWEP.Primary.Damage = 9.825
SWEP.Primary.NumShots = 8
SWEP.Primary.Delay = 0.8

SWEP.Primary.ClipSize = 5
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "buckshot"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 8.75
SWEP.ConeMin = 5

SWEP.WalkSpeed = SPEED_SLOWER

SWEP.PumpSound = Sound("Weapon_M3.Pump")
SWEP.ReloadSound = Sound("Weapon_Shotgun.Reload")




GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 1)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, "'sawdoff' Slug Gun", "Single accurate slug round, less total damage", function(wept)
	wept.Primary.Damage = wept.Primary.Damage * 5.5
	wept.Primary.NumShots = 1
	wept.ConeMin = wept.ConeMin * 0.15
	wept.ConeMax = wept.ConeMax * 0.3
end)
