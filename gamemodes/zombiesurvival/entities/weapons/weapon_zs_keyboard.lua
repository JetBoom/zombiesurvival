AddCSLuaFile()

SWEP.PrintName = "Keyboard"

if CLIENT then
	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false

	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false

	SWEP.ViewModelBoneMods = {
		["ValveBiped.Bip01_R_Finger02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -45.715, 0) },
		["ValveBiped.Bip01_R_Finger01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -49.524, 0) }
	}
	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/props_c17/computer01_keyboard.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.091, 4.4, -7.728), angle = Angle(180, -82.842, 80.794), size = Vector(0.75, 0.75, 0.75), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/props_c17/computer01_keyboard.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5, 4.091, -8.636), angle = Angle(180, -60.341, 90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.HoldType = "melee"

SWEP.DamageType = DMG_CLUB

SWEP.ViewModel = "models/weapons/c_stunstick.mdl"
SWEP.WorldModel = "models/props_c17/computer01_keyboard.mdl"
SWEP.UseHands = true

SWEP.MeleeDamage = 35
SWEP.MeleeRange = 52
SWEP.MeleeSize = 1.25

SWEP.Primary.Delay = 0.75

SWEP.SwingTime = 0.3
SWEP.SwingRotation = Angle(30, -30, -30)
SWEP.SwingOffset = Vector(0, -30, 0)
SWEP.SwingHoldType = "grenade"

SWEP.AllowQualityWeapons = true
SWEP.DismantleDiv = 2

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.075)

function SWEP:PlayHitSound()
	self:EmitSound("weapons/melee/keyboard/keyboard_hit-0"..math.random(4)..".ogg")
end
