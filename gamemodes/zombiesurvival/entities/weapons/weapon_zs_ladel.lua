AddCSLuaFile()

SWEP.PrintName = "Ladle"

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false

	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/props_lab/ladel.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.809, 2.072, -6.882), angle = Angle(0.912, -90, 6.249), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/props_lab/ladel.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.009, 1.833, -6.954), angle = Angle(4.703, -180, 4.718), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.DamageType = DMG_CLUB

SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.UseHands = true

SWEP.MeleeDamage = 34
SWEP.MeleeRange = 58
SWEP.MeleeSize = 1.15

SWEP.Primary.Delay = 0.9

SWEP.UseMelee1 = true

SWEP.HitGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.MissGesture = SWEP.HitGesture

SWEP.SwingRotation = Angle(30, -30, -30)
SWEP.SwingTime = 0.25
SWEP.SwingHoldType = "grenade"

SWEP.AllowQualityWeapons = true
SWEP.Culinary = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MELEE_RANGE, 4)

function SWEP:PlayHitSound()
	self:EmitSound("weapons/melee/frying_pan/pan_hit-0"..math.random(4)..".ogg", 75, 140)
end
