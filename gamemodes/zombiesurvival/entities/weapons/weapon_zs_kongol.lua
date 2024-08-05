AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "콩골의 도끼"

	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false

	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false
	SWEP.VElements = {
		["element_name"] = { type = "Model", model = "models/props/cs_militia/axe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.454, 1.356, -1.252), angle = Angle(5.965, -0.309, 87.454), size = Vector(1.041, 1.041, 1.041), color = Color(255, 165, 166, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["bind"] = { type = "Model", model = "models/props_lab/incubatorplug.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.915, 1.07, -0.534), angle = Angle(96.939, 0, 0), size = Vector(0.273, 0.273, 0.273), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["blade1+"] = { type = "Model", model = "models/props_lab/cleaver.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.26, 1.136, -2.543), angle = Angle(125.162, -20.104, 3.109), size = Vector(0.888, 0.888, 0.888), color = Color(255, 188, 186, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["blade1++"] = { type = "Model", model = "models/props_lab/cleaver.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.437, 2.033, -2.487), angle = Angle(107.083, -23.483, 0.898), size = Vector(0.888, 0.888, 0.888), color = Color(255, 168, 166, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["blade1"] = { type = "Model", model = "models/props_lab/cleaver.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.111, 0.428, -2.764), angle = Angle(115.713, 4.873, 0.693), size = Vector(0.885, 0.885, 0.885), color = Color(255, 150, 158, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.WElements = {
	["element_name"] = { type = "Model", model = "models/props/cs_militia/axe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.204, 4.544, -10), angle = Angle(14.307, -80.03, 88.747), size = Vector(1.041, 0.894, 1.041), color = Color(255, 165, 166, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["bind"] = { type = "Model", model = "models/props_lab/incubatorplug.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.542, 6.975, -21.862), angle = Angle(80.149, 90, 0), size = Vector(0.273, 0.273, 0.273), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["blade1+"] = { type = "Model", model = "models/props_lab/cleaver.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.163, 7.137, -22.914), angle = Angle(154.139, -90, 0), size = Vector(0.63, 0.63, 0.63), color = Color(255, 188, 186, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["blade1++"] = { type = "Model", model = "models/props_lab/cleaver.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.836, 7.166, -20.288), angle = Angle(170.277, -90, 0), size = Vector(0.679, 0.679, 0.679), color = Color(255, 168, 166, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["blade1"] = { type = "Model", model = "models/props_lab/cleaver.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.235, 7.414, -20.233), angle = Angle(116.773, -90, 0), size = Vector(0.589, 0.589, 0.589), color = Color(255, 150, 158, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
SWEP.Base = "weapon_zs_basemelee"

SWEP.ViewModel = "models/weapons/c_stunstick.mdl"
SWEP.WorldModel = "models/props/cs_militia/axe.mdl"
SWEP.UseHands = true

SWEP.HoldType = "melee2"

SWEP.MeleeDamage = 80
SWEP.MeleeRange = 60
SWEP.MeleeSize = 1.5
SWEP.MeleeKnockBack = 60
SWEP.Primary.Delay = 1

SWEP.Primary.Delay = 1.75

SWEP.WalkSpeed = SPEED_FAST

SWEP.SwingTime = 0.4
SWEP.SwingRotation = Angle(0, -20, -40)
SWEP.SwingOffset = Vector(10, 0, 0)
SWEP.SwingHoldType = "melee"

SWEP.HitDecal = "Manhackcut"

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(65, 70))
end

function SWEP:PlayHitSound()
	self:EmitSound("physics/metal/metal_sheet_impact_hard"..math.random(6,8)..".wav")
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav")
end
function SWEP:OnMeleeHit(hitent, hitflesh, tr)
	local effectdata = EffectData()
		effectdata:SetOrigin(tr.HitPos)
		effectdata:SetNormal(tr.HitNormal)
	util.Effect("MetalSpark", effectdata)
end