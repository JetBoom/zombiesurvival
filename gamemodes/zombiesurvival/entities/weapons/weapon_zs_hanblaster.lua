AddCSLuaFile()

SWEP.PrintName = "'DL44 ' blaster"
SWEP.Description = "the famous blaster of han solo. ."

SWEP.Slot = 1
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 70

	SWEP.HUD3DBone = "ValveBiped.square"
	SWEP.HUD3DPos = Vector(1.1, 0.25, -2)
	SWEP.HUD3DScale = 0.015
	SWEP.WepSelectIcon = surface.GetTextureID("HUD/killicons/DL44")
	killicon.Add( "weapon_752_dl44", "HUD/killicons/DL44", Color( 255, 80, 0, 255 ) )
	
end

SWEP.Base = "weapon_zs_base"

SWEP.ReloadType = "pistol"
SWEP.HoldType = "pistol"

SWEP.ViewModel				= "models/weapons/v_DL44.mdl"
SWEP.WorldModel				= "models/weapons/w_DL44.mdl"
SWEP.UseHands = false

SWEP.ReloadSound = Sound("Weapon_SMG1.Reload")
SWEP.Primary.Sound = Sound("weapons/DL44_fire.wav")
SWEP.Primary.Damage = 55
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.3

SWEP.Primary.ClipSize = 12
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pulse"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 2.5
SWEP.ConeMin = 0.75

SWEP.IronSightsPos 			= Vector (-3.7, -9, 1)


SWEP.WalkSpeed = SPEED_NORMAL

SWEP.Tier = 3

SWEP.TracerName = "effect_sw_laser_red"
