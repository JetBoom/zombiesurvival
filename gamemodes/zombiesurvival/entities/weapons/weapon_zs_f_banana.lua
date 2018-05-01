AddCSLuaFile()

SWEP.Base = "weapon_zs_basefood"

SWEP.PrintName = "Banana"

if CLIENT then
	SWEP.ViewModelBoneMods = {
		["ValveBiped.Bip01_R_Finger02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 59, 0) },
	}

	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/props/cs_italy/bananna.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2, 2.5, -1), angle = Angle(0, 0, 120), size = Vector(0.75, 0.75, 0.75), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/props/cs_italy/bananna.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 2.5, -1), angle = Angle(0, 0, 120), size = Vector(0.75, 0.75, 0.75), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.ViewModel = "models/weapons/c_grenade.mdl"
SWEP.WorldModel = "models/props/cs_italy/bananna.mdl"

SWEP.Primary.Ammo = "foodbanana"

SWEP.FoodHealth = 10
SWEP.FoodEatTime = 2.75
