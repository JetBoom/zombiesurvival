INC_CLIENT()

SWEP.Slot = 4
SWEP.SlotPos = 0

SWEP.HUD3DBone = "v_weapon.p90_Parent"
SWEP.HUD3DPos = Vector(0.1, -7.8, -0.2)
SWEP.HUD3DAng = Angle(0, 0, 0)

SWEP.ViewModelFOV = 50
SWEP.ViewModelFlip = false
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false

SWEP.VElements = {
	["base+++"] = { type = "Model", model = "models/props_combine/combine_interface002.mdl", bone = "v_weapon.p90_Parent", rel = "base", pos = Vector(-3.22, -0.101, 4.764), angle = Angle(180, 0, 180), size = Vector(0.048, 0.021, 0.07), color = Color(20, 24, 24, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin1", skin = 0, bodygroup = {} },
	["base++"] = { type = "Model", model = "models/props_wasteland/laundry_basket001.mdl", bone = "v_weapon.p90_Parent", rel = "base", pos = Vector(0.335, 0, -4.156), angle = Angle(180, 90, 0), size = Vector(0.045, 0.045, 0.103), color = Color(52, 52, 64, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["base+++++++"] = { type = "Model", model = "models/props_combine/headcrabcannister01a.mdl", bone = "v_weapon.p90_Parent", rel = "base", pos = Vector(0.669, -0.02, 3.68), angle = Angle(-92.179, 0, 0), size = Vector(0.059, 0.013, 0.045), color = Color(19, 22, 21, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin1", skin = 0, bodygroup = {} },
	["base+"] = { type = "Model", model = "models/props_lab/teleplatform.mdl", bone = "v_weapon.p90_Parent", rel = "base", pos = Vector(-0.26, 0, -1.509), angle = Angle(0, 0, 0), size = Vector(0.05, 0.029, 0.103), color = Color(33, 33, 33, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["base++++"] = { type = "Model", model = "models/props_combine/combine_booth_short01a.mdl", bone = "v_weapon.p90_Parent", rel = "base", pos = Vector(-0.294, -0.101, 5.506), angle = Angle(0, -180, -180), size = Vector(0.056, 0.014, 0.045), color = Color(24, 27, 27, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin1", skin = 0, bodygroup = {} },
	["base++++++"] = { type = "Model", model = "models/items/combine_rifle_cartridge01.mdl", bone = "v_weapon.p90_Parent", rel = "base", pos = Vector(1.248, 0, 5.406), angle = Angle(-61.563, 0, 0), size = Vector(0.389, 0.501, 0.593), color = Color(19, 20, 19, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin1", skin = 0, bodygroup = {} },
	["base"] = { type = "Model", model = "models/props_wasteland/laundry_washer001a.mdl", bone = "v_weapon.p90_Parent", rel = "", pos = Vector(0, -4.014, -8.922), angle = Angle(0, -90, 0), size = Vector(0.045, 0.014, 0.059), color = Color(54, 74, 78, 255), surpresslightning = false, material = "models/props_pipes/guttermetal01a", skin = 0, bodygroup = {} },
	["base+++++"] = { type = "Model", model = "models/props_lab/reciever01a.mdl", bone = "v_weapon.p90_Parent", rel = "base", pos = Vector(0.024, 0, 7.936), angle = Angle(0, -90, -90), size = Vector(0.134, 0.547, 0.184), color = Color(24, 27, 27, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin1", skin = 0, bodygroup = {} },
	["clipbase"] = { type = "Model", model = "models/props_c17/light_decklight01_off.mdl", bone = "v_weapon.p90_Clip", rel = "", pos = Vector(0.119, -0.375, -4.686), angle = Angle(0.279, -90, -90), size = Vector(0.157, 0.495, 0.074), color = Color(45, 30, 30, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["base++++++++"] = { type = "Model", model = "models/props_wasteland/prison_padlock001a.mdl", bone = "v_weapon.p90_Parent", rel = "base", pos = Vector(1.782, 0, 13.51), angle = Angle(-180, 90, 0), size = Vector(0.703, 0.745, 1.062), color = Color(37, 40, 41, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["base+++++"] = { type = "Model", model = "models/props_lab/reciever01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0.024, 0, 7.936), angle = Angle(0, -90, -90), size = Vector(0.134, 0.547, 0.184), color = Color(24, 27, 27, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin1", skin = 0, bodygroup = {} },
	["base++"] = { type = "Model", model = "models/props_wasteland/laundry_basket001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0.335, 0, -4.156), angle = Angle(180, 90, 0), size = Vector(0.045, 0.045, 0.103), color = Color(52, 52, 64, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["base+++++++"] = { type = "Model", model = "models/props_combine/headcrabcannister01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0.669, -0.02, 3.68), angle = Angle(-92.179, 0, 0), size = Vector(0.059, 0.013, 0.045), color = Color(19, 22, 21, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin1", skin = 0, bodygroup = {} },
	["base+"] = { type = "Model", model = "models/props_lab/teleplatform.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-0.26, 0, -1.509), angle = Angle(0, 0, 0), size = Vector(0.05, 0.029, 0.103), color = Color(33, 33, 33, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["base++++"] = { type = "Model", model = "models/props_combine/combine_booth_short01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-0.294, -0.101, 5.506), angle = Angle(0, -180, -180), size = Vector(0.056, 0.014, 0.045), color = Color(24, 27, 27, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin1", skin = 0, bodygroup = {} },
	["base++++++"] = { type = "Model", model = "models/items/combine_rifle_cartridge01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(1.248, 0, 5.406), angle = Angle(-61.563, 0, 0), size = Vector(0.389, 0.501, 0.593), color = Color(19, 20, 19, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin1", skin = 0, bodygroup = {} },
	["base"] = { type = "Model", model = "models/props_wasteland/laundry_washer001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(12.843, 0.741, -5.005), angle = Angle(80.433, 0, 0), size = Vector(0.045, 0.014, 0.059), color = Color(54, 74, 78, 255), surpresslightning = false, material = "models/props_pipes/guttermetal01a", skin = 0, bodygroup = {} },
	["base++++++++"] = { type = "Model", model = "models/props_wasteland/prison_padlock001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(1.782, 0, 13.51), angle = Angle(-180, 90, 0), size = Vector(0.703, 0.745, 1.062), color = Color(37, 40, 41, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["clipbase"] = { type = "Model", model = "models/props_c17/light_decklight01_off.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-1.352, -0.051, 7.768), angle = Angle(0, 0, 90), size = Vector(0.157, 0.495, 0.074), color = Color(45, 30, 30, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["base+++"] = { type = "Model", model = "models/props_combine/combine_interface002.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-3.22, -0.101, 4.764), angle = Angle(180, 0, 180), size = Vector(0.048, 0.021, 0.07), color = Color(20, 24, 24, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin1", skin = 0, bodygroup = {} }
}

function SWEP:SecondaryAttack()
end
