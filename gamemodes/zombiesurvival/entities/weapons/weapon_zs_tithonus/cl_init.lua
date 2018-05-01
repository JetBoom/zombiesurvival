INC_CLIENT()

SWEP.Slot = 3
SWEP.SlotPos = 0

SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 60

SWEP.HUD3DBone = "ValveBiped.Gun"
SWEP.HUD3DPos = Vector(2.12, -1, -8)
SWEP.HUD3DScale = 0.025

SWEP.VElements = {
	["tithonus_parts+++"] = { type = "Model", model = "models/props_combine/combine_train02b.mdl", bone = "ValveBiped.Gun", rel = "tithonus_parts", pos = Vector(-4, 0, -10), angle = Angle(0, -90, 90), size = Vector(0.029, 0.039, 0.039), color = Color(59, 92, 161, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["tithonus_parts+"] = { type = "Model", model = "models/props_combine/combine_emitter01.mdl", bone = "ValveBiped.Gun", rel = "tithonus_parts", pos = Vector(-5, 0, -10.91), angle = Angle(-90, 0, 0), size = Vector(0.8, 0.2, 0.367), color = Color(67, 94, 127, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["tithonus_parts"] = { type = "Model", model = "models/props_combine/combine_dispenser.mdl", bone = "ValveBiped.Gun", rel = "", pos = Vector(0, 0, -2.799), angle = Angle(0, 90, 180), size = Vector(0.15, 0.14, 0.3), color = Color(36, 85, 123, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["tithonus_parts++"] = { type = "Model", model = "models/props_combine/combine_lock01.mdl", bone = "ValveBiped.Gun", rel = "tithonus_parts", pos = Vector(-1, -1, -8.832), angle = Angle(-180, 0, 0), size = Vector(0.4, 0.219, 1.014), color = Color(72, 87, 130, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["tithonus_parts++"] = { type = "Model", model = "models/props_combine/combine_lock01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "tithonus_parts", pos = Vector(-1, -1, -8.832), angle = Angle(-180, 0, 0), size = Vector(0.4, 0.219, 1.014), color = Color(72, 87, 130, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["tithonus_parts+"] = { type = "Model", model = "models/props_combine/combine_emitter01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "tithonus_parts", pos = Vector(-5, 0, -10.91), angle = Angle(-90, 0, 0), size = Vector(0.8, 0.2, 0.367), color = Color(67, 94, 127, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["tithonus_parts"] = { type = "Model", model = "models/props_combine/combine_dispenser.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.5, 1, -6.753), angle = Angle(-92.338, 180, 0), size = Vector(0.15, 0.14, 0.3), color = Color(36, 85, 123, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["tithonus_parts+++"] = { type = "Model", model = "models/props_combine/combine_train02b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "tithonus_parts", pos = Vector(-4, 0, -10), angle = Angle(0, -90, 90), size = Vector(0.029, 0.039, 0.039), color = Color(59, 92, 161, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

function SWEP:Think()
	if self:GetReloadFinish() > 0 then
		if CurTime() >= self:GetReloadFinish() then
			self:FinishReload()
		end

		return
	end

	self:CheckCharge()
end
