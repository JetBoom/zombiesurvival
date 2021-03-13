AddCSLuaFile()

SWEP.Base = "weapon_zs_baseshotgun"

SWEP.PrintName = "Bulk Cannon"
SWEP.Description = "Turns victims into a sieve."

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "v_weapon.M3_PARENT"
	SWEP.HUD3DPos = Vector(-1, -4, -3)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.015
end

SWEP.Base = "weapon_zs_baseshotgun"

SWEP.HoldType = "shotgun"

SWEP.ViewModel = "models/weapons/bulkcannon/v_shot_xm1014.mdl"
SWEP.WorldModel = "models/weapons/bulkcannon/w_shot_xm1014.mdl"
SWEP.ShowWorldModel = false


SWEP.WElements = {
	["element_name"] = { type = "Model", model = "models/weapons/bulkcannon/w_shot_xm1014.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7, 1.557, -1.558), angle = Angle(-8, -3.507, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.UseHands = true

SWEP.ReloadDelay = 0.33

-- SWEP.Primary.Sound = Sound("Weapon_M3.Single")
-- SWEP.Primary.Damage = 14.75
-- SWEP.Primary.NumShots = 8
-- SWEP.Primary.Delay = 0.87

SWEP.DryFireSound = Sound("weapons/bulkcannon/xm1014-1.wav")

SWEP.Primary.Sound = Sound("weapons/bulkcannon/xm1014-1.wav")
SWEP.Primary.Damage = 64
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.08
SWEP.Recoil = .8
SWEP.ReloadSpeed = 1.0
SWEP.FireAnimSpeed = 1.0
SWEP.Primary.KnockbackScale = 6

SWEP.Primary.ClipSize = 7
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "buckshot"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 5 -- this is a shotgun, so the spray does not change in motion. set on usable range
SWEP.ConeMin = 5

SWEP.FireAnimSpeed = 1.5
SWEP.WalkSpeed = SPEED_SLOWEST

SWEP.Tier = 4
SWEP.MaxStock = 3

--GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 1)