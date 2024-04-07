AddCSLuaFile()

SWEP.PrintName = "'deathtrooper' E-11"

SWEP.Slot = 3
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 50

	SWEP.HUD3DBone = "Vent"
	SWEP.HUD3DPos = Vector(1, 0, 0)
	SWEP.HUD3DScale = 0.018
	SWEP.WepSelectIcon 		= surface.GetTextureID("HUD/killicons/E11")
	
	killicon.Add( "weapon_752_e11", "HUD/killicons/E11", Color( 255, 80, 0, 255 ) )

end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel				= "models/weapons/v_E11.mdl"
SWEP.WorldModel				= "models/weapons/w_E11.mdl"
SWEP.UseHands = true

SWEP.ReloadSound = Sound("Weapon_SMG1.Reload")
SWEP.Primary.Sound = Sound("weapons/E11_fire.wav")
SWEP.Primary.Damage = 15
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 1.0

SWEP.Primary.ClipSize = 40
SWEP.Primary.DefaultClip = 200
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "pulse"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 3
SWEP.ConeMin = 1


SWEP.WalkSpeed = SPEED_NORMAL


SWEP.TracerName = "effect_sw_laser_red"


