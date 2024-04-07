INC_CLIENT()

SWEP.HUD3DBone = "v_weapon.Glock_Slide"
SWEP.HUD3DPos = Vector(1, 0, -1)
SWEP.HUD3DAng = Angle(90, 0, -10)

SWEP.ViewModelFOV = 49
SWEP.ViewModelFlip = false

SWEP.Slot = 3
SWEP.SlotPos = 0

SWEP.VElements = {
	["t2_xbow+++"] = { type = "Model", model = "models/props_c17/lamp_bell_on.mdl", bone = "v_weapon.Glock_Parent", rel = "t2_xbow", pos = Vector(4, -0.101, -0.201), angle = Angle(90, 1.169, 0), size = Vector(0.05, 0.05, 0.15), color = Color(69, 85, 115, 255), surpresslightning = false, material = "models/props_pipes/guttermetal01a", skin = 0, bodygroup = {} },
	["t2_xbow++"] = { type = "Model", model = "models/weapons/w_pist_p228.mdl", bone = "v_weapon.Glock_Parent", rel = "t2_xbow", pos = Vector(-0.201, 0, -5.7), angle = Angle(0, 180, 0), size = Vector(0.699, 0.86, 0.899), color = Color(36, 41, 44, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
	["t2_xbow++++++"] = { type = "Model", model = "models/props_pipes/pipe02_straight01_long.mdl", bone = "v_weapon.Glock_Parent", rel = "t2_xbow", pos = Vector(-6.801, 2.7, -0.101), angle = Angle(0, 115.713, 0), size = Vector(0.007, 0.27, 0.007), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_c17/metalladder003", skin = 0, bodygroup = {} },
	["t2_xbow+"] = { type = "Model", model = "models/props_wasteland/prison_flourescentlight002b.mdl", bone = "v_weapon.Glock_Parent", rel = "t2_xbow", pos = Vector(-6.753, 0, -0.301), angle = Angle(90, 90, 0), size = Vector(0.3, 0.3, 0.2), color = Color(49, 64, 95, 255), surpresslightning = false, material = "models/props_pipes/guttermetal01a", skin = 0, bodygroup = {} },
	["t2_xbow+++++"] = { type = "Model", model = "models/props_phx/trains/monorail_curve.mdl", bone = "v_weapon.Glock_Parent", rel = "t2_xbow", pos = Vector(-5.831, 1.1, -0.519), angle = Angle(0, -54, 0), size = Vector(0.014, 0.014, 0.025), color = Color(51, 39, 31, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
	["t2_xbow++++"] = { type = "Model", model = "models/props_c17/metalladder001.mdl", bone = "v_weapon.Glock_Parent", rel = "t2_xbow", pos = Vector(-16, 0, -1), angle = Angle(0, 90, 92), size = Vector(0.05, 0.029, 0.109), color = Color(70, 80, 100, 255), surpresslightning = false, material = "models/props_pipes/guttermetal01a", skin = 0, bodygroup = {} },
	["t2_xbow"] = { type = "Model", model = "models/props_wasteland/laundry_cart001.mdl", bone = "v_weapon.Glock_Parent", rel = "", pos = Vector(2.5, -3.201, 0.649), angle = Angle(-3, -17, -79), size = Vector(0.059, 0.016, 0.025), color = Color(168, 165, 147, 0), surpresslightning = false, material = "models/weapons/v_crowbar/head_uvw", skin = 0, bodygroup = {} },
	["t2_xbow+++++++"] = { type = "Model", model = "models/props_pipes/pipe02_straight01_long.mdl", bone = "v_weapon.Glock_Parent", rel = "t2_xbow", pos = Vector(-6.5, -2.701, -0.101), angle = Angle(0, 62.285, 0), size = Vector(0.007, 0.27, 0.007), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_c17/metalladder003", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["t2_xbow+++++++"] = { type = "Model", model = "models/props_pipes/pipe02_straight01_long.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "t2_xbow", pos = Vector(-6.5, -2.701, -0.101), angle = Angle(0, 62.285, 0), size = Vector(0.007, 0.239, 0.007), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_c17/metalladder003", skin = 0, bodygroup = {} },
	["t2_xbow+++"] = { type = "Model", model = "models/props_c17/lamp_bell_on.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "t2_xbow", pos = Vector(4, -0.101, -0.201), angle = Angle(90, 1.169, 0), size = Vector(0.05, 0.05, 0.15), color = Color(69, 85, 115, 255), surpresslightning = false, material = "models/props_pipes/guttermetal01a", skin = 0, bodygroup = {} },
	["t2_xbow++++++"] = { type = "Model", model = "models/props_pipes/pipe02_straight01_long.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "t2_xbow", pos = Vector(-6.801, 2.7, -0.101), angle = Angle(0, 115.713, 0), size = Vector(0.007, 0.27, 0.007), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_c17/metalladder003", skin = 0, bodygroup = {} },
	["t2_xbow+"] = { type = "Model", model = "models/props_wasteland/prison_flourescentlight002b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "t2_xbow", pos = Vector(-6.753, 0, -0.301), angle = Angle(90, 90, 0), size = Vector(0.3, 0.3, 0.2), color = Color(49, 64, 95, 255), surpresslightning = false, material = "models/props_pipes/guttermetal01a", skin = 0, bodygroup = {} },
	["t2_xbow+++++"] = { type = "Model", model = "models/props_phx/trains/monorail_curve.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "t2_xbow", pos = Vector(-5.831, 1.1, -0.519), angle = Angle(0, -54, 0), size = Vector(0.014, 0.014, 0.025), color = Color(51, 39, 31, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
	["t2_xbow++++"] = { type = "Model", model = "models/props_c17/metalladder001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "t2_xbow", pos = Vector(-16, 0, -1), angle = Angle(0, 90, 92), size = Vector(0.05, 0.029, 0.109), color = Color(70, 80, 100, 255), surpresslightning = false, material = "models/props_pipes/guttermetal01a", skin = 0, bodygroup = {} },
	["t2_xbow"] = { type = "Model", model = "models/props_wasteland/laundry_cart001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 0.699, -4), angle = Angle(0, 180, 180), size = Vector(0.059, 0.016, 0.025), color = Color(168, 165, 147, 0), surpresslightning = false, material = "models/weapons/v_crowbar/head_uvw", skin = 0, bodygroup = {} },
	["t2_xbow++"] = { type = "Model", model = "models/weapons/w_pist_p228.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "t2_xbow", pos = Vector(-0.201, 0, -5.7), angle = Angle(0, 180, 0), size = Vector(0.699, 0.86, 0.899), color = Color(36, 41, 44, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} }
}
