AddCSLuaFile()

SWEP.PrintName = "'Death Stalker' aura m4"
SWEP.Description = "Using this gun will severely reduce the distance in which zombies can see your aura."
SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.ViewModelFOV = 53
SWEP.ViewModel = "models/weapons/cstrike/c_rif_m4a1.mdl"
SWEP.WorldModel = "models/weapons/w_pist_usp.mdl"
SWEP.ViewModelFlip = false
SWEP.ShowWorldModel = true
SWEP.ViewModelBoneMods = {
	["v_weapon.m4_Parent"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0.2, 0.95, -1.1), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["4"] = { type = "Model", model = "models/props_junk/CinderBlock01a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, 0.697, 5.684), angle = Angle(0, 90, 0), size = Vector(0.112, 0.064, 0.721), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} },
	["8+++"] = { type = "Model", model = "models/XQM/quad3.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, 1.661, -1.19), angle = Angle(0, -90, 90), size = Vector(0.03, 0.03, 0.256), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} },
	["3+"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "2", pos = Vector(0, 0, 3.658), angle = Angle(0, 90, 0), size = Vector(0.173, 0.068, 0.735), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} },
	["5"] = { type = "Model", model = "models/Mechanics/gears2/pinion_40t1.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, 1.292, 5.513), angle = Angle(90, 0, 0), size = Vector(0.131, 0.039, 0.082), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["1+"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "v_weapon.m4_Parent", rel = "1", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.451, 0.451, 0.184), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/gear", skin = 0, bodygroup = {} },
	["8++++"] = { type = "Model", model = "models/XQM/quad3.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "8+++", pos = Vector(0.072, -0.161, 0.136), angle = Angle(0, 0, 0), size = Vector(0.035, 0.009, 0.028), color = Color(0, 255, 0, 255), surpresslightning = true, material = "phoenix_storms/mrref2", skin = 0, bodygroup = {} },
	["7+"] = { type = "Model", model = "models/props_phx/construct/metal_tube.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, -1.456, 3.721), angle = Angle(0, 0, -90), size = Vector(0.043, 0.064, 0.024), color = Color(166, 166, 166, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} },
	["8+++++"] = { type = "Model", model = "models/XQM/quad3.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "8+++", pos = Vector(0.072, -0.161, -0.137), angle = Angle(0, 0, 0), size = Vector(0.035, 0.009, 0.028), color = Color(0, 255, 0, 255), surpresslightning = true, material = "phoenix_storms/mrref2", skin = 0, bodygroup = {} },
	["6+"] = { type = "Model", model = "models/hunter/tubes/tubebend2x2x90outer.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, -0.815, -4.194), angle = Angle(0, 0, 90), size = Vector(0.019, 0.019, 0.019), color = Color(166, 166, 166, 255), surpresslightning = false, material = "models/weapons/v_crowbar/head_uvw", skin = 0, bodygroup = {} },
	["mag"] = { type = "Model", model = "models/Items/BoxSRounds.mdl", bone = "v_weapon.m4_Clip", rel = "", pos = Vector(0, 1.48, -1.282), angle = Angle(0, 0, 0), size = Vector(0.202, 0.23, 0.245), color = Color(122, 122, 122, 255), surpresslightning = false, material = "phoenix_storms/dome", skin = 0, bodygroup = {} },
	["7"] = { type = "Model", model = "models/Items/battery.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, -0.921, 1.503), angle = Angle(0, 90, 0), size = Vector(0.463, 0.463, 0.463), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} },
	["8++"] = { type = "Model", model = "models/XQM/quad3.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, 1.661, -1.19), angle = Angle(0, -90, 90), size = Vector(0.03, 0.03, 0.256), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} },
	["8"] = { type = "Model", model = "models/XQM/quad3.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, 1.661, 13.598), angle = Angle(0, -90, 90), size = Vector(0.03, 0.009, 0.27), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} },
	["1"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "v_weapon.m4_Parent", rel = "", pos = Vector(0.625, -4.643, -0.146), angle = Angle(0, 0, 180), size = Vector(0.488, 0.488, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["B+"] = { type = "Model", model = "models/Items/battery.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "A", pos = Vector(0, 2.857, 0.727), angle = Angle(0, 90, 180), size = Vector(0.231, 0.231, 0.231), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} },
	["3++"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "2", pos = Vector(0, 0, 3.658), angle = Angle(0, 45, 0), size = Vector(0.173, 0.068, 0.735), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} },
	["8++++++"] = { type = "Model", model = "models/XQM/quad3.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "8+++", pos = Vector(0.071, -0.24, 0.136), angle = Angle(0, 0, 0), size = Vector(0.035, 0.009, 0.068), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} },
	["1++"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "v_weapon.m4_Parent", rel = "1", pos = Vector(0, 0, 18.406), angle = Angle(0, 0, 0), size = Vector(0.533, 0.533, 0.029), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} },
	["9"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, 0, 13.588), angle = Angle(0, 0, 90), size = Vector(0.054, 0.054, 0.019), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["8+++++++"] = { type = "Model", model = "models/hunter/tubes/tube2x2x025b.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "8", pos = Vector(0.61, 0, 0), angle = Angle(-45, 0, 90), size = Vector(0.01, 0.01, 0.01), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} },
	["6++"] = { type = "Model", model = "models/hunter/tubes/tubebend2x2x90outer.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, -0.972, -2.618), angle = Angle(0, 0, 180), size = Vector(0.019, 0.019, 0.019), color = Color(166, 166, 166, 255), surpresslightning = false, material = "models/weapons/v_crowbar/head_uvw", skin = 0, bodygroup = {} },
	["A"] = { type = "Model", model = "models/props_trainstation/Ceiling_Arch001a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, -3.258, -7.448), angle = Angle(180, 0, 0), size = Vector(0.075, 0.075, 0.075), color = Color(122, 122, 122, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["6"] = { type = "Model", model = "models/Mechanics/roboticslarge/a1.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, 0.068, 4.118), angle = Angle(90, 90, 0), size = Vector(0.326, 0.075, 0.081), color = Color(166, 166, 166, 255), surpresslightning = false, material = "models/weapons/v_crowbar/head_uvw", skin = 0, bodygroup = {} },
	["5+"] = { type = "Model", model = "models/Mechanics/gears2/pinion_40t1.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "2", pos = Vector(-0.96, 0, 3.927), angle = Angle(90, -90, 0), size = Vector(0.078, 0.052, 0.122), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["8+"] = { type = "Model", model = "models/hunter/tubes/tube2x2x025b.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "8", pos = Vector(0.61, 0, 0), angle = Angle(-45, 0, 90), size = Vector(0.009, 0.009, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} },
	["3"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "2", pos = Vector(0, 0, 3.658), angle = Angle(0, 0, 0), size = Vector(0.173, 0.068, 0.735), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} },
	["raczka"] = { type = "Model", model = "models/weapons/w_pist_usp.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, -6.223, -0.99), angle = Angle(90, 90, 0), size = Vector(1.1, 1.1, 1.1), color = Color(122, 122, 122, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} },
	["2"] = { type = "Model", model = "models/hunter/tubes/tube1x1x2.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, 0, 5.942), angle = Angle(0, 0, 0), size = Vector(0.041, 0.041, 0.07), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} },
	["B"] = { type = "Model", model = "models/Items/battery.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "A", pos = Vector(0, 3.253, -1.926), angle = Angle(0, -90, 0), size = Vector(0.293, 0.293, 0.293), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} },
	["8++++++++"] = { type = "Model", model = "models/XQM/quad3.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "8+++", pos = Vector(0.071, -0.24, -0.137), angle = Angle(0, 0, 0), size = Vector(0.035, 0.009, 0.068), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} },
	["3+++"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "2", pos = Vector(0, 0, 3.658), angle = Angle(0, -45, 0), size = Vector(0.173, 0.068, 0.735), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} }
}
SWEP.WElements = {
	["4"] = { type = "Model", model = "models/props_junk/CinderBlock01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, 0.697, 5.684), angle = Angle(0, 90, 0), size = Vector(0.112, 0.064, 0.721), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} },
	["8+++"] = { type = "Model", model = "models/XQM/quad3.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, 1.661, -1.19), angle = Angle(0, -90, 90), size = Vector(0.03, 0.03, 0.256), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} },
	["3+"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "2", pos = Vector(0, 0, 3.658), angle = Angle(0, 90, 0), size = Vector(0.173, 0.068, 0.735), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} },
	["5"] = { type = "Model", model = "models/Mechanics/gears2/pinion_40t1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, 1.292, 5.513), angle = Angle(90, 0, 0), size = Vector(0.131, 0.039, 0.082), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["1+"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.451, 0.451, 0.184), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/gear", skin = 0, bodygroup = {} },
	["8++++"] = { type = "Model", model = "models/XQM/quad3.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0.072, -0.161, 0.136), angle = Angle(0, 0, 0), size = Vector(0.035, 0.009, 0.028), color = Color(0, 255, 0, 255), surpresslightning = true, material = "phoenix_storms/mrref2", skin = 0, bodygroup = {} },
	["7+"] = { type = "Model", model = "models/props_phx/construct/metal_tube.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, -1.456, 3.721), angle = Angle(0, 0, -90), size = Vector(0.043, 0.064, 0.024), color = Color(166, 166, 166, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} },
	["3+++"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "2", pos = Vector(0, 0, 3.658), angle = Angle(0, -45, 0), size = Vector(0.173, 0.068, 0.735), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} },
	["mag"] = { type = "Model", model = "models/Items/BoxSRounds.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, -4.523, 2.24), angle = Angle(0, 0, 0), size = Vector(0.284, 0.284, 0.244), color = Color(122, 122, 122, 255), surpresslightning = false, material = "phoenix_storms/dome", skin = 0, bodygroup = {} },
	["7"] = { type = "Model", model = "models/Items/battery.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, -0.921, 1.503), angle = Angle(0, 90, 0), size = Vector(0.463, 0.463, 0.463), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} },
	["8++++++++"] = { type = "Model", model = "models/XQM/quad3.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "8+++", pos = Vector(0.071, -0.24, -0.137), angle = Angle(0, 0, 0), size = Vector(0.035, 0.009, 0.068), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} },
	["8++++++"] = { type = "Model", model = "models/XQM/quad3.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "8+++", pos = Vector(0.071, -0.24, 0.136), angle = Angle(0, 0, 0), size = Vector(0.035, 0.009, 0.068), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} },
	["6+"] = { type = "Model", model = "models/hunter/tubes/tubebend2x2x90outer.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, -0.815, -4.194), angle = Angle(0, 0, 90), size = Vector(0.019, 0.019, 0.019), color = Color(166, 166, 166, 255), surpresslightning = false, material = "models/weapons/v_crowbar/head_uvw", skin = 0, bodygroup = {} },
	["B+"] = { type = "Model", model = "models/Items/battery.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "A", pos = Vector(0, 2.857, 0.727), angle = Angle(0, 90, 180), size = Vector(0.231, 0.231, 0.231), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} },
	["3++"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "2", pos = Vector(0, 0, 3.658), angle = Angle(0, 45, 0), size = Vector(0.173, 0.068, 0.735), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} },
	["8"] = { type = "Model", model = "models/XQM/quad3.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, 1.661, 13.598), angle = Angle(0, -90, 90), size = Vector(0.03, 0.009, 0.27), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} },
	["1"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.96, 1.733, -3.84), angle = Angle(0, 89.158, 97.135), size = Vector(0.488, 0.488, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["9"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, 0, 13.588), angle = Angle(0, 0, 90), size = Vector(0.054, 0.054, 0.019), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["8+++++++"] = { type = "Model", model = "models/hunter/tubes/tube2x2x025b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "8", pos = Vector(0.61, 0, 0), angle = Angle(-45, 0, 90), size = Vector(0.01, 0.01, 0.01), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} },
	["6++"] = { type = "Model", model = "models/hunter/tubes/tubebend2x2x90outer.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, -0.972, -2.618), angle = Angle(0, 0, 180), size = Vector(0.019, 0.019, 0.019), color = Color(166, 166, 166, 255), surpresslightning = false, material = "models/weapons/v_crowbar/head_uvw", skin = 0, bodygroup = {} },
	["A"] = { type = "Model", model = "models/props_trainstation/Ceiling_Arch001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, -3.258, -7.448), angle = Angle(180, 0, 0), size = Vector(0.075, 0.075, 0.075), color = Color(122, 122, 122, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["6"] = { type = "Model", model = "models/Mechanics/roboticslarge/a1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, 0.068, 4.118), angle = Angle(90, 90, 0), size = Vector(0.326, 0.075, 0.081), color = Color(166, 166, 166, 255), surpresslightning = false, material = "models/weapons/v_crowbar/head_uvw", skin = 0, bodygroup = {} },
	["5+"] = { type = "Model", model = "models/Mechanics/gears2/pinion_40t1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "2", pos = Vector(-0.96, 0, 3.927), angle = Angle(90, -90, 0), size = Vector(0.078, 0.052, 0.122), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["8+"] = { type = "Model", model = "models/hunter/tubes/tube2x2x025b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "8", pos = Vector(0.61, 0, 0), angle = Angle(-45, 0, 90), size = Vector(0.009, 0.009, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} },
	["3"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "2", pos = Vector(0, 0, 3.658), angle = Angle(0, 0, 0), size = Vector(0.173, 0.068, 0.735), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} },
	["1++"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, 0, 18.406), angle = Angle(0, 0, 0), size = Vector(0.533, 0.533, 0.029), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} },
	["2"] = { type = "Model", model = "models/hunter/tubes/tube1x1x2.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, 0, 5.942), angle = Angle(0, 0, 0), size = Vector(0.041, 0.041, 0.07), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} },
	["8++"] = { type = "Model", model = "models/XQM/quad3.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, 1.661, -1.19), angle = Angle(0, -90, 90), size = Vector(0.03, 0.03, 0.256), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} },
	["B"] = { type = "Model", model = "models/Items/battery.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "A", pos = Vector(0, 3.253, -1.926), angle = Angle(0, -90, 0), size = Vector(0.293, 0.293, 0.293), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} },
	["8+++++"] = { type = "Model", model = "models/XQM/quad3.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "8+++", pos = Vector(0.072, -0.161, -0.137), angle = Angle(0, 0, 0), size = Vector(0.035, 0.009, 0.028), color = Color(0, 255, 0, 255), surpresslightning = true, material = "phoenix_storms/mrref2", skin = 0, bodygroup = {} }
}



SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"


SWEP.ViewModel = "models/weapons/cstrike/c_rif_m4a1.mdl"
SWEP.WorldModel = "models/weapons/w_rif_m4a1.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("weapons/usp/usp1.wav")
SWEP.Primary.Damage = 31
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.12

SWEP.Primary.ClipSize = 32
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SMG1

SWEP.ConeMax = 5
SWEP.ConeMin = 1.5

SWEP.WalkSpeed = SPEED_FAST

SWEP.Tier = 5

SWEP.IronSightsPos = Vector(-7.165, 9, 1.51)

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.625)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.187)
function SWEP:SetNextShot(nextshot)
	self:SetDTFloat(5, nextshot)
end

function SWEP:GetNextShot()
	return self:GetDTFloat(5)
end

function SWEP:SetShotsLeft(shotsleft)
	self:SetDTInt(1, shotsleft)
end

function SWEP:GetShotsLeft()
	return self:GetDTInt(1)
end

function SWEP:GetAuraRange()
	return 350
end


