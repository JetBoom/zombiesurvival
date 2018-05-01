INC_CLIENT()

SWEP.Slot = 3
SWEP.SlotPos = 0

SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 68

SWEP.HUD3DBone = "ValveBiped.Gun"
SWEP.HUD3DPos = Vector(-1, -2, -6.15)
SWEP.HUD3DScale = 0.03

SWEP.LastVel = 0

SWEP.VElements = {
	["spinners"] = { type = "Model", model = "models/props_lab/rotato.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "backwheel", pos = Vector(-0.791, -1.3, 2.95), angle = Angle(180, 0, -90), size = Vector(0.349, 1.25, 0.349), color = Color(115, 60, 0, 255), surpresslightning = false, material = "phoenix_storms/simplymetallic2", skin = 0, bodygroup = {} },
	["backwheel"] = { type = "Model", model = "models/mechanics/wheels/wheel_speed_72.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "back2", pos = Vector(-0.371, 0, 2.788), angle = Angle(90, -90, 90), size = Vector(0.05, 0.05, 0.05), color = Color(100, 100, 100, 0), surpresslightning = false, material = "models/props_c17/metalladder001", skin = 0, bodygroup = {} },
	["back3"] = { type = "Model", model = "models/props_combine/headcrabcannister01a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "Front", pos = Vector(-17.06, 0, 0.769), angle = Angle(180, 0, 0), size = Vector(0.035, 0.059, 0.07), color = Color(100, 100, 100, 255), surpresslightning = false, material = "models/props_c17/metalladder001", skin = 0, bodygroup = {} },
	["frontrail"] = { type = "Model", model = "models/props_lab/pipesystem02e.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "Front", pos = Vector(1.121, 0.381, -2.737), angle = Angle(-60, 90, -90), size = Vector(0.272, 0.189, 0.419), color = Color(200, 115, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["back"] = { type = "Model", model = "models/props_c17/lamp_standard_off01.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "Front", pos = Vector(-6.378, 0, -0.244), angle = Angle(90, 0, 0), size = Vector(0.243, 0.243, 0.155), color = Color(100, 100, 100, 255), surpresslightning = false, material = "models/props_c17/metalladder001", skin = 0, bodygroup = {} },
	["spinners+"] = { type = "Model", model = "models/props_lab/rotato.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "backwheel", pos = Vector(1.44, 0, 2.95), angle = Angle(180, 0, -90), size = Vector(0.349, 1.25, 0.349), color = Color(115, 60, 0, 255), surpresslightning = false, material = "phoenix_storms/simplymetallic2", skin = 0, bodygroup = {} },
	["Front2"] = { type = "Model", model = "models/XQM/deg180single.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "Front", pos = Vector(-1.657, 0, 2.569), angle = Angle(0, 0, 0), size = Vector(0.229, 0.09, 0.109), color = Color(100, 100, 100, 255), surpresslightning = false, material = "models/props_c17/metalladder001", skin = 0, bodygroup = {} },
	["frontrail+"] = { type = "Model", model = "models/props_lab/pipesystem02e.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "Front", pos = Vector(1.121, -0.415, -2.737), angle = Angle(60, 90, -90), size = Vector(0.272, 0.189, 0.419), color = Color(200, 115, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Front5"] = { type = "Model", model = "models/props_phx/trains/double_wheels_base.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "Front", pos = Vector(-4.953, 0, -2.777), angle = Angle(180, 0, 0), size = Vector(0.026, 0.027, 0.016), color = Color(100, 100, 100, 255), surpresslightning = false, material = "models/props_c17/metalladder001", skin = 0, bodygroup = {} },
	["backwheel_appearence"] = { type = "Model", model = "models/props_c17/playgroundTick-tack-toe_block01a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "backwheel", pos = Vector(0.4, 0, 0), angle = Angle(0, 90, -90), size = Vector(0.2, 0.043, 0.2), color = Color(115, 115, 115, 255), surpresslightning = false, material = "models/props_c17/metalladder001", skin = 0, bodygroup = {} },
	["FRONT3_metal"] = { type = "Model", model = "models/mechanics/solid_steel/type_b_2_2.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "Front3", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.159, 0.239, 0.239), color = Color(100, 100, 100, 255), surpresslightning = false, material = "models/props_c17/metalladder001", skin = 0, bodygroup = {} },
	["spinners++"] = { type = "Model", model = "models/props_lab/rotato.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "backwheel", pos = Vector(-0.791, 1.299, 2.95), angle = Angle(180, 0, -90), size = Vector(0.349, 1.25, 0.349), color = Color(115, 60, 0, 255), surpresslightning = false, material = "phoenix_storms/simplymetallic2", skin = 0, bodygroup = {} },
	["Front3"] = { type = "Model", model = "models/XQM/cylinderx1big.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "Front", pos = Vector(-4.345, 0, -0.051), angle = Angle(0, 0, 0), size = Vector(0.123, 0.079, 0.079), color = Color(100, 50, 0, 255), surpresslightning = false, material = "phoenix_storms/wood_dome", skin = 0, bodygroup = {} },
	["frontrail+++"] = { type = "Model", model = "models/props_lab/pipesystem02e.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "Front", pos = Vector(3.124, 0.381, 1.192), angle = Angle(-122, 90, -90), size = Vector(0.272, 0.189, 0.419), color = Color(200, 115, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Front4"] = { type = "Model", model = "models/hunter/triangles/05x05x05.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "Front", pos = Vector(-3.924, 0, -2.901), angle = Angle(180, -90, 0), size = Vector(0.115, 0.231, 0.039), color = Color(100, 100, 100, 255), surpresslightning = false, material = "models/props_c17/metalladder001", skin = 0, bodygroup = {} },
	["BACK_detail"] = { type = "Model", model = "models/XQM/cylinderx1.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "back2", pos = Vector(-2.36, 0, -0.25), angle = Angle(0, 0, 0), size = Vector(0.246, 0.28, 0.119), color = Color(100, 100, 100, 255), surpresslightning = false, material = "models/props_c17/metalladder001", skin = 0, bodygroup = {} },
	["Front"] = { type = "Model", model = "models/props_combine/headcrabcannister01a.mdl", bone = "ValveBiped.Gun", rel = "", pos = Vector(-0.849, 1.128, 1.047), angle = Angle(90, 0, 90), size = Vector(0.035, 0.134, 0.119), color = Color(100, 100, 100, 255), surpresslightning = false, material = "models/props_c17/metalladder001", skin = 0, bodygroup = {} },
	["back2"] = { type = "Model", model = "models/mechanics/articulating/arm_base_b.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "Front", pos = Vector(-15.551, 0, -2.181), angle = Angle(180, 0, 180), size = Vector(0.219, 0.104, 0.125), color = Color(100, 100, 100, 255), surpresslightning = false, material = "models/props_c17/metalladder001", skin = 0, bodygroup = {} },
	["frontrail++"] = { type = "Model", model = "models/props_lab/pipesystem02e.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "Front", pos = Vector(3.124, -0.415, 1.192), angle = Angle(122, 90, -90), size = Vector(0.272, 0.189, 0.419), color = Color(200, 115, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["front2_metaledges"] = { type = "Model", model = "models/mechanics/solid_steel/type_b_2_2.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "FRONT2+", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.159, 0.239, 0.239), color = Color(100, 100, 100, 255), surpresslightning = false, material = "models/props_c17/metalladder001", skin = 0, bodygroup = {} },
	["FRONT3"] = { type = "Model", model = "models/hunter/triangles/05x05x05.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "FRONT", pos = Vector(-3.924, 0, -2.901), angle = Angle(180, -90, 0), size = Vector(0.115, 0.231, 0.039), color = Color(100, 100, 100, 255), surpresslightning = false, material = "models/props_c17/metalladder001", skin = 0, bodygroup = {} },
	["chamber1"] = { type = "Model", model = "models/props_lab/rotato.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "backwheelturner", pos = Vector(-0.791, -1.3, 2.95), angle = Angle(180, 0, -90), size = Vector(0.349, 1.25, 0.349), color = Color(115, 60, 0, 255), surpresslightning = false, material = "phoenix_storms/simplymetallic2", skin = 0, bodygroup = {} },
	["FRONT2+"] = { type = "Model", model = "models/XQM/cylinderx1big.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "FRONT", pos = Vector(-4.345, 0, -0.051), angle = Angle(0, 0, 0), size = Vector(0.123, 0.079, 0.079), color = Color(100, 50, 0, 255), surpresslightning = false, material = "phoenix_storms/wood_dome", skin = 0, bodygroup = {} },
	["FRONT2"] = { type = "Model", model = "models/XQM/deg180single.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "FRONT", pos = Vector(-1.657, 0, 2.569), angle = Angle(0, 0, 0), size = Vector(0.229, 0.09, 0.109), color = Color(100, 100, 100, 255), surpresslightning = false, material = "models/props_c17/metalladder001", skin = 0, bodygroup = {} },
	["railing1+"] = { type = "Model", model = "models/props_lab/pipesystem02e.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "FRONT", pos = Vector(1.121, 0.381, -2.737), angle = Angle(-60, 90, -90), size = Vector(0.272, 0.189, 0.419), color = Color(200, 115, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["railing1+++"] = { type = "Model", model = "models/props_lab/pipesystem02e.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "FRONT", pos = Vector(3.124, -0.415, 1.192), angle = Angle(122, 90, -90), size = Vector(0.272, 0.189, 0.419), color = Color(200, 115, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["chamber1++"] = { type = "Model", model = "models/props_lab/rotato.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "backwheelturner", pos = Vector(-0.791, 1.299, 2.95), angle = Angle(180, 0, -90), size = Vector(0.349, 1.25, 0.349), color = Color(115, 60, 0, 255), surpresslightning = false, material = "phoenix_storms/simplymetallic2", skin = 0, bodygroup = {} },
	["chamber1+"] = { type = "Model", model = "models/props_lab/rotato.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "backwheelturner", pos = Vector(1.44, 0, 2.95), angle = Angle(180, 0, -90), size = Vector(0.349, 1.25, 0.349), color = Color(115, 60, 0, 255), surpresslightning = false, material = "phoenix_storms/simplymetallic2", skin = 0, bodygroup = {} },
	["backtopdetail"] = { type = "Model", model = "models/XQM/cylinderx1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "back2", pos = Vector(-2.36, 0, -0.25), angle = Angle(0, 0, 0), size = Vector(0.246, 0.28, 0.119), color = Color(100, 100, 100, 255), surpresslightning = false, material = "models/props_c17/metalladder001", skin = 0, bodygroup = {} },
	["backwheelturner"] = { type = "Model", model = "models/mechanics/wheels/wheel_speed_72.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "back2", pos = Vector(-0.371, 0, 2.788), angle = Angle(90, -90, 90), size = Vector(0.05, 0.05, 0.05), color = Color(100, 100, 100, 0), surpresslightning = false, material = "models/props_c17/metalladder001", skin = 0, bodygroup = {} },
	["back"] = { type = "Model", model = "models/props_c17/lamp_standard_off01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "FRONT", pos = Vector(-6.378, 0, -0.232), angle = Angle(90, 0, 0), size = Vector(0.243, 0.243, 0.155), color = Color(100, 100, 100, 255), surpresslightning = false, material = "models/props_c17/metalladder001", skin = 0, bodygroup = {} },
	["BACKturner_appearence"] = { type = "Model", model = "models/props_c17/playgroundTick-tack-toe_block01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "backwheelturner", pos = Vector(0.4, 0, 0.079), angle = Angle(0, 90, -90), size = Vector(0.2, 0.043, 0.2), color = Color(115, 115, 115, 255), surpresslightning = false, material = "models/props_c17/metalladder001", skin = 0, bodygroup = {} },
	["railing1++++"] = { type = "Model", model = "models/props_lab/pipesystem02e.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "FRONT", pos = Vector(3.124, 0.381, 1.192), angle = Angle(-122, 90, -90), size = Vector(0.272, 0.189, 0.419), color = Color(200, 115, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["railing1++"] = { type = "Model", model = "models/props_lab/pipesystem02e.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "FRONT", pos = Vector(1.121, -0.415, -2.737), angle = Angle(60, 90, -90), size = Vector(0.272, 0.189, 0.419), color = Color(200, 115, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["topfront"] = { type = "Model", model = "models/props_phx/trains/double_wheels_base.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "FRONT", pos = Vector(-4.953, 0, -2.777), angle = Angle(180, 0, 0), size = Vector(0.026, 0.027, 0.016), color = Color(100, 100, 100, 255), surpresslightning = false, material = "models/props_c17/metalladder001", skin = 0, bodygroup = {} },
	["BACK3"] = { type = "Model", model = "models/props_combine/headcrabcannister01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "FRONT", pos = Vector(-17.06, 0, 0.769), angle = Angle(180, 0, 0), size = Vector(0.035, 0.059, 0.07), color = Color(100, 100, 100, 255), surpresslightning = false, material = "models/props_c17/metalladder001", skin = 0, bodygroup = {} },
	["back2"] = { type = "Model", model = "models/mechanics/articulating/arm_base_b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "FRONT", pos = Vector(-15.551, 0, -2.181), angle = Angle(180, 0, 180), size = Vector(0.219, 0.104, 0.125), color = Color(100, 100, 100, 255), surpresslightning = false, material = "models/props_c17/metalladder001", skin = 0, bodygroup = {} },
	["FRONT"] = { type = "Model", model = "models/props_combine/headcrabcannister01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(20.058, 2.303, -6.487), angle = Angle(-13.343, -3.133, 0), size = Vector(0.035, 0.134, 0.119), color = Color(100, 100, 100, 255), surpresslightning = false, material = "models/props_c17/metalladder001", skin = 0, bodygroup = {} }
}

function SWEP:Think()
	self:CheckCharge()
end
--[[
function SWEP:GetTracerOrigin()
	local owner = self:GetOwner()
	local vm = owner:GetViewModel()

	if not (vm and vm:IsValid()) or owner:ShouldDrawLocalPlayer() then
		local shootpos = owner:GetShootPos()
		shootpos.z = shootpos.z - 20
		shootpos = shootpos + owner:GetAimVector() * 30

		return shootpos
	end

	local attach
	attach = vm:GetAttachment(vm:LookupAttachment("muzzle"))

	local muzzlepos, muzzleang = attach.Pos, attach.Ang
	muzzlepos = muzzlepos + muzzleang:Forward() * -2 + muzzleang:Right() * 8 + muzzleang:Up() * 9

	return muzzlepos
end]]

local colBG = Color(16, 16, 16, 90)
local colRed = Color(220, 0, 0, 230)
local colWhite = Color(220, 220, 220, 230)

function SWEP:Draw2DHUD()
	local screenscale = BetterScreenScale()

	local wid, hei = 180 * screenscale, 64 * screenscale
	local x, y = ScrW() - wid - screenscale * 128, ScrH() - hei - screenscale * 72
	local spare = self:GetPrimaryAmmoCount()

	draw.RoundedBox(16, x, y, wid, hei, colBG)
	draw.SimpleTextBlurry(spare, spare >= 1000 and "ZSHUDFont" or "ZSHUDFontBig", x + wid * 0.5, y + hei * 0.5, spare == 0 and colRed or colWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	local rotators = self.VElements["backwheel"].angle
	local vel = Lerp(0.03, self.LastVel, self:GetGunCharge() * FrameTime() * 130)
	rotators.p = rotators.p + vel

	self.LastVel = vel
end

function SWEP:Draw3DHUD(vm, pos, ang)
	local wid, hei = 180, 64
	local x, y = wid * -0.6, hei * -0.5
	local spare = self:GetPrimaryAmmoCount()

	cam.Start3D2D(pos, ang, self.HUD3DScale / 2)
		draw.RoundedBoxEx(32, x, y, wid, hei, colBG, true, false, true, false)
		draw.SimpleTextBlurry(spare, spare >= 1000 and "ZS3D2DFontSmall" or "ZS3D2DFont", x + wid * 0.5, y + hei * 0.5, spare == 0 and colRed or colWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()
end
