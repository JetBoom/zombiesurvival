AddCSLuaFile()

if CLIENT then

	SWEP.PrintName = translate.Get("craft_jethammer")
	SWEP.Description = translate.Get("craft_jethammerdesk")

	SWEP.ViewModelFOV = 70

SWEP.VElements = {
	["4"] = { type = "Model", model = "models/props_phx/construct/metal_tube.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(6.804, 0, 30.77), angle = Angle(90, 0, 0), size = Vector(0.072, 0.108, 0.301), color = Color(255, 255, 255, 0), surpresslightning = false, material = "phoenix_storms/gear", skin = 0, bodygroup = {} },
	["3+++"] = { type = "Model", model = "models/hunter/tubes/tubebend2x2x90outer.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(-9.105, 0, 31.82), angle = Angle(180, 90, 134.378), size = Vector(0.065, 0.065, 0.126), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} },
	["1"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.27, 1.593, 8.876), angle = Angle(0, 0, 180), size = Vector(0.739, 0.739, 0.27), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/gear", skin = 0, bodygroup = {} },
	["5"] = { type = "Model", model = "models/hunter/tubes/tube1x1x2.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0.181, -0.63, 27.148), angle = Angle(90, 0, 0), size = Vector(0.057, 0.057, 0.116), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/gear", skin = 0, bodygroup = {} },
	["1+"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, 0, 3.257), angle = Angle(0, 0, 0), size = Vector(0.794, 0.794, 0.075), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/metal", skin = 0, bodygroup = {} },
	["6"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "4", pos = Vector(0.231, 0, 12.152), angle = Angle(0, 90, -90), size = Vector(0.352, 0.352, 0.352), color = Color(255, 255, 255, 0), surpresslightning = false, material = "phoenix_storms/gear", skin = 0, bodygroup = {} },
	["7+"] = { type = "Model", model = "models/maxofs2d/hover_propeller.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "5+", pos = Vector(0, 0, 3.835), angle = Angle(0, 0, 0), size = Vector(0.141, 0.141, 0.184), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["4+"] = { type = "Model", model = "models/props_phx/construct/metal_tube.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(7.125, 0, 30.77), angle = Angle(0, 90, -90), size = Vector(0.072, 0.108, 0.301), color = Color(255, 255, 255, 0), surpresslightning = false, material = "phoenix_storms/gear", skin = 0, bodygroup = {} },
	["5+"] = { type = "Model", model = "models/hunter/tubes/tube1x1x2.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(-2.244, -0.63, 31.32), angle = Angle(90, 0, 0), size = Vector(0.057, 0.057, 0.086), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/gear", skin = 0, bodygroup = {} },
	["1++"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, 0, 15.647), angle = Angle(0, 0, 0), size = Vector(0.794, 0.794, 0.075), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/metal", skin = 0, bodygroup = {} },
	["3"] = { type = "Model", model = "models/hunter/tubes/tubebend2x2x90outer.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(-4.22, 0, 36.069), angle = Angle(180, 90, 90.404), size = Vector(0.065, 0.065, 0.126), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} },
	["7"] = { type = "Model", model = "models/maxofs2d/hover_propeller.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "5", pos = Vector(0, 0, 6.62), angle = Angle(0, 0, 0), size = Vector(0.141, 0.141, 0.184), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["2"] = { type = "Model", model = "models/props_c17/TrapPropeller_Engine.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(-2.276, 0, 31.502), angle = Angle(-90, 180, 0), size = Vector(0.266, 0.266, 0.425), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["3++"] = { type = "Model", model = "models/hunter/tubes/tubebend2x2x90outer.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(3.138, 0, 22.694), angle = Angle(0, 90, 30.533), size = Vector(0.074, 0.078, 0.114), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} },
	["3+"] = { type = "Model", model = "models/hunter/tubes/tubebend2x2x90outer.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(5.013, 0, 28.458), angle = Angle(0, 90, 0), size = Vector(0.074, 0.074, 0.114), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} },
	["wydluzenie"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, 0, -8), angle = Angle(0, 0, 0), size = Vector(0.733, 0.733, 0.26), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/gear", skin = 0, bodygroup = {} },
	["2+"] = { type = "Model", model = "models/props_c17/TrapPropeller_Engine.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(-0.694, 0, 27.158), angle = Angle(90, 180, 0), size = Vector(0.247, 0.247, 0.352), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
SWEP.WElements = {
	["4"] = { type = "Model", model = "models/props_phx/construct/metal_tube.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(6.804, 0, 30.77), angle = Angle(90, 0, 0), size = Vector(0.072, 0.108, 0.301), color = Color(255, 255, 255, 0), surpresslightning = false, material = "phoenix_storms/gear", skin = 0, bodygroup = {} },
	["3+"] = { type = "Model", model = "models/hunter/tubes/tubebend2x2x90outer.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(5.013, 0, 28.458), angle = Angle(0, 90, 0), size = Vector(0.074, 0.074, 0.114), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} },
	["5"] = { type = "Model", model = "models/hunter/tubes/tube1x1x2.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0.181, -0.63, 27.148), angle = Angle(90, 0, 0), size = Vector(0.057, 0.057, 0.116), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/gear", skin = 0, bodygroup = {} },
	["1+"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, 0, -6.086), angle = Angle(0, 0, 0), size = Vector(0.794, 0.794, 0.075), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/metal", skin = 0, bodygroup = {} },
	["4+"] = { type = "Model", model = "models/props_phx/construct/metal_tube.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(7.125, 0, 30.77), angle = Angle(0, 90, -90), size = Vector(0.072, 0.108, 0.301), color = Color(255, 255, 255, 0), surpresslightning = false, material = "phoenix_storms/gear", skin = 0, bodygroup = {} },
	["7+"] = { type = "Model", model = "models/maxofs2d/hover_propeller.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "5+", pos = Vector(0, 0, 3.835), angle = Angle(0, 0, 0), size = Vector(0.141, 0.141, 0.184), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["1++++"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, 0, -20.976), angle = Angle(0, 0, 0), size = Vector(0.794, 0.794, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/metal", skin = 0, bodygroup = {} },
	["3++"] = { type = "Model", model = "models/hunter/tubes/tubebend2x2x90outer.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(3.138, 0, 22.694), angle = Angle(0, 90, 30.533), size = Vector(0.074, 0.078, 0.114), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} },
	["1"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.43, 1.514, 0), angle = Angle(16.322, -23.182, 180), size = Vector(0.739, 0.739, 0.27), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/gear", skin = 0, bodygroup = {} },
	["5+"] = { type = "Model", model = "models/hunter/tubes/tube1x1x2.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(-2.244, -0.63, 31.32), angle = Angle(90, 0, 0), size = Vector(0.057, 0.057, 0.086), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/gear", skin = 0, bodygroup = {} },
	["3+++"] = { type = "Model", model = "models/hunter/tubes/tubebend2x2x90outer.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(-9.105, 0, 31.82), angle = Angle(180, 90, 134.378), size = Vector(0.065, 0.065, 0.126), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} },
	["3"] = { type = "Model", model = "models/hunter/tubes/tubebend2x2x90outer.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(-4.22, 0, 36.069), angle = Angle(180, 90, 90.404), size = Vector(0.065, 0.065, 0.126), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} },
	["1+++"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, 0, 2.365), angle = Angle(0, 0, 180), size = Vector(0.647, 0.647, 0.204), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/gear", skin = 0, bodygroup = {} },
	["2"] = { type = "Model", model = "models/props_c17/TrapPropeller_Engine.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(-2.276, 0, 31.502), angle = Angle(-90, 180, 0), size = Vector(0.266, 0.266, 0.425), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["1++"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, 0, 7.199), angle = Angle(0, 0, 0), size = Vector(0.794, 0.794, 0.075), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/metal", skin = 0, bodygroup = {} },
	["7"] = { type = "Model", model = "models/maxofs2d/hover_propeller.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "5", pos = Vector(0, 0, 6.62), angle = Angle(0, 0, 0), size = Vector(0.141, 0.141, 0.184), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["2+"] = { type = "Model", model = "models/props_c17/TrapPropeller_Engine.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(-0.694, 0, 27.158), angle = Angle(90, 180, 0), size = Vector(0.247, 0.247, 0.352), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
end
SWEP.Base = "weapon_zs_basemelee"

SWEP.HoldType = "melee2"

SWEP.DamageType = DMG_CLUB

SWEP.ViewModel = "models/weapons/c_stunstick.mdl"
SWEP.WorldModel = "models/weapons/w_stunbaton.mdl"
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false


SWEP.MeleeDamage = 1025

SWEP.MeleeRange = 125

SWEP.MeleeSize = 4

SWEP.MeleeKnockBack = SWEP.MeleeDamage * 0.4

SWEP.Primary.Delay = 4.0 
SWEP.WalkSpeed = SPEED_SLOWEST


SWEP.SwingRotation = Angle(60, 0, -80)

SWEP.SwingOffset = Vector(0, -30, 0)

SWEP.SwingTime = 2

SWEP.SwingHoldType = "melee"


function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(20, 25))
end

function 
SWEP:PlayHitSound()
	self:EmitSound("vehicles/v8/vehicle_impact_heavy"..math.random(4)..".wav", 80, math.Rand(95, 105))
end

function 
SWEP:PlayHitFleshSound()
	self:EmitSound("physics/flesh/flesh_bloody_break.wav", 80, math.Rand(90, 100))
end

function 
SWEP:OnMeleeHit(hitent, hitflesh, tr)
	local effectdata = EffectData()
		effectdata:SetOrigin(tr.HitPos)
		effectdata:SetNormal(tr.HitNormal)
	util.Effect("explosion", effectdata)
end