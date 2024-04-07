AddCSLuaFile()

SWEP.Base = "weapon_zs_boardpack"

SWEP.PrintName = "Crafting Pack"
SWEP.Description = "A pack of assorted items which seem to have greater use when combined with other things."

function SWEP:Initialize()
	self.JunkModels = {
		Model("models/props_combine/breenbust.mdl"),
		Model("models/props_junk/gascan001a.mdl"),
		Model("models/props_c17/oildrum001.mdl"),
		Model("models/props_junk/sawblade001a.mdl"),
		Model("models/items/car_battery01.mdl"),
		Model("models/props_junk/propane_tank001a.mdl")
	}

	self.BaseClass.Initialize(self)
end

--[[if CLIENT then
	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/items/car_battery01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.675, 2.596, -6.753), angle = Angle(180, 66.623, -1.17), size = Vector(0.25, 0.25, 0.25), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/items/car_battery01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.675, 2.596, -6.753), angle = Angle(180, 66.623, -1.17), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end]]
