AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'Shredder' SMG"
	SWEP.Slot = 2
	SWEP.SlotPos = 0

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 50

	SWEP.HUD3DBone = "v_weapon.MP5_Parent"
	SWEP.HUD3DPos = Vector(-1, -3, -6)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.015
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "shotgun"

SWEP.ViewModel = "models/weapons/cstrike/c_smg_mp5.mdl"
SWEP.WorldModel = "models/weapons/w_smg_mp5.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("Weapon_MP5Navy.Single")
SWEP.Primary.Damage = 18
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.09

SWEP.Primary.ClipSize = 30
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SMG1

SWEP.ConeMax = 0.11
SWEP.ConeMin = 0.05

SWEP.WalkSpeed = SPEED_SLOW

SWEP.IronSightsAng = Vector(0.8, 0, 0)
SWEP.IronSightsPos = Vector(-5.33, 7, 1.8)
