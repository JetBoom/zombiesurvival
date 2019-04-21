INC_CLIENT()

SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 50

SWEP.ViewModelBoneMods = {
	["ValveBiped.cube1"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.cube2"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.cube3"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.cube"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}
SWEP.VElements = {
	["base"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.091, 3.181, 3), angle = Angle(0, 0, 180), size = Vector(0.16, 0.16, 0.16), color = Color(235, 205, 185, 255), surpresslightning = false, material = "models/props_canal/canal_bridge_railing_01c", skin = 0, bodygroup = {} },
	["base+"] = { type = "Model", model = "models/props_c17/substation_circuitbreaker01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0, 0, 7), angle = Angle(0, 0, 0), size = Vector(0.02, 0.02, 0.02), color = Color(255, 205, 175, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["base"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.181, 2.273, -0.456), angle = Angle(-43.978, 27.614, 70.568), size = Vector(0.16, 0.16, 0.16), color = Color(235, 205, 185, 255), surpresslightning = false, material = "models/props_canal/canal_bridge_railing_01c", skin = 0, bodygroup = {} }
}
