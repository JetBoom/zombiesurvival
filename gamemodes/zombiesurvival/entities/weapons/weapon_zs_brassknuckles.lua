AddCSLuaFile()

SWEP.Base = "weapon_zs_fists"

SWEP.PrintName = "Brass Knuckles"
SWEP.Description = "A pair of brass knuckles used to concentrate strikes from one's fists, increasing the damage done, while keeping their movement speed up."

if CLIENT then
	SWEP.ViewModelFOV = 52
	SWEP.ViewModelFlip = false

	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false

	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/props_c17/utilityconnecter005.mdl", bone = "ValveBiped.Bip01_R_Finger2", rel = "", pos = Vector(1.129, -0.087, 0.4), angle = Angle(0, 15.421, 94.749), size = Vector(0.458, 0.349, 0.395), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base+"] = { type = "Model", model = "models/props_c17/utilityconnecter005.mdl", bone = "ValveBiped.Bip01_L_Finger2", rel = "", pos = Vector(1.238, 0.136, -0.399), angle = Angle(2.473, 1.322, 83.697), size = Vector(0.458, 0.349, 0.395), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/props_c17/utilityconnecter005.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.021, 1.006, 0), angle = Angle(0, -93.675, 100), size = Vector(0.458, 0.349, 0.395), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base+"] = { type = "Model", model = "models/props_c17/utilityconnecter005.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(4.085, 0.674, 0), angle = Angle(0, -99.708, 82.794), size = Vector(0.458, 0.349, 0.395), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.WalkSpeed = SPEED_FASTEST

SWEP.ViewModel = "models/weapons/c_arms_citizen.mdl"
SWEP.WorldModel	= "models/weapons/w_grenade.mdl"

SWEP.Weight = 4

SWEP.MeleeDamage = 22.5

SWEP.Unarmed = false

SWEP.Undroppable = false
SWEP.NoPickupNotification = false
SWEP.NoDismantle = false

SWEP.NoGlassWeapons = false

SWEP.AllowQualityWeapons = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.06)
