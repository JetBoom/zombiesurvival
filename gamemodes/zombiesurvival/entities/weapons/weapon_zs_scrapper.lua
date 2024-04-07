AddCSLuaFile()

SWEP.PrintName = "'scrapper' SMG"
SWEP.Description = "Simple SMG made from homemade parts."

SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.ViewModelBoneMods = {
	["v_weapon.MP5_Parent"] = { scale = Vector(0.093, 0.093, 0.093), pos = Vector(-3.149, 2.407, 2.407), angle = Angle(0, 0, 0) },
	["v_weapon.MP5_Bolt"] = { scale = Vector(0.037, 0.037, 0.037), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(12.222, 0, 0) },
	["ValveBiped.Bip01_Spine4"] = { scale = Vector(1, 1, 1), pos = Vector(-2.779, 2.036, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(0.978, 0.978, 0.978), pos = Vector(0.555, -0.926, 0.925), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(2.036, -0.657, 0.555), angle = Angle(0, 0, 0) }
}


SWEP.VElements = {
	["Beancan++"] = { type = "Model", model = "models/props_pipes/concrete_pipe001d.mdl", bone = "v_weapon.MP5_Parent", rel = "", pos = Vector(0, -3.336, -12.988), angle = Angle(90, -180, 0), size = Vector(0.012, 0.014, 0.014), color = Color(209, 236, 255, 255), surpresslightning = false, material = "models/props_pipes/pipesystem01a_skin2", skin = 0, bodygroup = {} },
	["Aim1+"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "v_weapon.MP5_Parent", rel = "", pos = Vector(-0.45, -3.636, 0.1), angle = Angle(-90, 0, 0), size = Vector(0.009, 0.009, 0.019), color = Color(213, 231, 255, 255), surpresslightning = false, material = "models/props_pipes/pipesystem01a_skin2", skin = 0, bodygroup = {} },
	["Trigger1"] = { type = "Model", model = "models/props_c17/handrail04_cap.mdl", bone = "v_weapon.MP5_Parent", rel = "", pos = Vector(0, -1.458, -2.797), angle = Angle(-180, 0, 0), size = Vector(0.172, 0.237, 0.107), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/pipesystem01a_skin2", skin = 0, bodygroup = {} },
	["Trigger2"] = { type = "Model", model = "models/props_junk/vent001_chunk6.mdl", bone = "v_weapon.MP5_Trigger", rel = "", pos = Vector(0, 0, -0.12), angle = Angle(118.052, 0, 0), size = Vector(0.136, 0.136, 0.136), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Handle++"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "v_weapon.MP5_Parent", rel = "", pos = Vector(0, -2.597, -1.558), angle = Angle(0, 0, -5.844), size = Vector(0.071, 0.107, 0.142), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
	["Aim1+++"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "v_weapon.MP5_Parent", rel = "", pos = Vector(0, -4.676, -0.101), angle = Angle(0, 0, 0), size = Vector(0.059, 0.059, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
	["Mainbody3+"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "v_weapon.MP5_Parent", rel = "", pos = Vector(0, -1.859, -6.553), angle = Angle(0, 0, 0), size = Vector(0.112, 0.142, 0.237), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/pipesystem01a_skin2", skin = 0, bodygroup = {} },
	["Mainbody2++"] = { type = "Model", model = "models/props_junk/metal_paintcan001a.mdl", bone = "v_weapon.MP5_Parent", rel = "", pos = Vector(0.1, -3.53, -2.701), angle = Angle(180, -1.17, 0), size = Vector(0.192, 0.192, 0.209), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_junk/i-beam_cluster01", skin = 0, bodygroup = {} },
	["Mainbody2++++"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "v_weapon.MP5_Parent", rel = "", pos = Vector(0.1, -2.597, -2.701), angle = Angle(180, 0, 0), size = Vector(0.128, 0.222, 0.116), color = Color(170, 186, 204, 255), surpresslightning = false, material = "models/props_c17/awning001b", skin = 0, bodygroup = {} },
	["Aim1+++++"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "v_weapon.MP5_Parent", rel = "", pos = Vector(-0.281, -5.145, -0.101), angle = Angle(0, 0, 0), size = Vector(0.012, 0.021, 0.012), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
	["Realbarrel+"] = { type = "Model", model = "models/props_pipes/concrete_pipe001a.mdl", bone = "v_weapon.MP5_Parent", rel = "", pos = Vector(0, -3.416, -16.105), angle = Angle(-90, -3.507, 0), size = Vector(0.021, 0.012, 0.012), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
	["Beancan++++"] = { type = "Model", model = "models/weapons/shell.mdl", bone = "v_weapon.MP5_Parent", rel = "", pos = Vector(0.4, -3.336, -10.91), angle = Angle(-90, -180, 0), size = Vector(1.21, 0.5, 0.5), color = Color(209, 236, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Mainbody2"] = { type = "Model", model = "models/props_wasteland/laundry_washer003.mdl", bone = "v_weapon.MP5_Parent", rel = "", pos = Vector(0.1, -3.631, -4.676), angle = Angle(90, -90, 0), size = Vector(0.012, 0.039, 0.039), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
	["Handle"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "v_weapon.MP5_Parent", rel = "", pos = Vector(0, 0.518, -1.208), angle = Angle(0, 0, -12.858), size = Vector(0.071, 0.37, 0.142), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
	["Mainbody1"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "v_weapon.MP5_Parent", rel = "", pos = Vector(0, -2.597, -0.45), angle = Angle(0, 0, 0), size = Vector(0.151, 0.151, 0.151), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/pipesystem01a_skin2", skin = 0, bodygroup = {} },
	["Strockbody1"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "v_weapon.MP5_Parent", rel = "", pos = Vector(0, -2.297, -10.301), angle = Angle(0, 0, 0), size = Vector(0.151, 0.122, 0.367), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_foliage/driftwood_01a", skin = 0, bodygroup = {} },
	["Aim1"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "v_weapon.MP5_Parent", rel = "", pos = Vector(0, -3, -0.519), angle = Angle(0, 0, 0), size = Vector(0.107, 0.107, 0.107), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
	["Stock"] = { type = "Model", model = "models/props_c17/handrail04_cap.mdl", bone = "v_weapon.MP5_Parent", rel = "", pos = Vector(0, -0.519, 4), angle = Angle(0, -180, -3.507), size = Vector(0.301, 0.301, 0.192), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
	["Ironsight"] = { type = "Model", model = "models/props_junk/vent001_chunk8.mdl", bone = "v_weapon.MP5_Parent", rel = "", pos = Vector(0, -4.375, -17.143), angle = Angle(-61.949, -180, 0), size = Vector(0.237, 0.237, 0.107), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
	["Bolt"] = { type = "Model", model = "models/props_wasteland/prison_throwswitchlever001.mdl", bone = "v_weapon.MP5_Bolt", rel = "", pos = Vector(-0.62, 1.557, 0.518), angle = Angle(0, 90, -90), size = Vector(0.172, 0.172, 0.061), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Beancan"] = { type = "Model", model = "models/props_pipes/concrete_pipe001d.mdl", bone = "v_weapon.MP5_Parent", rel = "", pos = Vector(0, -3.336, -6.753), angle = Angle(-90, -64.287, 0), size = Vector(0.071, 0.014, 0.014), color = Color(209, 236, 255, 255), surpresslightning = false, material = "models/props_pipes/pipesystem01a_skin2", skin = 0, bodygroup = {} },
	["Aim1++"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "v_weapon.MP5_Parent", rel = "", pos = Vector(0, -4, 0), angle = Angle(0, 0, -19.871), size = Vector(0.059, 0.059, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
	["Realbarrel++"] = { type = "Model", model = "models/props_pipes/concrete_pipe001a.mdl", bone = "v_weapon.MP5_Parent", rel = "", pos = Vector(0, -3.416, -16.543), angle = Angle(-90, -19.871, -12.858), size = Vector(0.017, 0.016, 0.016), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
	["Handle+"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "v_weapon.MP5_Parent", rel = "", pos = Vector(0, -1.958, -2.698), angle = Angle(0, 0, 0), size = Vector(0.1, 0.107, 0.519), color = Color(229, 214, 204, 255), surpresslightning = false, material = "models/props_docks/canal_docks01a", skin = 0, bodygroup = {} },
	["Realbarrel"] = { type = "Model", model = "models/props_canal/mattpipe.mdl", bone = "v_weapon.MP5_Parent", rel = "", pos = Vector(0, -3.537, -15.466), angle = Angle(-180, 90, 0), size = Vector(0.43, 0.43, 0.136), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
	["Beancan+"] = { type = "Model", model = "models/props_pipes/concrete_pipe001a.mdl", bone = "v_weapon.MP5_Bolt", rel = "", pos = Vector(0, 1.758, 1.957), angle = Angle(-90, 38.57, 0), size = Vector(0.041, 0.013, 0.013), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
	["Realbarrel+++"] = { type = "Model", model = "models/hunter/tubes/circle2x2.mdl", bone = "v_weapon.MP5_Parent", rel = "", pos = Vector(0, -3.416, -16.066), angle = Angle(-180, -3.507, 0), size = Vector(0.014, 0.014, 0.014), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/pipesystem01a_skin2", skin = 0, bodygroup = {} },
	["Strockbody1+"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "v_weapon.MP5_Parent", rel = "", pos = Vector(0, -2.297, -10.301), angle = Angle(0, 0, 0), size = Vector(0.155, 0.129, 0.155), color = Color(208, 233, 255, 255), surpresslightning = false, material = "models/props_c17/awning001b", skin = 0, bodygroup = {} },
	["Mainbody1+"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "v_weapon.MP5_Parent", rel = "", pos = Vector(0.009, -2, -3), angle = Angle(0.3, 0, 0), size = Vector(0.109, 0.119, 0.237), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
	["Mainbody2+++"] = { type = "Model", model = "models/props_junk/metal_paintcan001a.mdl", bone = "v_weapon.MP5_Parent", rel = "", pos = Vector(0.1, -3.54, -2.701), angle = Angle(180, -31.559, 0), size = Vector(0.197, 0.196, 0.107), color = Color(170, 186, 204, 255), surpresslightning = false, material = "models/props_c17/awning001b", skin = 0, bodygroup = {} },
	["Aim1++++"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "v_weapon.MP5_Parent", rel = "", pos = Vector(0.28, -5.145, -0.101), angle = Angle(0, 0, 0), size = Vector(0.012, 0.021, 0.012), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
	["Cliprelease"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "v_weapon.MP5_ClipRelease", rel = "", pos = Vector(0, 0.3, 1.139), angle = Angle(0, 0, 0), size = Vector(0.029, 0.107, 0.029), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
	["Mainbody3"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "v_weapon.MP5_Parent", rel = "", pos = Vector(0, -1.558, -6.753), angle = Angle(0, 0, 0), size = Vector(0.1, 0.237, 0.172), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/pipesystem01a_skin2", skin = 0, bodygroup = {} },
	["Magazine"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "v_weapon.MP5_Clip", rel = "", pos = Vector(0.4, 3.635, 0.1), angle = Angle(0, 8.182, 10.519), size = Vector(0.059, 0.625, 0.136), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
	["Beancan+++"] = { type = "Model", model = "models/hunter/tubes/tube1x1x1d.mdl", bone = "v_weapon.MP5_Parent", rel = "", pos = Vector(-0.101, -3.29, -12.988), angle = Angle(0, 155.455, 0), size = Vector(0.032, 0.032, 0.052), color = Color(209, 236, 255, 255), surpresslightning = false, material = "models/props_pipes/pipesystem01a_skin2", skin = 0, bodygroup = {} }
}
SWEP.WElements = {
	["Mainbody2"] = { type = "Model", model = "models/props_wasteland/laundry_washer003.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7.791, 0.819, -5.715), angle = Angle(169.481, 0, 0), size = Vector(0.012, 0.045, 0.045), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
	["Handle"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.635, 0.819, -0.519), angle = Angle(0, -90, -73.637), size = Vector(0.071, 0.37, 0.142), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
	["Mainbody1"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.635, 0.819, -3.537), angle = Angle(-10.52, 0, 0), size = Vector(0.151, 0.151, 0.151), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/pipesystem01a_skin2", skin = 0, bodygroup = {} },
	["Strockbody1"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(12.987, 0.819, -4.676), angle = Angle(-99.351, 0, 0), size = Vector(0.151, 0.122, 0.367), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_foliage/driftwood_01a", skin = 0, bodygroup = {} },
	["Aim1"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.635, 0.819, -4), angle = Angle(-8.183, 0, 0), size = Vector(0.107, 0.107, 0.107), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
	["Aim1+"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.135, 0.819, -5.315), angle = Angle(1.169, 0, 0), size = Vector(0.012, 0.107, 0.172), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
	["Trigger1"] = { type = "Model", model = "models/props_c17/handrail04_cap.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.714, 0.819, -2.898), angle = Angle(0, -90, -101.689), size = Vector(0.172, 0.237, 0.107), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/pipesystem01a_skin2", skin = 0, bodygroup = {} },
	["Stock"] = { type = "Model", model = "models/props_c17/handrail04_cap.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-0.519, 0, -0.519), angle = Angle(0, -90, 80.649), size = Vector(0.301, 0.301, 0.192), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
	["Ironsight"] = { type = "Model", model = "models/props_junk/vent001_chunk8.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(19.221, 0.819, -8.2), angle = Angle(-15.195, 0, 90), size = Vector(0.237, 0.237, 0.107), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
	["Beancan+"] = { type = "Model", model = "models/props_pipes/concrete_pipe001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(13.725, 0.819, -6.153), angle = Angle(-8.183, 0, -141.43), size = Vector(0.041, 0.013, 0.013), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
	["Bolt"] = { type = "Model", model = "models/props_wasteland/prison_throwswitchlever001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(15.064, 1.557, -6.753), angle = Angle(-101.689, -90, 0), size = Vector(0.172, 0.172, 0.061), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Beancan"] = { type = "Model", model = "models/props_pipes/concrete_pipe001d.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(11.947, 0.819, -6.1), angle = Angle(-8.183, 0, -57.273), size = Vector(0.071, 0.014, 0.014), color = Color(209, 236, 255, 255), surpresslightning = false, material = "models/props_pipes/pipesystem01a_skin2", skin = 0, bodygroup = {} },
	["Realbarrel"] = { type = "Model", model = "models/props_canal/mattpipe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(17.739, 0.819, -7.1), angle = Angle(99.35, -180, 0), size = Vector(0.43, 0.43, 0.136), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
	["Realbarrel++"] = { type = "Model", model = "models/props_pipes/concrete_pipe001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(19.221, 0.819, -7.192), angle = Angle(-8.183, 0, -82.987), size = Vector(0.017, 0.016, 0.016), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
	["Mainbody2+++"] = { type = "Model", model = "models/props_junk/metal_paintcan001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.9, 0.859, -5.315), angle = Angle(78.311, 0, 0), size = Vector(0.209, 0.209, 0.107), color = Color(170, 186, 204, 255), surpresslightning = false, material = "models/props_c17/awning001b", skin = 0, bodygroup = {} },
	["Mainbody2++"] = { type = "Model", model = "models/props_junk/metal_paintcan001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.9, 0.859, -5.315), angle = Angle(78.311, 0, 0), size = Vector(0.2, 0.2, 0.254), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_junk/i-beam_cluster01", skin = 0, bodygroup = {} },
	["Mainbody3"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(9.5, 0.819, -3.636), angle = Angle(8.182, -180, -90), size = Vector(0.142, 0.237, 0.107), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/pipesystem01a_skin2", skin = 0, bodygroup = {} },
	["Mainbody1+"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.199, 0.819, -3.636), angle = Angle(82.986, 0, 0), size = Vector(0.172, 0.151, 0.162), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
	["Mainbody3+"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(9.27, 0.819, -4.276), angle = Angle(-8.183, 0, 0), size = Vector(0.172, 0.172, 0.172), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/pipesystem01a_skin2", skin = 0, bodygroup = {} },
	["Realbarrel+"] = { type = "Model", model = "models/props_pipes/concrete_pipe001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(18.721, 0.819, -7.1), angle = Angle(-8.183, 0, -85.325), size = Vector(0.021, 0.012, 0.012), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
	["Handle+"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.752, 0.819, -3.636), angle = Angle(80.649, 0, 0), size = Vector(0.142, 0.131, 0.656), color = Color(229, 214, 204, 255), surpresslightning = false, material = "models/props_docks/canal_docks01a", skin = 0, bodygroup = {} },
	["Strockbody1+"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(12.987, 0.819, -4.676), angle = Angle(-99.351, 0, 0), size = Vector(0.155, 0.129, 0.155), color = Color(208, 233, 255, 255), surpresslightning = false, material = "models/props_c17/awning001b", skin = 0, bodygroup = {} },
	["Realbarrel+++"] = { type = "Model", model = "models/hunter/tubes/circle2x2.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(19.621, 0.819, -7.25), angle = Angle(-97.014, 0, 0), size = Vector(0.014, 0.014, 0.014), color = Color(0, 0, 0, 255), surpresslightning = false, material = "models/props_pipes/pipesystem01a_skin2", skin = 0, bodygroup = {} },
	["Magazine"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(10.399, 0.819, -0.82), angle = Angle(0, -90, 66.623), size = Vector(0.059, 0.432, 0.107), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} }
}



if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 50

	SWEP.HUD3DBone = "v_weapon.MP5_Parent"
	SWEP.HUD3DPos = Vector(-1, -3, -6)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.015
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "shotgun"

SWEP.ViewModel = "models/weapons/cstrike/c_smg_mp5.mdl"
SWEP.WorldModel = "models/weapons/w_smg_ump45.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("Weapon_MP5Navy.Single")
SWEP.Primary.Damage = 13
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.07
SWEP.ReloadSpeed = 1.2

SWEP.Primary.ClipSize = 40
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SMG1

SWEP.ConeMax = 6.5
SWEP.ConeMin = 3.6

SWEP.WalkSpeed = SPEED_SLOW

SWEP.Tier = 3

SWEP.IronSightsPos = Vector(-2.76, 0, 1.039)
SWEP.IronSightsAng = Vector(0, 0, 0)

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.1)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, "'bone crusher' SMG", "Additional damage to skeletal enemies, inflicts force, but fires and reloads slower", function(wept)
	wept.Primary.Delay = 0.09
	wept.ReloadSpeed = 0.9

	wept.BulletCallback = function(attacker, tr, dmginfo)
		local trent = tr.Entity

		if SERVER and trent and trent:IsValidZombie() then
			if trent:GetZombieClassTable().Skeletal then
				dmginfo:SetDamage(dmginfo:GetDamage() * 1.2)
			end

			if math.random(6) == 1 then
				trent:ThrowFromPositionSetZ(tr.StartPos, 150, nil, true)
			end
		end
	end
end)
