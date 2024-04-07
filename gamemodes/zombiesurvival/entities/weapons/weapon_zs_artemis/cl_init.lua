INC_CLIENT()

SWEP.HUD3DBone = "v_weapon.slide_right"
SWEP.HUD3DPos = Vector(1, 0.1, -1)
SWEP.HUD3DScale = 0.015

SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 55

SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false

--[[SWEP.VElements = {
	["body_right"] = { type = "Model", model = "models/props_c17/utilityconnecter006b.mdl", bone = "v_weapon.elite_right", rel = "", pos = Vector(0.167, -2.628, 4.847), angle = Angle(0.563, -106.55, 1.19), size = Vector(0.126, 0.126, 0.268), color = Color(163, 139, 128, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["handle_left"] = { type = "Model", model = "models/props_pipes/pipe03_tjoint01.mdl", bone = "v_weapon.elite_left", rel = "", pos = Vector(-0.163, -1.935, 0), angle = Angle(-81.335, 0, 1.641), size = Vector(0.072, 0.072, 0.072), color = Color(92, 92, 100, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["crossbow_left"] = { type = "Model", model = "models/weapons/w_crossbow.mdl", bone = "v_weapon.elite_left", rel = "", pos = Vector(-0.879, -1.693, -1.333), angle = Angle(89.291, -88.288, 0), size = Vector(0.3, 0.3, 0.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["crossbow_right"] = { type = "Model", model = "models/weapons/w_crossbow.mdl", bone = "v_weapon.elite_right", rel = "", pos = Vector(-0.478, -1.316, -1.604), angle = Angle(90.704, -91.261, 0), size = Vector(0.298, 0.298, 0.298), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["body_left"] = { type = "Model", model = "models/props_c17/utilityconnecter006b.mdl", bone = "v_weapon.elite_left", rel = "", pos = Vector(-0.329, -2.794, 5.043), angle = Angle(-1.196, -106.321, -0.828), size = Vector(0.123, 0.123, 0.268), color = Color(163, 139, 128, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["handle_right"] = { type = "Model", model = "models/props_pipes/pipe03_tjoint01.mdl", bone = "v_weapon.elite_right", rel = "", pos = Vector(0.122, -1.599, -0.08), angle = Angle(-90.381, 0.898, 2.684), size = Vector(0.072, 0.072, 0.072), color = Color(92, 92, 100, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}]]

SWEP.VElements = {
	["artemis_right++++"] = { type = "Model", model = "models/weapons/w_crossbow.mdl", bone = "v_weapon.elite_right", rel = "artemis_right+++", pos = Vector(-0.9, 4.099, 0.899), angle = Angle(0, 90, 180), size = Vector(0.649, 0.449, 0.36), color = Color(165, 183, 206, 255), surpresslightning = false, material = "models/weapons/v_smg1/v_smg1_sheet", skin = 0, bodygroup = {} },
	["artemis_right++"] = { type = "Model", model = "models/props_pipes/pipe03_tjoint01.mdl", bone = "v_weapon.elite_right", rel = "artemis_right", pos = Vector(0, 3, 2), angle = Angle(-90, 0, 0), size = Vector(0.129, 0.059, 0.059), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_smg1/v_smg1_sheet", skin = 0, bodygroup = {} },
	["artemis_right"] = { type = "Model", model = "models/props_c17/utilityconnecter003.mdl", bone = "v_weapon.elite_right", rel = "", pos = Vector(0, -1.8, 4), angle = Angle(0, 0, 90), size = Vector(0.37, 0.4, 0.79), color = Color(64, 69, 77, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
	["artemis_right+++"] = { type = "Model", model = "models/props_c17/utilityconnecter003.mdl", bone = "v_weapon.elite_left", rel = "", pos = Vector(0, -1.8, 4), angle = Angle(0, 0, 90), size = Vector(0.37, 0.4, 0.79), color = Color(64, 69, 77, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
	["artemis_right+"] = { type = "Model", model = "models/weapons/w_crossbow.mdl", bone = "v_weapon.elite_right", rel = "artemis_right", pos = Vector(-0.9, 4.099, 0.899), angle = Angle(0, 90, 180), size = Vector(0.649, 0.449, 0.36), color = Color(165, 183, 206, 255), surpresslightning = false, material = "models/weapons/v_smg1/v_smg1_sheet", skin = 0, bodygroup = {} },
	["artemis_right+++++"] = { type = "Model", model = "models/props_pipes/pipe03_tjoint01.mdl", bone = "v_weapon.elite_right", rel = "artemis_right+++", pos = Vector(0, 3, 2), angle = Angle(-90, 0, 0), size = Vector(0.129, 0.059, 0.059), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_smg1/v_smg1_sheet", skin = 0, bodygroup = {} }
}

--[[SWEP.WElements = {
	["body_right"] = { type = "Model", model = "models/props_c17/utilityconnecter006b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(9.178, 2.211, -4.311), angle = Angle(-90.067, -11.381, 0), size = Vector(0.126, 0.126, 0.268), color = Color(163, 139, 128, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["handle_left"] = { type = "Model", model = "models/props_pipes/pipe03_tjoint01.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(3.846, 0.948, 2.664), angle = Angle(169.447, -9.483, -80.786), size = Vector(0.133, 0.182, 0.133), color = Color(92, 100, 100, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["crossbow_left"] = { type = "Model", model = "models/weapons/w_crossbow.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.891, 2.073, 2.49), angle = Angle(-0.891, -8.582, -3.764), size = Vector(0.354, 0.582, 0.549), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["crossbow_right"] = { type = "Model", model = "models/weapons/w_crossbow.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.293, -0.295, -2.323), angle = Angle(0.202, -12.063, -180), size = Vector(0.352, 0.587, 0.546), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["handle_right"] = { type = "Model", model = "models/props_pipes/pipe03_tjoint01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.701, 1.195, -2.6), angle = Angle(9.09, -13.66, -82.725), size = Vector(0.133, 0.182, 0.133), color = Color(92, 100, 100, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["body_left"] = { type = "Model", model = "models/props_c17/utilityconnecter006b.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(9.201, 1.623, 4.335), angle = Angle(-90.061, -9.018, 0), size = Vector(0.123, 0.123, 0.268), color = Color(163, 139, 128, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}]]

SWEP.WElements = {
	["artemis_right++++"] = { type = "Model", model = "models/weapons/w_crossbow.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "artemis_right+++", pos = Vector(-0.9, 4.099, 0.899), angle = Angle(0, 90, 180), size = Vector(0.649, 0.449, 0.36), color = Color(165, 183, 206, 255), surpresslightning = false, material = "models/weapons/v_smg1/v_smg1_sheet", skin = 0, bodygroup = {} },
	["artemis_right++"] = { type = "Model", model = "models/props_pipes/pipe03_tjoint01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "artemis_right", pos = Vector(0, 3, 2), angle = Angle(-90, 0, 0), size = Vector(0.129, 0.059, 0.059), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_smg1/v_smg1_sheet", skin = 0, bodygroup = {} },
	["artemis_right"] = { type = "Model", model = "models/props_c17/utilityconnecter003.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7.9, 1.299, -4), angle = Angle(0, -90, 0), size = Vector(0.37, 0.4, 0.79), color = Color(64, 69, 77, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
	["artemis_right+++"] = { type = "Model", model = "models/props_c17/utilityconnecter003.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(7.8, 1.799, 4), angle = Angle(180, -100, -5.844), size = Vector(0.37, 0.4, 0.79), color = Color(64, 69, 77, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
	["artemis_right+"] = { type = "Model", model = "models/weapons/w_crossbow.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "artemis_right", pos = Vector(-0.9, 4.099, 0.899), angle = Angle(0, 90, 180), size = Vector(0.649, 0.449, 0.36), color = Color(165, 183, 206, 255), surpresslightning = false, material = "models/weapons/v_smg1/v_smg1_sheet", skin = 0, bodygroup = {} },
	["artemis_right+++++"] = { type = "Model", model = "models/props_pipes/pipe03_tjoint01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "artemis_right+++", pos = Vector(0, 3, 2), angle = Angle(-90, 0, 0), size = Vector(0.129, 0.059, 0.059), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_smg1/v_smg1_sheet", skin = 0, bodygroup = {} }
}

local ghostlerp = 0
function SWEP:CalcViewModelView(vm, oldpos, oldang, pos, ang)
	if self:GetOwner():GetBarricadeGhosting() or self:GetReloadFinish() > 0 then
		ghostlerp = math.min(1, ghostlerp + FrameTime() * 1)
	elseif ghostlerp > 0 then
		ghostlerp = math.max(0, ghostlerp - FrameTime() * 1.5)
	end

	if ghostlerp > 0 then
		ang:RotateAroundAxis(ang:Right(), -35 * ghostlerp)
	end

	return pos, ang
end
