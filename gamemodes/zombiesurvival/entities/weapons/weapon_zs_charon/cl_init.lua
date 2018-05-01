INC_CLIENT()

SWEP.VElements = {
	["underbarrel_sides"] = { type = "Model", model = "models/mechanics/solid_steel/type_b_2_2.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "underbarrel", pos = Vector(-2.26, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.514, 0.293, 0.312), color = Color(200, 200, 200, 255), surpresslightning = false, material = "phoenix_storms/officewindow_1-1", skin = 0, bodygroup = {} },
	["underbarrel_stripes"] = { type = "Model", model = "models/Mechanics/gears/gear24x6.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "underbarrel", pos = Vector(4.05, 0, 0), angle = Angle(90, 0, 0), size = Vector(0.063, 0.063, 2.016), color = Color(175, 175, 175, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["FRONT"] = { type = "Model", model = "models/props_combine/combine_smallmonitor001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "side", pos = Vector(0, -9.323, 1.125), angle = Angle(90, 90, 180), size = Vector(0.252, 0.358, 0.127), color = Color(200, 200, 200, 255), surpresslightning = false, material = "phoenix_storms/officewindow_1-1", skin = 0, bodygroup = {} },
	["FINS+"] = { type = "Model", model = "models/props_c17/playground_swingset_seat01a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "underbarrel", pos = Vector(1.534, -3.013, 10.057), angle = Angle(-125.673, -180, 2.9), size = Vector(0.425, 0.256, 0.601), color = Color(200, 200, 200, 255), surpresslightning = false, material = "phoenix_storms/torpedo", skin = 0, bodygroup = {} },
	["FINS"] = { type = "Model", model = "models/props_c17/playground_swingset_seat01a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "underbarrel", pos = Vector(1.848, -3.013, -10.058), angle = Angle(56.659, 0, 0), size = Vector(0.425, 0.256, 0.601), color = Color(200, 200, 200, 255), surpresslightning = false, material = "phoenix_storms/torpedo", skin = 0, bodygroup = {} },
	["underbarrel"] = { type = "Model", model = "models/XQM/panel360.mdl", bone = "ValveBiped.Crossbow_base", rel = "", pos = Vector(0, 2.382, 15.612), angle = Angle(90, 0, 0), size = Vector(9.519, 0.065, 0.065), color = Color(0, 0, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["back"] = { type = "Model", model = "models/weapons/w_shot_m3super90.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "side", pos = Vector(0.086, 7.222, -1.844), angle = Angle(0, 90, 0), size = Vector(0.5, 0.845, 0.513), color = Color(200, 200, 200, 255), surpresslightning = false, material = "phoenix_storms/officewindow_1-1", skin = 0, bodygroup = {} },
	["side"] = { type = "Model", model = "models/props_trainstation/trainstation_arch001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "underbarrel", pos = Vector(-6.483, -0.226, 0), angle = Angle(90, -90, 0), size = Vector(3.45, 0.178, 0.043), color = Color(200, 200, 200, 255), surpresslightning = false, material = "phoenix_storms/officewindow_1-1", skin = 0, bodygroup = {} },
	["overlay"] = { type = "Model", model = "models/props_junk/harpoon002a.mdl", bone = "ValveBiped.bolt", rel = "", pos = Vector(-0.13, 0, 11.22), angle = Angle(90, 0, 180), size = Vector(0.303, 0.555, 0.555), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/officewindow_1-1", skin = 0, bodygroup = {} },
	["stuff"] = { type = "Model", model = "models/props_c17/grinderclamp01a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "underbarrel", pos = Vector(-17.656, -4.215, 0.122), angle = Angle(90, 90, 90), size = Vector(0.245, 0.221, 0.314), color = Color(200, 200, 200, 255), surpresslightning = false, material = "phoenix_storms/officewindow_1-1", skin = 0, bodygroup = {} }
}
SWEP.WElements = {
	["underbarrel_sides"] = { type = "Model", model = "models/mechanics/solid_steel/type_b_2_2.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "underbarrel", pos = Vector(-2.26, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.514, 0.293, 0.312), color = Color(200, 200, 200, 255), surpresslightning = false, material = "phoenix_storms/officewindow_1-1", skin = 0, bodygroup = {} },
	["underbarrel_stripes"] = { type = "Model", model = "models/Mechanics/gears/gear24x6.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "underbarrel", pos = Vector(4.05, 0, 0), angle = Angle(90, 0, 0), size = Vector(0.063, 0.063, 2.016), color = Color(175, 175, 175, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["FRONT"] = { type = "Model", model = "models/props_combine/combine_smallmonitor001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "side", pos = Vector(0, -9.323, 1.125), angle = Angle(90, 90, 180), size = Vector(0.252, 0.358, 0.112), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/officewindow_1-1", skin = 0, bodygroup = {} },
	["FINS+"] = { type = "Model", model = "models/props_c17/playground_swingset_seat01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "underbarrel", pos = Vector(1.534, -3.013, 10.057), angle = Angle(-125.673, -180, 2.9), size = Vector(0.425, 0.256, 0.601), color = Color(200, 200, 200, 255), surpresslightning = false, material = "phoenix_storms/torpedo", skin = 0, bodygroup = {} },
	["FINS"] = { type = "Model", model = "models/props_c17/playground_swingset_seat01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "underbarrel", pos = Vector(1.848, -3.013, -10.058), angle = Angle(56.659, 0, 0), size = Vector(0.425, 0.256, 0.601), color = Color(200, 200, 200, 255), surpresslightning = false, material = "phoenix_storms/torpedo", skin = 0, bodygroup = {} },
	["underbarrel"] = { type = "Model", model = "models/XQM/panel360.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(19.784, -1.318, -0.436), angle = Angle(0, 10.428, -90), size = Vector(9.519, 0.065, 0.065), color = Color(0, 0, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["back"] = { type = "Model", model = "models/weapons/w_shot_m3super90.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "side", pos = Vector(0.086, 7.221, -3.266), angle = Angle(0, 90, 0), size = Vector(0.5, 0.811, 0.708), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/officewindow_1-1", skin = 0, bodygroup = {} },
	["overlay"] = { type = "Model", model = "models/props_junk/harpoon002a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "underbarrel", pos = Vector(0, -3.143, 0), angle = Angle(0, 0, 180), size = Vector(0.303, 0.555, 0.555), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/officewindow_1-1", skin = 0, bodygroup = {} },
	["side"] = { type = "Model", model = "models/props_trainstation/trainstation_arch001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "underbarrel", pos = Vector(-6.483, -0.226, 0), angle = Angle(90, -90, 0), size = Vector(3.45, 0.178, 0.043), color = Color(200, 200, 200, 255), surpresslightning = false, material = "phoenix_storms/officewindow_1-1", skin = 0, bodygroup = {} },
	["stuff"] = { type = "Model", model = "models/props_c17/grinderclamp01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "underbarrel", pos = Vector(-17.656, -4.215, 0.122), angle = Angle(90, 90, 90), size = Vector(0.245, 0.221, 0.314), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/officewindow_1-1", skin = 0, bodygroup = {} }
}



SWEP.HUD3DBone = "ValveBiped.Crossbow_base"
SWEP.HUD3DPos = Vector(1.5, 0.5, 11)
SWEP.HUD3DScale = 0.025

SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false

SWEP.Slot = 3
SWEP.SlotPos = 0

function SWEP:PostDrawViewModel(vm, pl, wep)
	if self.HUD3DPos and GAMEMODE:ShouldDraw3DWeaponHUD() then
		local pos, ang = self:GetHUD3DPos(vm)
		if pos then
			self:Draw3DHUD(vm, pos, ang)
		end
	end

	local adj = math.min(1, (CurTime() - self:GetShootTime()) * 3)
	self.VElements["overlay"].size = Vector(0.303, 0.555, 0.555) * adj
end

local ghostlerp = 0
function SWEP:CalcViewModelView(vm, oldpos, oldang, pos, ang)
	if self:GetOwner():GetBarricadeGhosting() or self:GetReloadFinish() > 0 then
		ghostlerp = math.min(1, ghostlerp + FrameTime() * 1)
	elseif ghostlerp > 0 then
		ghostlerp = math.max(0, ghostlerp - FrameTime() * 1.3)
	end

	if ghostlerp > 0 then
		ang:RotateAroundAxis(ang:Right(), -18 * ghostlerp)
	end

	return pos, ang
end
