AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'Chainsaw' M249"
	SWEP.Description = "강력한 분대 지원 화기로, 앉아서 쏠 시 발사속도가 늘어난다."
	SWEP.Slot = 3
	SWEP.SlotPos = 0

	SWEP.ViewModelFlip		= false
	SWEP.ViewModelFOV		= 62

	SWEP.HUD3DBone = "v_weapon.receiver"
	SWEP.HUD3DPos = Vector(1, 2, 0)
	SWEP.HUD3DAng = Angle(0, 90, -90)
	SWEP.HUD3DScale = 0.015
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "crossbow"

SWEP.ViewModel			= "models/weapons/cstrike/c_mach_m249para.mdl"
SWEP.WorldModel			= "models/weapons/w_mach_m249para.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("Weapon_m249.Single")
SWEP.Primary.Damage = 10
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.06
SWEP.Primary.Recoil = 10
SWEP.Primary.KnockbackScale = 10

SWEP.Primary.ClipSize = 200
SWEP.Primary.ClipMultiplier = 3 / GAMEMODE.SurvivalClips
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "gravity"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SMG1

SWEP.ConeMax = 0.353
SWEP.ConeMin = 0.181

SWEP.WalkSpeed = 100

SWEP.IronSightsPos = Vector(-4.46, 15, 0)
SWEP.IronSightsAng = Vector(3.2, 0, 0)

function SWEP:Think()
	if self.Owner:Crouching() then
		self.Primary.Delay = 0.04
	else
		self.Primary.Delay = 0.06
	end
	
	self.BaseClass.Think(self)
end


