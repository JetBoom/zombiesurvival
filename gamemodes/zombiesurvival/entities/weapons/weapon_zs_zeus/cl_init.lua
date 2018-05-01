INC_CLIENT()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.VElements = {
	["bolt+"] = { type = "Model", model = "models/crossbow_bolt.mdl", bone = "ValveBiped.bolt", rel = "bolt", pos = Vector(0, 0, 0), angle = Angle(0, 0, 79.724), size = Vector(1.016, 1.062, 1.062), color = Color(0, 255, 255, 255), surpresslightning = false, material = "models/props_combine/tpballglow", skin = 1, bodygroup = {} },
	["energy_stuff+"] = { type = "Model", model = "models/props_lab/teleportring.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "BASE", pos = Vector(8.802, -2.152, 6.893), angle = Angle(127.42, -180, -88.65), size = Vector(0.075, 0.23, 0.35), color = Color(115, 155, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["electric_shit2+"] = { type = "Model", model = "models/props_lab/teleportring.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "BASE", pos = Vector(0, -0.872, 11.138), angle = Angle(0, 90, 0), size = Vector(0.072, 0.04, 0.469), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["energy_stuff"] = { type = "Model", model = "models/props_lab/teleportring.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "BASE", pos = Vector(-8.903, -2.073, 6.71), angle = Angle(127.42, 0, 89.919), size = Vector(0.075, 0.23, 0.35), color = Color(115, 155, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["BASE"] = { type = "Model", model = "models/props_debris/wood_board06a.mdl", bone = "ValveBiped.Crossbow_base", rel = "", pos = Vector(-0.073, 0.164, 7.967), angle = Angle(0, 0, 0), size = Vector(0.975, 0.093, 0.319), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/masterinterface_alert", skin = 0, bodygroup = {} },
	["element_name+"] = { type = "Sprite", sprite = "sprites/physcannon_blueglow", bone = "ValveBiped.bolt", rel = "BASE", pos = Vector(0, 2.153, -3.922), size = { x = 2.85, y = 2.85 }, color = Color(0, 255, 255, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["electric_shit2++"] = { type = "Model", model = "models/props_combine/breenlight.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "BASE", pos = Vector(0, 2.167, 3.907), angle = Angle(0, -90, 0), size = Vector(0.522, 0.672, 0.754), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["bolt"] = { type = "Model", model = "models/crossbow_bolt.mdl", bone = "ValveBiped.bolt", rel = "", pos = Vector(-0.12, -0.046, 17.42), angle = Angle(-90, 0, 0), size = Vector(1.016, 1.062, 1.062), color = Color(0, 255, 255, 255), surpresslightning = false, material = "models/props_combine/tpballglow", skin = 1, bodygroup = {} }
}

SWEP.WElements = {
	["bolt"] = { type = "Model", model = "models/crossbow_bolt.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(27.947, -2.761, -3.977), angle = Angle(0.462, -170.174, -177.191), size = Vector(1.016, 1.062, 1.062), color = Color(0, 255, 255, 255), surpresslightning = false, material = "models/props_combine/tpballglow", skin = 1, bodygroup = {} },
	["electric_shit2++"] = { type = "Model", model = "models/props_combine/breenlight.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "BASE", pos = Vector(0.035, 2.154, 2.749), angle = Angle(0, -90, 0), size = Vector(0.522, 0.672, 0.754), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["electric_shit2+"] = { type = "Model", model = "models/props_lab/teleportring.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "BASE", pos = Vector(0, -0.872, 8.756), angle = Angle(0, 90, 0), size = Vector(0.072, 0.028, 0.224), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["energy_stuff"] = { type = "Model", model = "models/props_lab/teleportring.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "BASE", pos = Vector(-9.058, -1.675, 6.152), angle = Angle(125.438, 0.897, 89.919), size = Vector(0.075, 0.23, 0.35), color = Color(115, 155, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["bolt+"] = { type = "Model", model = "models/crossbow_bolt.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "bolt", pos = Vector(0, 0, 0), angle = Angle(0, 0, 79.724), size = Vector(1.016, 1.062, 1.062), color = Color(0, 255, 255, 255), surpresslightning = false, material = "models/props_combine/tpballglow", skin = 1, bodygroup = {} },
	["element_name+"] = { type = "Sprite", sprite = "sprites/physcannon_blueglow", bone = "ValveBiped.Bip01_R_Hand", rel = "BASE", pos = Vector(0, 2.153, -3.922), size = { x = 2.85, y = 2.85 }, color = Color(0, 255, 255, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["energy_stuff+"] = { type = "Model", model = "models/props_lab/teleportring.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "BASE", pos = Vector(9.121, -2.024, 6.177), angle = Angle(125.616, -180, -88.65), size = Vector(0.075, 0.23, 0.35), color = Color(115, 155, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["BASE"] = { type = "Model", model = "models/props_debris/wood_board06a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(13.421, -0.245, -2.487), angle = Angle(180, 99.782, 90), size = Vector(0.975, 0.093, 0.319), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/masterinterface_alert", skin = 0, bodygroup = {} }
}

SWEP.ViewModelBoneMods = {
	["ValveBiped.bowr1"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.pull"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.bowr2"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.bowl1"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.bowl2"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.HUD3DBone = "ValveBiped.Crossbow_base"
SWEP.HUD3DPos = Vector(1.5, 0.5, 11)
SWEP.HUD3DScale = 0.025

SWEP.ViewModelFOV = 65
SWEP.ViewModelFlip = false

SWEP.Slot = 3
SWEP.SlotPos = 0

function SWEP:GetViewModelPosition(pos, ang)
	if GAMEMODE.DisableScopes then return end

	if self:IsScoped() then
		return pos + ang:Up() * 256, ang
	end

	return BaseClass.GetViewModelPosition(self, pos, ang)
end


function SWEP:DrawHUDBackground()
	if GAMEMODE.DisableScopes then return end
	if not self:IsScoped() then return end

	self:DrawFuturisticScope()
end

local matBeam = Material("trails/electric")
function SWEP:PostDrawViewModel(vm, pl, wep)
	if self:IsScoped() then return end

	if self.HUD3DPos and GAMEMODE:ShouldDraw3DWeaponHUD() then
		local pos, ang = self:GetHUD3DPos(vm)
		if pos then
			self:Draw3DHUD(vm, pos, ang)
		end
	end

	local veles = self.VElements
	local col1, col2 = Color(0, 0, 0, 0), Color(0, 155, 255, 255)
	veles["bolt"].color = col1
	veles["bolt+"].color = col1

	if self:Clip1() < 1 or self:GetNextPrimaryFire() > CurTime() then return end

	veles["bolt"].color = col2
	veles["bolt+"].color = col2

	local attachposlocal = vm:WorldToLocal(vm:GetAttachment(1).Pos)
	local attachpos = vm:LocalToWorld(attachposlocal + Vector(6, 1, 0)) + VectorRand() * 2

	local offvec = Vector(40, 9, -13)
	local vecrand = VectorRand() * 0.4
	local part = veles.energy_stuff
	local partonepos = vm:LocalToWorld(part.pos + offvec) + vecrand

	offvec.y = -20
	local parttwopos = vm:LocalToWorld(part.pos + offvec) + vecrand

	render.SetMaterial(matBeam)
	render.DrawBeam(attachpos, partonepos, 1, math.random(2, 3), 1 + math.random(5, 8), Color(110, 255, 195))
	render.DrawBeam(attachpos, parttwopos, 1, math.random(2, 3), 1 + math.random(5, 8), Color(110, 255, 195))
end
