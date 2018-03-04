AddCSLuaFile()

if game.SinglePlayer() == true then

	--Do jack shit
	
	else 
	if CLIENT then
		SWEP.PrintName = "'Eliminator' sg552"
		SWEP.Slot = 2
		SWEP.SlotPos = 0

		SWEP.ViewModelFlip = false
		SWEP.ViewModelFOV = 55

		SWEP.HUD3DBone = "v_weapon.sg552_Parent"
		SWEP.HUD3DPos = Vector(-1, -4.5, -3)
		SWEP.HUD3DAng = Angle(0, 0, 0)
		SWEP.HUD3DScale = 0.015
	end

	SWEP.Base = "weapon_zs_base"

	SWEP.HoldType = "ar2"

	SWEP.ViewModel = "models/weapons/cstrike/c_rif_sg552.mdl"
	SWEP.WorldModel = "models/weapons/w_rif_sg552.mdl"
	SWEP.UseHands = true

	SWEP.Primary.Sound = Sound("Weapon_sg552.Single")
	SWEP.Primary.Damage = 21
	SWEP.Primary.NumShots = 1
	SWEP.Primary.Delay = 0.075

	SWEP.Primary.ClipSize = 35
	SWEP.Primary.Automatic = true
	SWEP.Primary.Ammo = "ar2"
	GAMEMODE:SetupDefaultClip(SWEP.Primary)

	SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
	SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_AR2

	SWEP.ConeMax = 0.08
	SWEP.ConeMin = 0.02

	SWEP.WalkSpeed = SPEED_SLOW

	SWEP.IronSightsAng = Vector(-1, -1, 0)
	SWEP.IronSightsPos = Vector(-3, 4, 3)
end