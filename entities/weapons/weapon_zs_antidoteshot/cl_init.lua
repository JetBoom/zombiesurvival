INC_CLIENT()

DEFINE_BASECLASS("weapon_zs_baseproj")

SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 56

SWEP.HUD3DBone = "v_weapon.Deagle_Parent"
SWEP.HUD3DPos = Vector(0.1, -4.2, 2.22)
SWEP.HUD3DAng = Angle(0, 0, 0)
SWEP.HUD3DScale = 0.016

SWEP.VElements = {
	["novacolt++++++"] = { type = "Model", model = "models/props_c17/furnituredrawer003a.mdl", bone = "v_weapon.Deagle_Parent", rel = "novacolt", pos = Vector(0.3, 6, 3), angle = Angle(90, -90, 0), size = Vector(0.15, 0.15, 0.15), color = Color(148, 152, 183, 255), surpresslightning = false, material = "models/props_c17/clockwood01", skin = 0, bodygroup = {} },
	["novacolt++++++++++"] = { type = "Model", model = "models/props_lab/labpart.mdl", bone = "v_weapon.Deagle_Parent", rel = "novacolt", pos = Vector(3.2, 2.299, 0), angle = Angle(0, -43, 0), size = Vector(0.09, 0.129, 0.09), color = Color(59, 130, 99, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["novacolt++"] = { type = "Model", model = "models/props_combine/combinethumper002.mdl", bone = "v_weapon.Deagle_Parent", rel = "novacolt", pos = Vector(-0.5, 3.5, 3.5), angle = Angle(0, 0, 180), size = Vector(0.039, 0.059, 0.059), color = Color(92, 108, 118, 255), surpresslightning = false, material = "models/weapons/v_stunstick/v_stunstick_diffuse", skin = 0, bodygroup = {} },
	["novacolt+++"] = { type = "Model", model = "models/props_trainstation/boxcar.mdl", bone = "v_weapon.Deagle_Parent", rel = "novacolt", pos = Vector(0.1, 2.9, -4.6), angle = Angle(90, 0, -90), size = Vector(0.035, 0.014, 0.032), color = Color(148, 171, 181, 255), surpresslightning = false, material = "models/weapons/v_smg1/v_smg1_sheet", skin = 0, bodygroup = {} },
	["novacolt"] = { type = "Model", model = "models/props_wasteland/laundry_washer001a.mdl", bone = "v_weapon.Deagle_Parent", rel = "", pos = Vector(0, -4.401, -1.5), angle = Angle(0, 0, 0), size = Vector(0.039, 0.029, 0.059), color = Color(175, 200, 231, 0), surpresslightning = false, material = "models/weapons/v_shotgun/vshotgun_albedo", skin = 0, bodygroup = {} },
	["novacolt+++++++++"] = { type = "Model", model = "models/props_lab/labpart.mdl", bone = "v_weapon.Deagle_Parent", rel = "novacolt", pos = Vector(-3, 2.299, 0), angle = Angle(0, 43.247, 0), size = Vector(0.09, 0.129, 0.09), color = Color(59, 130, 99, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["novacolt+++++"] = { type = "Model", model = "models/props_wasteland/laundry_dryer001.mdl", bone = "v_weapon.Deagle_Parent", rel = "novacolt", pos = Vector(0, 0.6, 3), angle = Angle(110, -90, 0), size = Vector(0.019, 0.03, 0.034), color = Color(105, 115, 130, 255), surpresslightning = false, material = "models/props_c17/column02a", skin = 0, bodygroup = {} },
	["novacolt+"] = { type = "Model", model = "models/props_wasteland/laundry_washer001a.mdl", bone = "v_weapon.Deagle_Parent", rel = "novacolt", pos = Vector(0, 3, -0.35), angle = Angle(90, 0, 0), size = Vector(0.029, 0.029, 0.05), color = Color(92, 108, 118, 255), surpresslightning = false, material = "models/weapons/v_smg1/texture4", skin = 0, bodygroup = {} },
	["novacolt+++++++"] = { type = "Model", model = "models/props_lab/eyescanner.mdl", bone = "v_weapon.Deagle_Parent", rel = "novacolt", pos = Vector(0, -1.601, 2.2), angle = Angle(66.623, 90, 0), size = Vector(0.129, 0.15, 0.17), color = Color(47, 67, 82, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["novacolt++++"] = { type = "Model", model = "models/props_combine/combine_train02a.mdl", bone = "v_weapon.Deagle_Parent", rel = "novacolt", pos = Vector(0.1, -0.9, -4.6), angle = Angle(0, 180, 90), size = Vector(0.019, 0.019, 0.012), color = Color(127, 145, 163, 255), surpresslightning = false, material = "models/weapons/w_irifle/w_irifle", skin = 0, bodygroup = {} },
	["novacolt++++++++"] = { type = "Model", model = "models/props_wasteland/laundry_washer001a.mdl", bone = "v_weapon.Deagle_Parent", rel = "novacolt", pos = Vector(0, 3, -0.35), angle = Angle(90, 0, 0), size = Vector(0.009, 0.009, 0.079), color = Color(156, 180, 206, 255), surpresslightning = false, material = "models/weapons/v_smg1/texture4", skin = 0, bodygroup = {} }
}
SWEP.WElements = {
	["novacolt++++++"] = { type = "Model", model = "models/props_c17/furnituredrawer003a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "novacolt", pos = Vector(0.3, 6, 3), angle = Angle(90, -90, 0), size = Vector(0.15, 0.15, 0.15), color = Color(148, 152, 183, 255), surpresslightning = false, material = "models/props_c17/clockwood01", skin = 0, bodygroup = {} },
	["novacolt++++++++++"] = { type = "Model", model = "models/props_lab/labpart.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "novacolt", pos = Vector(3.2, 2.299, 0), angle = Angle(0, -43, 0), size = Vector(0.09, 0.129, 0.09), color = Color(59, 130, 99, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["novacolt++"] = { type = "Model", model = "models/props_combine/combinethumper002.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "novacolt", pos = Vector(0, 3.635, 3.5), angle = Angle(0, 0, 180), size = Vector(0.039, 0.059, 0.059), color = Color(201, 229, 248, 255), surpresslightning = false, material = "models/weapons/v_stunstick/v_stunstick_diffuse", skin = 0, bodygroup = {} },
	["novacolt+++"] = { type = "Model", model = "models/props_trainstation/boxcar.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "novacolt", pos = Vector(0.1, 2.9, -4.6), angle = Angle(90, 0, -90), size = Vector(0.035, 0.014, 0.032), color = Color(148, 171, 181, 255), surpresslightning = false, material = "models/weapons/v_smg1/v_smg1_sheet", skin = 0, bodygroup = {} },
	["novacolt"] = { type = "Model", model = "models/props_wasteland/laundry_washer001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5, 2, -5), angle = Angle(0, 90, -85.325), size = Vector(0.039, 0.029, 0.059), color = Color(175, 200, 231, 0), surpresslightning = false, material = "models/weapons/v_shotgun/vshotgun_albedo", skin = 0, bodygroup = {} },
	["novacolt+++++++++"] = { type = "Model", model = "models/props_lab/labpart.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "novacolt", pos = Vector(-3, 2.299, 0), angle = Angle(0, 43.247, 0), size = Vector(0.09, 0.129, 0.09), color = Color(59, 130, 99, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["novacolt+++++"] = { type = "Model", model = "models/props_wasteland/laundry_dryer001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "novacolt", pos = Vector(0, 0.6, 3), angle = Angle(110, -90, 0), size = Vector(0.019, 0.03, 0.034), color = Color(105, 115, 130, 255), surpresslightning = false, material = "models/props_c17/column02a", skin = 0, bodygroup = {} },
	["novacolt+"] = { type = "Model", model = "models/props_wasteland/laundry_washer001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "novacolt", pos = Vector(0, 3, -0.35), angle = Angle(90, 0, 0), size = Vector(0.029, 0.029, 0.05), color = Color(92, 108, 118, 255), surpresslightning = false, material = "models/weapons/v_smg1/texture4", skin = 0, bodygroup = {} },
	["novacolt+++++++"] = { type = "Model", model = "models/props_lab/eyescanner.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "novacolt", pos = Vector(0, -1.601, 2.2), angle = Angle(66.623, 90, 0), size = Vector(0.129, 0.15, 0.17), color = Color(47, 67, 82, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["novacolt++++"] = { type = "Model", model = "models/props_combine/combine_train02a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "novacolt", pos = Vector(0.1, -0.9, -4.6), angle = Angle(0, 180, 90), size = Vector(0.019, 0.019, 0.012), color = Color(127, 145, 163, 255), surpresslightning = false, material = "models/weapons/w_irifle/w_irifle", skin = 0, bodygroup = {} },
	["novacolt++++++++"] = { type = "Model", model = "models/props_wasteland/laundry_washer001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "novacolt", pos = Vector(0, 3, -0.35), angle = Angle(90, 0, 0), size = Vector(0.009, 0.009, 0.079), color = Color(156, 180, 206, 255), surpresslightning = false, material = "models/weapons/v_smg1/texture4", skin = 0, bodygroup = {} }
}

local ghostlerp = 0
function SWEP:CalcViewModelView(vm, oldpos, oldang, pos, ang)
	if self:GetOwner():GetBarricadeGhosting() or self:GetReloadFinish() > 0 then
		ghostlerp = math.min(1, ghostlerp + FrameTime() * 0.1)
	elseif ghostlerp > 0 then
		ghostlerp = math.max(0, ghostlerp - FrameTime() * 0.9)
	end

	if ghostlerp > 0 then
		ang:RotateAroundAxis(ang:Right(), -65 * ghostlerp)
	end

	return pos, ang
end
