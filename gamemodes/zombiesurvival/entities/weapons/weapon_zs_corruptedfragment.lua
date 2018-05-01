AddCSLuaFile()

SWEP.PrintName = "Corrupted Fragment"
SWEP.Description = "An eerie stone which returns you to corrupted Sanity Sigils."

SWEP.Base = "weapon_zs_sigilfragment"

if CLIENT then
	SWEP.VElements = {
		["main"] = { type = "Model", model = "", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1, 5, 1), angle = Angle(-61.949, 87.662, 127.402), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base+++"] = { type = "Sprite", sprite = "sprites/light_glow02", bone = "ValveBiped.Bip01_R_Hand", rel = "1+++", pos = Vector(0, 0, 0), size = { x = 2, y = 2 }, color = Color(123, 255, 104, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = true},
		["1++"] = { type = "Model", model = "models/props_junk/rock001a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "main", pos = Vector(-1.558, -1.558, 0.2), angle = Angle(75.973, -43.248, -24.546), size = Vector(0.05, 0.05, 0.05), color = Color(72, 200, 64, 255), surpresslightning = true, material = "models/shiny", skin = 0, bodygroup = {} },
		["base++"] = { type = "Sprite", sprite = "sprites/light_glow02", bone = "ValveBiped.Bip01_R_Hand", rel = "1++", pos = Vector(0, 0, 0), size = { x = 2, y = 2 }, color = Color(123, 255, 104, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = true},
		["base+"] = { type = "Sprite", sprite = "sprites/light_glow02", bone = "ValveBiped.Bip01_R_Hand", rel = "1+", pos = Vector(0, 0, 0), size = { x = 2, y = 2 }, color = Color(123, 255, 104, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = true},
		["1+++"] = { type = "Model", model = "models/props_junk/rock001a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "main", pos = Vector(0.518, 1, 1.557), angle = Angle(75.973, -43.248, -24.546), size = Vector(0.05, 0.05, 0.05), color = Color(72, 200, 64, 255), surpresslightning = true, material = "models/shiny", skin = 0, bodygroup = {} },
		["base"] = { type = "Sprite", sprite = "sprites/light_glow02", bone = "ValveBiped.Bip01_R_Hand", rel = "main", pos = Vector(0, 0, 0), size = { x = 10, y = 10 }, color = Color(123, 255, 104, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = true},
		["1+"] = { type = "Model", model = "models/props_junk/rock001a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "main", pos = Vector(1.557, 0, 0.2), angle = Angle(0, 99.35, 52.597), size = Vector(0.05, 0.05, 0.05), color = Color(72, 200, 64, 255), surpresslightning = true, material = "models/shiny", skin = 0, bodygroup = {} },
		["1"] = { type = "Model", model = "models/props_wasteland/medbridge_post01.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "main", pos = Vector(0, 0, -1.5), angle = Angle(0, 0, 0), size = Vector(0.029, 0.029, 0.029), color = Color(166, 255, 100, 255), surpresslightning = true, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["main"] = { type = "Model", model = "", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2, 5, -0.5), angle = Angle(-17.532, 45.583, 127.402), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base+++"] = { type = "Sprite", sprite = "sprites/light_glow02", bone = "ValveBiped.Bip01_R_Hand", rel = "1+++", pos = Vector(0, 0, 0), size = { x = 2, y = 2 }, color = Color(123, 255, 104, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
		["1++"] = { type = "Model", model = "models/props_junk/rock001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "main", pos = Vector(-1.558, -1.558, 0.2), angle = Angle(75.973, -43.248, -24.546), size = Vector(0.05, 0.05, 0.05), color = Color(72, 200, 64, 255), surpresslightning = true, material = "models/shiny", skin = 0, bodygroup = {} },
		["base++"] = { type = "Sprite", sprite = "sprites/light_glow02", bone = "ValveBiped.Bip01_R_Hand", rel = "1++", pos = Vector(0, 0, 0), size = { x = 2, y = 2 }, color = Color(123, 255, 104, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
		["base+"] = { type = "Sprite", sprite = "sprites/light_glow02", bone = "ValveBiped.Bip01_R_Hand", rel = "1+", pos = Vector(0, 0, 0), size = { x = 2, y = 2 }, color = Color(123, 255, 104, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
		["1+++"] = { type = "Model", model = "models/props_junk/rock001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "main", pos = Vector(0.518, 1, 1.557), angle = Angle(75.973, -43.248, -24.546), size = Vector(0.05, 0.05, 0.05), color = Color(72, 200, 64, 255), surpresslightning = true, material = "models/shiny", skin = 0, bodygroup = {} },
		["1"] = { type = "Model", model = "models/props_wasteland/medbridge_post01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "main", pos = Vector(0, 0, -1.5), angle = Angle(0, 0, 0), size = Vector(0.029, 0.029, 0.029), color = Color(166, 255, 100, 255), surpresslightning = true, material = "", skin = 0, bodygroup = {} },
		["base"] = { type = "Sprite", sprite = "sprites/light_glow02", bone = "ValveBiped.Bip01_R_Hand", rel = "main", pos = Vector(0, 0, 0), size = { x = 10, y = 10 }, color = Color(123, 255, 104, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
		["1+"] = { type = "Model", model = "models/props_junk/rock001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "main", pos = Vector(1.557, 0, 0.2), angle = Angle(0, 99.35, 52.597), size = Vector(0.05, 0.05, 0.05), color = Color(72, 200, 64, 255), surpresslightning = true, material = "models/shiny", skin = 0, bodygroup = {} }
	}
end

SWEP.Primary.Ammo = "corruptedfragment"

SWEP.TeleportStatus = "corruptedteleport"
SWEP.TeleportEffect = "corrupted_teleport"

function SWEP:CanPrimaryAttack()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() or GAMEMODE:NumCorruptedSigils() <= 0 then return false end

	if self:GetPrimaryAmmoCount() <= 0 then
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		return false
	end

	return true
end

if CLIENT then
function SWEP:DrawWorldModel()
	local time = UnPredictedCurTime() * 45
	local vang = self.WElements.main.angle
	vang.p = time % 360
	vang.y = vang.p

	self.BaseClass.BaseClass.DrawWorldModel(self)
end
SWEP.DrawWorldModelTranslucent = SWEP.DrawWorldModel
end
