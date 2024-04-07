INC_CLIENT()

SWEP.HUD3DBone = "v_weapon.M3_PARENT"
SWEP.HUD3DPos = Vector(-0.5, -4.2, -0)
SWEP.HUD3DAng = Angle(0, 0, -20)
SWEP.HUD3DScale = 0.015

SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false

SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false

SWEP.Slot = 3
SWEP.SlotPos = 0

SWEP.VElements = {
	["edgeleft++"] = { type = "Model", model = "models/props_lab/monitor01b.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(2.305, -17.574, 0), angle = Angle(180, 0, 0), size = Vector(0.351, 0.556, 0.435), color = Color(100, 75, 0, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
	["1"] = { type = "Model", model = "models/props_vehicles/carparts_tire01a.mdl", bone = "v_weapon.M3_PARENT", rel = "", pos = Vector(0.039, -0.797, -15.662), angle = Angle(180, 0, -90), size = Vector(0.174, 0.847, 0.174), color = Color(100, 75, 0, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
	["1+"] = { type = "Model", model = "models/props_vehicles/carparts_tire01a.mdl", bone = "v_weapon.M3_PARENT", rel = "1", pos = Vector(0, -17.782, 0), angle = Angle(0, 0, 0), size = Vector(0.174, 0.838, 0.174), color = Color(100, 75, 0, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
	["pipe"] = { type = "Model", model = "models/props_pipes/valve002.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(3.494, -14.778, 0.214), angle = Angle(90, 90, 0), size = Vector(0.118, 0.118, 0.208), color = Color(125, 125, 115, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
	["shellpusher"] = { type = "Model", model = "models/XQM/panel360.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, -19.056, 0), angle = Angle(0, 90, 0), size = Vector(8, 0.079, 0.079), color = Color(125, 125, 115, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
	["edgeleft+++"] = { type = "Model", model = "models/props_lab/monitor01b.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(-2.306, -17.574, 0), angle = Angle(180, 180, 0), size = Vector(0.351, 0.556, 0.435), color = Color(100, 75, 0, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
	["edgeleft+"] = { type = "Model", model = "models/props_lab/monitor01b.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(-2.306, 0, 0), angle = Angle(180, 180, 0), size = Vector(0.345, 0.556, 0.435), color = Color(100, 75, 0, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
	["SHELL"] = { type = "Model", model = "models/props_phx/misc/flakshell_big.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, -3.961, 0), angle = Angle(0, 0, 90), size = Vector(0.127, 0.127, 0.18), color = Color(245, 215, 0, 255), surpresslightning = false, material = "models/props_lab/door_klab01", skin = 0, bodygroup = {} },
	["pipe+"] = { type = "Model", model = "models/props_pipes/valve002.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(-3.495, -14.778, 0.214), angle = Angle(90, 90, 0), size = Vector(0.118, 0.118, 0.208), color = Color(125, 125, 115, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
	["black_filler"] = { type = "Model", model = "models/XQM/panel360.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, -3.412, 0), angle = Angle(0, 90, 0), size = Vector(1.694, 0.079, 0.079), color = Color(0, 0, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["edgeleft"] = { type = "Model", model = "models/props_lab/monitor01b.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(2.305, 0, 0), angle = Angle(180, 0, 0), size = Vector(0.345, 0.556, 0.435), color = Color(100, 75, 0, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["edgeleft"] = { type = "Model", model = "models/props_lab/monitor01b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(2.305, 0, 0), angle = Angle(180, 0, 0), size = Vector(0.345, 0.556, 0.435), color = Color(100, 75, 0, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
	["1"] = { type = "Model", model = "models/props_vehicles/carparts_tire01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(21.385, 1.429, -5.041), angle = Angle(180, 90, 0), size = Vector(0.174, 0.847, 0.174), color = Color(100, 75, 0, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
	["1+"] = { type = "Model", model = "models/props_vehicles/carparts_tire01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, -14.903, 0), angle = Angle(0, 0, 0), size = Vector(0.174, 0.838, 0.174), color = Color(100, 75, 0, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
	["clip"] = { type = "Model", model = "models/Items/combine_rifle_cartridge01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1+", pos = Vector(0, 2.381, -2.79), angle = Angle(-87.457, -90, 0), size = Vector(0.741, 1.69, 0.741), color = Color(115, 115, 115, 255), surpresslightning = false, material = "models/props_canal/metalwall005b", skin = 0, bodygroup = {} },
	["pipe"] = { type = "Model", model = "models/props_pipes/valve002.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(3.494, -12.018, 0.214), angle = Angle(90, 90, 0), size = Vector(0.118, 0.118, 0.115), color = Color(125, 125, 115, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
	["black_filler+"] = { type = "Model", model = "models/XQM/panel360.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, -16.862, 0), angle = Angle(0, 90, 0), size = Vector(6.394, 0.079, 0.079), color = Color(100, 75, 0, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
	["edgeleft++"] = { type = "Model", model = "models/props_lab/monitor01b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(2.305, -14.907, 0), angle = Angle(180, 0, 0), size = Vector(0.351, 0.556, 0.435), color = Color(100, 75, 0, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
	["edgeleft+++"] = { type = "Model", model = "models/props_lab/monitor01b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(-2.306, -14.907, 0), angle = Angle(180, 180, 0), size = Vector(0.351, 0.556, 0.435), color = Color(100, 75, 0, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
	["edgeleft+"] = { type = "Model", model = "models/props_lab/monitor01b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(-2.306, 0, 0), angle = Angle(180, 180, 0), size = Vector(0.345, 0.556, 0.435), color = Color(100, 75, 0, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
	["GRIP"] = { type = "Model", model = "models/weapons/w_pist_usp.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1+", pos = Vector(0, -2.672, -6.75), angle = Angle(0, -90, 0), size = Vector(0.575, 1, 1), color = Color(100, 75, 0, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
	["pipe+"] = { type = "Model", model = "models/props_pipes/valve002.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(-3.495, -12.018, 0.214), angle = Angle(90, 90, 0), size = Vector(0.118, 0.118, 0.115), color = Color(125, 125, 115, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
	["SHELL"] = { type = "Model", model = "models/props_phx/misc/flakshell_big.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, -3.961, 0), angle = Angle(0, 0, 90), size = Vector(0.127, 0.127, 0.18), color = Color(245, 215, 0, 255), surpresslightning = false, material = "models/props_lab/door_klab01", skin = 0, bodygroup = {} },
	["black_filler"] = { type = "Model", model = "models/XQM/panel360.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, -1.961, 0), angle = Angle(0, 90, 0), size = Vector(6.394, 0.079, 0.079), color = Color(0, 0, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} }
}

function SWEP:PostDrawViewModel(vm, pl, wep)
	if self.HUD3DPos and GAMEMODE:ShouldDraw3DWeaponHUD() then
		local pos, ang = self:GetHUD3DPos(vm)
		if pos then
			self:Draw3DHUD(vm, pos, ang)
		end
	end

	local lol = self:Clip1() == 0 and 0 or (CurTime() - self:GetLastFired())^3.5
	local shelllol = math.Clamp(lol, 0, 1) * 20

	local shellpos = self.VElements["SHELL"].pos
	shellpos.y = -24 + shelllol
end

local ghostlerp = 0
function SWEP:CalcViewModelView(vm, oldpos, oldang, pos, ang)
	if self:GetOwner():GetBarricadeGhosting() or self:GetReloadFinish() > 0 then
		ghostlerp = math.min(1, ghostlerp + FrameTime() * 1)
	elseif ghostlerp > 0 then
		ghostlerp = math.max(0, ghostlerp - FrameTime() * 1.5)
	end

	if ghostlerp > 0 then
		ang:RotateAroundAxis(ang:Right(), -15 * ghostlerp)
	end

	return pos, ang
end
