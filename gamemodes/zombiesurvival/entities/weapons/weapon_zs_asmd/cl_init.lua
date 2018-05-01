INC_CLIENT()

SWEP.ViewModelFlip = false
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false
SWEP.ViewModelFOV = 70

SWEP.HUD3DBone = "v_weapon.awm_parent"
SWEP.HUD3DPos = Vector(-1.75, -4.5, -10)
SWEP.HUD3DAng = Angle(0, 0, 0)
SWEP.HUD3DScale = 0.02

SWEP.VElements = {
	["FRONT2FONT"] = { type = "Model", model = "models/props_junk/wood_crate001a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "FRONT2+", pos = Vector(5.882, -0.225, 0), angle = Angle(0, 0, 0), size = Vector(0.05, 0.021, 0.041), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/V_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
	["FRONTbacklol"] = { type = "Model", model = "models/weapons/w_smg_p90.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "FRONTBACK", pos = Vector(3.255, -4.786, -0.195), angle = Angle(0, -90, 90), size = Vector(0.512, 1.407, 0.584), color = Color(145, 145, 145, 255), surpresslightning = false, material = "models/props_canal/metalwall005b", skin = 0, bodygroup = {} },
	["FRONTBACK"] = { type = "Model", model = "models/props_lab/reciever01b.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "FRONT", pos = Vector(0, 1.042, 8.17), angle = Angle(0, -90, 90), size = Vector(0.323, 0.409, 0.333), color = Color(145, 145, 145, 255), surpresslightning = false, material = "models/props_canal/metalwall005b", skin = 0, bodygroup = {} },
	["FRONTscope"] = { type = "Model", model = "models/props_combine/breenlight.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "FRONTBACK", pos = Vector(-3.201, 0.575, 0), angle = Angle(180, 0, 90), size = Vector(0.453, 0.532, 0.414), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_canal/metalwall005b", skin = 0, bodygroup = {} },
	["FRONT2+"] = { type = "Model", model = "models/props_pipes/concrete_pipe001a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "FRONT", pos = Vector(0, -0.473, -0.285), angle = Angle(-90, 0, 0), size = Vector(0.093, 0.009, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/V_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
	["FRONTscope+"] = { type = "Model", model = "models/props_c17/gravestone004a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "FRONTBACK", pos = Vector(-2.722, -3.057, 0), angle = Angle(180, -90, 90), size = Vector(0.048, 0.028, 0.09), color = Color(165, 165, 150, 255), surpresslightning = false, material = "models/props_combine/combine_interface_disp", skin = 0, bodygroup = {} },
	["FRONTENERGY+++"] = { type = "Model", model = "models/props_junk/cardboard_box001a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "FRONTBACK", pos = Vector(-1.471, -5.29, 0), angle = Angle(0, 90, 90), size = Vector(0.123, 0.056, 0.067), color = Color(255, 0, 150, 255), surpresslightning = false, material = "models/props_combine/masterinterface01c", skin = 0, bodygroup = {} },
	["FRONTcanisters"] = { type = "Model", model = "models/props_borealis/mooring_cleat01.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "FRONT", pos = Vector(0, 2.069, 2.289), angle = Angle(0, 80, -90), size = Vector(0.085, 0.104, 0.078), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_canal/metalwall005b", skin = 0, bodygroup = {} },
	["FRONT2"] = { type = "Model", model = "models/props_pipes/concrete_pipe001a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "FRONT", pos = Vector(0, 0.398, -0.285), angle = Angle(-90, 0, 0), size = Vector(0.093, 0.019, 0.019), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/V_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
	["FRONT"] = { type = "Model", model = "models/props_wasteland/laundry_basket001.mdl", bone = "v_weapon.awm_parent", rel = "", pos = Vector(0, -4.375, -18.455), angle = Angle(0, 0, 0), size = Vector(0.059, 0.054, 0.179), color = Color(235, 235, 235, 255), surpresslightning = false, material = "models/props_c17/metalladder001", skin = 0, bodygroup = {} },
	["FRONTbottom"] = { type = "Model", model = "models/props_combine/combinetrain01a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "FRONT", pos = Vector(0, 0.787, 1.118), angle = Angle(90, -90, 180), size = Vector(0.014, 0.016, 0.009), color = Color(165, 165, 150, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["FRONTENERGY+++++++++++"] = { type = "Model", model = "models/props_junk/cardboard_box001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "FRONTBACK", pos = Vector(-1.471, -6.709, 0), angle = Angle(0, 90, 90), size = Vector(0.153, 0.065, 0.067), color = Color(255, 0, 150, 255), surpresslightning = false, material = "models/props_combine/masterinterface01c", skin = 0, bodygroup = {} },
	["FRONT2FONT"] = { type = "Model", model = "models/props_junk/wood_crate001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "FRONT2+", pos = Vector(7.397, -0.08, 0), angle = Angle(0, 0, 0), size = Vector(0.039, 0.032, 0.046), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/V_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
	["FRONTbacklol"] = { type = "Model", model = "models/weapons/w_smg_p90.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "FRONTBACK", pos = Vector(3.872, -6.269, -0.195), angle = Angle(0, -90, 90), size = Vector(0.639, 1.473, 0.649), color = Color(145, 145, 145, 255), surpresslightning = false, material = "models/props_canal/metalwall005b", skin = 0, bodygroup = {} },
	["FRONT"] = { type = "Model", model = "models/props_wasteland/laundry_basket001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(18.645, 0.907, -5.737), angle = Angle(0, 91.977, -79.036), size = Vector(0.064, 0.059, 0.224), color = Color(235, 235, 235, 255), surpresslightning = false, material = "models/props_c17/metalladder001", skin = 0, bodygroup = {} },
	["FRONTscope"] = { type = "Model", model = "models/props_combine/breenlight.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "FRONTBACK", pos = Vector(-3.201, 0.505, 0), angle = Angle(180, 0, 90), size = Vector(0.568, 0.665, 0.518), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_canal/metalwall005b", skin = 0, bodygroup = {} },
	["FRONT2+"] = { type = "Model", model = "models/props_pipes/concrete_pipe001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "FRONT", pos = Vector(0, -0.7, -0.285), angle = Angle(-90, 0, 0), size = Vector(0.119, 0.014, 0.014), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/V_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
	["FRONTscope+"] = { type = "Model", model = "models/props_c17/gravestone004a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "FRONTBACK", pos = Vector(-2.563, -4.066, 0), angle = Angle(180, -90, 90), size = Vector(0.061, 0.035, 0.112), color = Color(165, 165, 150, 255), surpresslightning = false, material = "models/props_combine/combine_interface_disp", skin = 0, bodygroup = {} },
	["FRONT2"] = { type = "Model", model = "models/props_pipes/concrete_pipe001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "FRONT", pos = Vector(0, 0.398, -0.285), angle = Angle(-90, 0, 0), size = Vector(0.116, 0.025, 0.025), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/V_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
	["FRONTcanisters"] = { type = "Model", model = "models/props_borealis/mooring_cleat01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "FRONT", pos = Vector(0, 2.069, 0.37), angle = Angle(0, 80, -90), size = Vector(0.128, 0.158, 0.118), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_canal/metalwall005b", skin = 0, bodygroup = {} },
	["FRONTBACK"] = { type = "Model", model = "models/props_lab/reciever01b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "FRONT", pos = Vector(0, 1.042, 8.17), angle = Angle(0, -90, 90), size = Vector(0.393, 0.49, 0.4), color = Color(145, 145, 145, 255), surpresslightning = false, material = "models/props_canal/metalwall005b", skin = 0, bodygroup = {} },
	["FRONTbottom"] = { type = "Model", model = "models/props_combine/combinetrain01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "FRONT", pos = Vector(0, 0.787, 1.118), angle = Angle(90, -90, 180), size = Vector(0.018, 0.019, 0.009), color = Color(165, 165, 150, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} }
}

SWEP.ViewModelBoneMods = {
	["v_weapon.awm_parent"] = { scale = Vector(1, 1, 1), pos = Vector(-10.822, 0, 0), angle = Angle(0, 0, 0) }
}
