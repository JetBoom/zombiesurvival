	AddCSLuaFile()
if game.SinglePlayer() == true then

	--Do jack shit
	
	else 
	if CLIENT then
		SWEP.PrintName = "'Punisher' M249 Machine Gun"
		SWEP.Slot = 2
		SWEP.SlotPos = 0

		SWEP.ViewModelFlip = false
		SWEP.ViewModelFOV = 90

		SWEP.HUD3DBone = "v_weapon.m249"
		SWEP.HUD3DPos = Vector(1.5, -1, 2)
		SWEP.HUD3DAng = Angle(0, 180, 180)
		SWEP.HUD3DScale = 0.0150
	end

	SWEP.Base = "weapon_zs_base"
	SWEP.HoldType = "ar2"

	SWEP.ViewModel = "models/weapons/cstrike/c_mach_m249para.mdl"
	SWEP.WorldModel = "models/weapons/w_mach_m249para.mdl"
	SWEP.UseHands = true

	SWEP.Primary.Sound = Sound("Weapon_m249.Single")
	SWEP.Primary.Damage = 15
	SWEP.Primary.NumShots = 1
	SWEP.Primary.Delay = 0.05

	SWEP.Primary.ClipSize = 200
	SWEP.Primary.Automatic = true
	SWEP.Primary.Ammo = "ar2"
	GAMEMODE:SetupDefaultClip(SWEP.Primary)

	SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1
	SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SMG1

	SWEP.WalkSpeed = SPEED_SLOW

	SWEP.ConeMax = 0.20
	SWEP.ConeMin = 0.1

	SWEP.IronSightsPos = Vector(0, 0, 0)
end