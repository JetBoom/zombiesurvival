INC_CLIENT()

SWEP.HUD3DBone = "v_weapon.ump45_Release"
SWEP.HUD3DPos = Vector(-1.6, -4.4, 2)
SWEP.HUD3DAng = Angle(0, 0, 0)
SWEP.HUD3DScale = 0.02

SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false
SWEP.ViewModelFOV = 50
SWEP.ViewModelFlip = false

SWEP.Slot = 4
SWEP.SlotPos = 0

SWEP.VElements = {
	["base+++++"] = { type = "Model", model = "models/props_combine/combine_teleportplatform.mdl", bone = "v_weapon.ump45_Parent", rel = "base", pos = Vector(1.044, 0, -2.02), angle = Angle(-2.439, 0, -180), size = Vector(0.079, 0.029, 0.061), color = Color(255, 205, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["base++"] = { type = "Model", model = "models/props_combine/combine_booth_short01a.mdl", bone = "v_weapon.ump45_Parent", rel = "base", pos = Vector(2.262, 0, 17.344), angle = Angle(0, 0, 180), size = Vector(0.039, 0.024, 0.059), color = Color(255, 225, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["base+++++++"] = { type = "Model", model = "models/props_combine/headcrabcannister01a.mdl", bone = "v_weapon.ump45_Parent", rel = "base", pos = Vector(-1.586, 0, 10.791), angle = Angle(0, 0, 0), size = Vector(0.064, 0.03, 0.032), color = Color(255, 225, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["baseclip"] = { type = "Model", model = "models/items/boxmrounds.mdl", bone = "v_weapon.ump45_Clip", rel = "", pos = Vector(0.096, 8.571, -2.461), angle = Angle(0, 0, -81.718), size = Vector(0.174, 0.236, 0.92), color = Color(210, 160, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["baseclip+"] = { type = "Model", model = "models/props_c17/playground_teetertoter_stan.mdl", bone = "v_weapon.ump45_Clip", rel = "baseclip", pos = Vector(0.975, 0.144, 2.572), angle = Angle(90, -90, 90), size = Vector(0.144, 0.27, 0.126), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["base++++"] = { type = "Model", model = "models/props_combine/combine_booth_short01a.mdl", bone = "v_weapon.ump45_Parent", rel = "base", pos = Vector(1.399, 0.55, 17.344), angle = Angle(0, -120, 180), size = Vector(0.039, 0.024, 0.059), color = Color(255, 225, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["base++++++"] = { type = "Model", model = "models/props_combine/combine_train02a.mdl", bone = "v_weapon.ump45_Parent", rel = "base", pos = Vector(-3.069, 0, -2.309), angle = Angle(0, -90, 23.74), size = Vector(0.008, 0.012, 0.009), color = Color(255, 225, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["base+"] = { type = "Model", model = "models/props_combine/combinebutton.mdl", bone = "v_weapon.ump45_Parent", rel = "base", pos = Vector(0.904, 1.027, 10.27), angle = Angle(0, -90, 0), size = Vector(0.335, 0.344, 0.207), color = Color(255, 225, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["base"] = { type = "Model", model = "models/props_combine/combine_booth_short01a.mdl", bone = "v_weapon.ump45_Parent", rel = "", pos = Vector(0.25, -5.16, -1.106), angle = Angle(180, -90, 0), size = Vector(0.061, 0.019, 0.1), color = Color(255, 225, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["base+++++++++"] = { type = "Model", model = "models/props_lab/teleportring.mdl", bone = "v_weapon.ump45_Parent", rel = "base", pos = Vector(-1.397, -0.396, 1.409), angle = Angle(0, -180, -90), size = Vector(0.061, 0.054, 0.076), color = Color(127, 122, 113, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["base+++"] = { type = "Model", model = "models/props_combine/combine_booth_short01a.mdl", bone = "v_weapon.ump45_Parent", rel = "base", pos = Vector(1.399, -0.551, 17.344), angle = Angle(0, 120, 180), size = Vector(0.039, 0.024, 0.059), color = Color(255, 225, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["base++++++++"] = { type = "Model", model = "models/props_combine/combinetrain01a.mdl", bone = "v_weapon.ump45_Parent", rel = "base", pos = Vector(2.426, 0, 0.414), angle = Angle(90, -90, 90), size = Vector(0.012, 0.014, 0.014), color = Color(255, 225, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["base+++++"] = { type = "Model", model = "models/props_combine/combine_teleportplatform.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(1.044, 0, -2.02), angle = Angle(-2.439, 0, -180), size = Vector(0.079, 0.029, 0.061), color = Color(255, 205, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["base++"] = { type = "Model", model = "models/props_combine/combine_booth_short01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(2.262, 0, 17.344), angle = Angle(0, 0, 180), size = Vector(0.039, 0.024, 0.059), color = Color(255, 225, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["base+++++++"] = { type = "Model", model = "models/props_combine/headcrabcannister01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-1.586, 0, 10.791), angle = Angle(0, 0, 0), size = Vector(0.064, 0.03, 0.032), color = Color(255, 225, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["base+"] = { type = "Model", model = "models/props_combine/combinebutton.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0.904, 1.027, 10.27), angle = Angle(0, -90, 0), size = Vector(0.335, 0.344, 0.207), color = Color(255, 225, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["base++++++++"] = { type = "Model", model = "models/props_combine/combinetrain01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(2.426, 0, 0.414), angle = Angle(90, -90, 90), size = Vector(0.012, 0.014, 0.014), color = Color(255, 225, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["base++++"] = { type = "Model", model = "models/props_combine/combine_booth_short01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(1.399, 0.55, 17.344), angle = Angle(0, -120, 180), size = Vector(0.039, 0.024, 0.059), color = Color(255, 225, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["baseclip+"] = { type = "Model", model = "models/props_c17/playground_teetertoter_stan.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-6.913, -0.778, 6.288), angle = Angle(173.302, 0, 90), size = Vector(0.144, 0.27, 0.126), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["base+++"] = { type = "Model", model = "models/props_combine/combine_booth_short01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(1.399, -0.551, 17.344), angle = Angle(0, 120, 180), size = Vector(0.039, 0.024, 0.059), color = Color(255, 225, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["base"] = { type = "Model", model = "models/props_combine/combine_booth_short01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.832, 1.029, -3.483), angle = Angle(-101.709, 0, 0), size = Vector(0.061, 0.019, 0.1), color = Color(255, 225, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["base+++++++++"] = { type = "Model", model = "models/props_lab/teleportring.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-1.397, -0.396, 1.409), angle = Angle(0, -180, -90), size = Vector(0.061, 0.054, 0.076), color = Color(127, 122, 113, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["baseclip"] = { type = "Model", model = "models/items/boxmrounds.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-9.65, 0, 6.611), angle = Angle(180, -90, -83.763), size = Vector(0.174, 0.236, 0.92), color = Color(210, 160, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["base++++++"] = { type = "Model", model = "models/props_combine/combine_train02a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-3.069, 0, -2.309), angle = Angle(0, -90, 23.74), size = Vector(0.008, 0.012, 0.009), color = Color(255, 225, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
