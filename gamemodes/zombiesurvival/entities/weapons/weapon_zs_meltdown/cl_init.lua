INC_CLIENT()

SWEP.HUD3DBone = "Base"
SWEP.HUD3DPos = Vector(3, -0.5, -13)
SWEP.HUD3DAng = Angle(180, 0, 0)
SWEP.HUD3DScale = 0.03

SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false
SWEP.ViewModelFOV = 52
SWEP.ViewModelFlip = false

SWEP.Slot = 4
SWEP.SlotPos = 0


SWEP.VElements = {
	["MainBody2"] = { type = "Model", model = "models/props_wasteland/laundry_basket002.mdl", bone = "Base", rel = "MainBody1", pos = Vector(8.831, 0, 1.7), angle = Angle(-90, 0, 0), size = Vector(0.172, 0.172, 0.172), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Handle"] = { type = "Model", model = "models/props_c17/gaspipes006a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "MainBody1", pos = Vector(8.831, -1.558, 0.518), angle = Angle(-180, 90, -180), size = Vector(0.301, 0.301, 0.301), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_wasteland/grainelevator01", skin = 0, bodygroup = {} },
	["Battery"] = { type = "Model", model = "models/items/car_battery01.mdl", bone = "Base", rel = "MainBody1", pos = Vector(-0.519, 0.518, 7.791), angle = Angle(-90, 0, -90), size = Vector(0.367, 0.367, 0.367), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["MainBody1+"] = { type = "Model", model = "models/props_wasteland/light_spotlight01_lamp.mdl", bone = "Base", rel = "MainBody1", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.2, 0.439, 0.449), color = Color(195, 213, 255, 255), surpresslightning = false, material = "models/props_c17/awning01", skin = 0, bodygroup = {} },
	["Aim"] = { type = "Model", model = "models/props_c17/utilityconnecter005.mdl", bone = "Base", rel = "MainBody1", pos = Vector(1.6, -5.715, 1.6), angle = Angle(0, 0, 0), size = Vector(0.237, 0.237, 0.237), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/pipesystem01a_skin2", skin = 0, bodygroup = {} },
	["Wheel"] = { type = "Model", model = "models/props_wasteland/wheel02b.mdl", bone = "Base", rel = "MainBody2+", pos = Vector(0, 0, -3.636), angle = Angle(0, -31.559, -90), size = Vector(0.07, 0.07, 0.07), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["MainBody1"] = { type = "Model", model = "models/props_wasteland/light_spotlight01_lamp.mdl", bone = "Base", rel = "", pos = Vector(2.596, 1.557, -12.988), angle = Angle(90, 0, 0), size = Vector(0.532, 0.432, 0.432), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_wasteland/quarryobjects01", skin = 0, bodygroup = {} },
	["MainBody2+"] = { type = "Model", model = "models/props_wasteland/laundry_basket002.mdl", bone = "Base", rel = "MainBody1", pos = Vector(10.909, 0, 1.7), angle = Angle(90, 0, 0), size = Vector(0.166, 0.166, 0.172), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["AmmoBoxThing"] = { type = "Model", model = "models/props_wasteland/tram_leverbase01.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "MainBody2", pos = Vector(3.635, 2.296, 0), angle = Angle(0, -127.403, -90), size = Vector(0.172, 0.497, 0.367), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_wasteland/grainelevator01", skin = 0, bodygroup = {} },
	["Barrel"] = { type = "Model", model = "models/props_canal/mattpipe.mdl", bone = "Base", rel = "Wheel", pos = Vector(-3, -12.988, -0.25), angle = Angle(0, 0, -90), size = Vector(0.955, 0.955, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_wasteland/quarryobjects01", skin = 0, bodygroup = {} },
	["Gear"] = { type = "Model", model = "models/props_wasteland/gear01.mdl", bone = "Base", rel = "", pos = Vector(1, 1.557, -8.532), angle = Angle(0, -10.52, -90), size = Vector(0.6, 0.6, 0.6), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["AmmoBox"] = { type = "Model", model = "models/items/boxsrounds.mdl", bone = "Base", rel = "MainBody2", pos = Vector(3.635, 9.47, 0.518), angle = Angle(90, -90, 0), size = Vector(0.449, 0.625, 0.69), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Switch"] = { type = "Model", model = "models/props_wasteland/prison_throwswitchlever001.mdl", bone = "Base", rel = "MainBody1", pos = Vector(2.596, -3.636, 6), angle = Angle(-82.987, 90, 0), size = Vector(0.367, 0.367, 0.367), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Spring"] = { type = "Model", model = "models/props_c17/utilityconnecter006.mdl", bone = "Base", rel = "Switch", pos = Vector(0.718, 3.635, -0.519), angle = Angle(-5.844, 15.194, 15.194), size = Vector(0.107, 0.301, 0.107), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_canal/canal_bridge_railing_01b", skin = 0, bodygroup = {} },
	["Lever"] = { type = "Model", model = "models/props_c17/trappropeller_lever.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "Handle", pos = Vector(1.358, 0, -6.753), angle = Angle(0, -90, -90), size = Vector(0.755, 0.497, 0.755), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Barrel+"] = { type = "Model", model = "models/props_canal/mattpipe.mdl", bone = "Base", rel = "Wheel", pos = Vector(2, -12.988, -2.597), angle = Angle(125.065, 0, -90), size = Vector(0.955, 0.955, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_wasteland/quarryobjects01", skin = 0, bodygroup = {} },
	["Barrel++"] = { type = "Model", model = "models/props_canal/mattpipe.mdl", bone = "Base", rel = "Wheel", pos = Vector(2, -12.988, 2.796), angle = Angle(-148.443, 0, -90), size = Vector(0.955, 0.955, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_wasteland/quarryobjects01", skin = 0, bodygroup = {} }
}
SWEP.WElements = {
	["MainBody2"] = { type = "Model", model = "models/props_wasteland/laundry_basket002.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "MainBody1", pos = Vector(8.831, 0, 1.7), angle = Angle(-90, 0, 0), size = Vector(0.172, 0.172, 0.172), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Handle"] = { type = "Model", model = "models/props_c17/gaspipes006a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "MainBody1", pos = Vector(-0.519, -1.558, -0.519), angle = Angle(-180, 90, -180), size = Vector(0.301, 0.301, 0.301), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_wasteland/grainelevator01", skin = 0, bodygroup = {} },
	["Barrel+"] = { type = "Model", model = "models/props_canal/mattpipe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "Wheel", pos = Vector(2, -8.832, -2.597), angle = Angle(125.065, 0, -90), size = Vector(0.955, 0.955, 0.721), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_wasteland/quarryobjects01", skin = 0, bodygroup = {} },
	["MainBody1+"] = { type = "Model", model = "models/props_wasteland/light_spotlight01_lamp.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "MainBody1", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.2, 0.439, 0.449), color = Color(195, 213, 255, 255), surpresslightning = false, material = "models/props_c17/awning01", skin = 0, bodygroup = {} },
	["Aim"] = { type = "Model", model = "models/props_c17/utilityconnecter005.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "MainBody1", pos = Vector(1.6, -5.715, 1.6), angle = Angle(0, 0, 0), size = Vector(0.237, 0.237, 0.237), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/pipesystem01a_skin2", skin = 0, bodygroup = {} },
	["Wheel"] = { type = "Model", model = "models/props_wasteland/wheel02b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "MainBody2+", pos = Vector(0, 0, -3.636), angle = Angle(0, -31.559, -90), size = Vector(0.07, 0.07, 0.07), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["MainBody1"] = { type = "Model", model = "models/props_wasteland/light_spotlight01_lamp.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(9.869, 2.596, -2.597), angle = Angle(-5.844, 10.519, -71.3), size = Vector(0.532, 0.432, 0.432), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_wasteland/quarryobjects01", skin = 0, bodygroup = {} },
	["MainBody2+"] = { type = "Model", model = "models/props_wasteland/laundry_basket002.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "MainBody1", pos = Vector(10.909, 0, 1.7), angle = Angle(90, 0, 0), size = Vector(0.166, 0.166, 0.172), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["AmmoBoxThing"] = { type = "Model", model = "models/props_wasteland/tram_leverbase01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "MainBody2", pos = Vector(3.635, 2.296, 0), angle = Angle(0, -127.403, -90), size = Vector(0.172, 0.82, 0.367), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_wasteland/grainelevator01", skin = 0, bodygroup = {} },
	["Battery"] = { type = "Model", model = "models/items/car_battery01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "MainBody1", pos = Vector(-0.519, 0.518, 8.63), angle = Angle(-90, 0, -90), size = Vector(0.497, 0.497, 0.497), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Gear"] = { type = "Model", model = "models/props_wasteland/gear01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "MainBody1", pos = Vector(4.675, 0, 1.557), angle = Angle(0, -90, 0), size = Vector(0.6, 0.6, 0.6), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["AmmoBox"] = { type = "Model", model = "models/items/boxsrounds.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "MainBody2", pos = Vector(3.635, 9.47, 0.518), angle = Angle(90, -90, 0), size = Vector(0.449, 0.625, 0.69), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Switch"] = { type = "Model", model = "models/props_wasteland/prison_throwswitchlever001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "MainBody1", pos = Vector(1.557, -3.636, 6), angle = Angle(-82.987, 90, 0), size = Vector(0.367, 0.367, 0.367), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Spring"] = { type = "Model", model = "models/props_c17/utilityconnecter006.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "Switch", pos = Vector(0.718, 3.635, -0.519), angle = Angle(-5.844, 15.194, 15.194), size = Vector(0.107, 0.301, 0.107), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_canal/canal_bridge_railing_01b", skin = 0, bodygroup = {} },
	["Lever"] = { type = "Model", model = "models/props_c17/trappropeller_lever.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "Handle", pos = Vector(1.358, 0, -6.753), angle = Angle(0, -90, -90), size = Vector(0.755, 0.497, 0.755), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Barrel"] = { type = "Model", model = "models/props_canal/mattpipe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "Wheel", pos = Vector(-3.3, -9.87, -0.32), angle = Angle(0, 0, -90), size = Vector(0.955, 0.955, 0.721), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_wasteland/quarryobjects01", skin = 0, bodygroup = {} },
	["Barrel++"] = { type = "Model", model = "models/props_canal/mattpipe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "Wheel", pos = Vector(2, -9.87, 2.796), angle = Angle(-148.443, 0, -90), size = Vector(0.955, 0.955, 0.721), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_wasteland/quarryobjects01", skin = 0, bodygroup = {} }
}


SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_R_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(-0.556, 0, 0), angle = Angle(1.11, 0, 0) },
	["Base"] = { scale = Vector(0.056, 0.056, 0.056), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(16.111, -0.926, 5.369), angle = Angle(-7.778, 0, 0) },
	["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(34.444, 0, 0) },
	["square"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(-0.926, 0, 0), angle = Angle(14.444, 0, 0) },
	["ValveBiped.Bip01_Spine4"] = { scale = Vector(1, 1, 1), pos = Vector(-10.926, 8.333, 1.296), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(3.332, 0, 0) },
	["ValveBiped.Bip01_R_Finger41"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(12.222, 0, 0) },
	["ValveBiped.Bip01_R_Finger1"] = { scale = Vector(0.994, 0.994, 0.994), pos = Vector(-0.926, 0, 0), angle = Angle(18.888, 0, 0) },
	["Doodad_4"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, -5.37, 0), angle = Angle(0, 0, 0) },
	["Doodad_2"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger22"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-1.111, 0, 0) },
	["ValveBiped.Bip01_R_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(5.556, 0, 0) },
	["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, -15, 0), angle = Angle(74.444, 0, 0) },
	["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-78.889, 0, 0) },
	["Doodad_1"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["Prong_A"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["Prong_B"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(12.222, 0, 0) },
	["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(3.148, 0.925, 0.555), angle = Angle(0, 0, 0) }
}

