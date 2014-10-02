AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'Silencer' SMG"
	SWEP.Slot = 2
	SWEP.SlotPos = 0

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "v_weapon.TMP_Parent"
	SWEP.HUD3DPos = Vector(-1, -3.5, -1)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.015
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "pistol"

SWEP.ViewModel = "models/weapons/cstrike/c_smg_tmp.mdl"
SWEP.WorldModel = "models/weapons/w_smg_tmp.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("Weapon_TMP.Single")
SWEP.Primary.Damage = 22
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.06

SWEP.Primary.ClipSize = 25
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SMG1

SWEP.ConeMax = 0.13
SWEP.ConeMin = 0.1

SWEP.WalkSpeed = SPEED_NORMAL

SWEP.IronSightsPos = Vector(-7, 3, 2.5)
