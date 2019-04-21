INC_CLIENT()

SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 70

SWEP.ViewModelBoneMods = {
	["ValveBiped.Grenade_body"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["base"] = { type = "Model", model = "models/healthvial.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 2.5, -7), angle = Angle(0, -90, 0), size = Vector(1, 1, 1), color = Color(135, 20, 245, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["base"] = { type = "Model", model = "models/healthvial.mdl", bone = "ValveBiped.Anim_Attachment_RH", rel = "", pos = Vector(0, 4, 0.5), angle = Angle(0, 0, -90), size = Vector(1, 1, 1), color = Color(135, 20, 245, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
