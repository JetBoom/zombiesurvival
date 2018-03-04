AddCSLuaFile()

if game.SinglePlayer() == true then

	--Do jack shit
	
	else 
	if CLIENT then
		SWEP.PrintName = "'Riddler' Assault Rifle"
		SWEP.Slot = 2
		SWEP.SlotPos = 0

		SWEP.ViewModelFlip = false
		SWEP.ViewModelFOV = 50

		SWEP.HUD3DBone = "v_weapon.galil"
		SWEP.HUD3DPos = Vector(1.2, 0, 4)
		SWEP.HUD3DAng = Angle(0, 180, 180)
		SWEP.HUD3DScale = 0.015
	end

	SWEP.Base = "weapon_zs_base"

	SWEP.HoldType = "ar2"

	SWEP.ViewModel = "models/weapons/cstrike/c_rif_galil.mdl"
	SWEP.WorldModel = "models/weapons/w_rif_galil.mdl"
	SWEP.UseHands = true

	SWEP.Primary.Sound = Sound("Weapon_galil.Single")
	SWEP.Primary.Damage = 16
	SWEP.Primary.NumShots = 1
	SWEP.Primary.Delay = 0.12

	SWEP.Primary.ClipSize = 30
	SWEP.Primary.Automatic = true
	SWEP.Primary.Ammo = "ar2"
	GAMEMODE:SetupDefaultClip(SWEP.Primary)

	SWEP.ConeMax = 0.055
	SWEP.ConeMin = 0.0275

	SWEP.WalkSpeed = SPEED_SLOW

	SWEP.IronSightsPos = Vector(-6.6, 20, 3.1)
end