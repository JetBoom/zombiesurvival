AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'Stalker' M4"
	SWEP.Description = "Using this gun will severely reduce the distance in which zombies can see your aura."
	SWEP.Slot = 2
	SWEP.SlotPos = 0

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "v_weapon.m4_Parent"
	SWEP.HUD3DPos = Vector(-0.5, -5, -1.2)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.015
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "smg"

SWEP.ViewModel = "models/weapons/cstrike/c_rif_m4a1.mdl"
SWEP.WorldModel = "models/weapons/w_rif_m4a1.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("Weapon_m4a1.Single")
SWEP.Primary.Damage = 24
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.11

SWEP.Primary.ClipSize = 30
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SMG1

SWEP.ConeMax = 0.125
SWEP.ConeMin = 0.045

SWEP.WalkSpeed = SPEED_SLOW

SWEP.IronSightsPos = Vector(-3, 0, 2)

function SWEP:GetAuraRange()
	return 512
end
