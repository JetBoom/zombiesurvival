AddCSLuaFile()

SWEP.Base = "weapon_zs_baseshotgun"

SWEP.PrintName = "'Gladiator' Super Shotgun"
SWEP.Description = "A pump super shotgun."

if CLIENT then
	SWEP.ViewModelFlip = false

	SWEP.HUD3DBone = "v_weapon.M3_PARENT"
	SWEP.HUD3DPos = Vector(-1.5, -5, -2)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.015

	SWEP.VElements = {
		["fracture+++++++"] = { type = "Model", model = "models/items/combine_rifle_cartridge01.mdl", bone = "v_weapon.M3_PARENT", rel = "fracture", pos = Vector(0, 0, 0.25), angle = Angle(97.013, 0, 0), size = Vector(0.6, 0.4, 1.598), color = Color(77, 100, 135, 255), surpresslightning = false, material = "models/props_pipes/guttermetal01a", skin = 0, bodygroup = {} },
		["fracture+++"] = { type = "Model", model = "models/props_wasteland/laundry_washer001a.mdl", bone = "v_weapon.M3_PARENT", rel = "fracture", pos = Vector(-1.5, 0, -1), angle = Angle(0, -90, -90), size = Vector(0.035, 0.029, 0.25), color = Color(69, 77, 94, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
		["fracture++++"] = { type = "Model", model = "models/props_c17/utilityconnecter003.mdl", bone = "v_weapon.M3_PARENT", rel = "fracture", pos = Vector(4.675, 0, -0.201), angle = Angle(0, -90, 0), size = Vector(0.625, 0.625, 0.625), color = Color(70, 87, 104, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
		["fracture"] = { type = "Model", model = "models/props_wasteland/laundry_washer003.mdl", bone = "v_weapon.M3_PARENT", rel = "", pos = Vector(0, -4.5, -10.91), angle = Angle(90, -90, 0), size = Vector(0.25, 0.039, 0.029), color = Color(69, 90, 123, 255), surpresslightning = false, material = "models/props_pipes/guttermetal01a", skin = 0, bodygroup = {} },
		["fracture++"] = { type = "Model", model = "models/props_c17/factorymachine01.mdl", bone = "v_weapon.M3_PARENT", rel = "fracture", pos = Vector(-5.715, 0, -1.4), angle = Angle(180, -90, 0), size = Vector(0.025, 0.025, 0.045), color = Color(75, 100, 125, 255), surpresslightning = false, material = "models/props_pipes/guttermetal01a", skin = 0, bodygroup = {} },
		["fracture+"] = { type = "Model", model = "models/props_c17/traffic_light001a.mdl", bone = "v_weapon.M3_PARENT", rel = "fracture", pos = Vector(-5.715, 0, 0), angle = Angle(0, 0, 90), size = Vector(1.399, 0.1, 0.119), color = Color(75, 100, 125, 255), surpresslightning = false, material = "models/props_pipes/guttermetal01a", skin = 0, bodygroup = {} },
		["fracture++++++"] = { type = "Model", model = "models/props_c17/trappropeller_lever.mdl", bone = "v_weapon.M3_PARENT", rel = "fracture", pos = Vector(10.5, 0, -2), angle = Angle(0, -90, -33.896), size = Vector(1, 0.6, 1.2), color = Color(87, 109, 117, 255), surpresslightning = false, material = "models/props_pipes/guttermetal01a", skin = 0, bodygroup = {} },
		["fracture+++++"] = { type = "Model", model = "models/props_c17/utilityconnecter002.mdl", bone = "v_weapon.M3_PARENT", rel = "fracture", pos = Vector(8, 0, -2.597), angle = Angle(0, -90, 180), size = Vector(0.2, 0.2, 0.2), color = Color(70, 87, 104, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["fracture+++"] = { type = "Model", model = "models/props_wasteland/laundry_washer001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "fracture", pos = Vector(-1.5, 0, -1), angle = Angle(0, -90, -90), size = Vector(0.035, 0.029, 0.25), color = Color(69, 77, 94, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
		["fracture+"] = { type = "Model", model = "models/props_c17/traffic_light001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "fracture", pos = Vector(-5.715, 0, 0), angle = Angle(0, 0, 90), size = Vector(1.399, 0.1, 0.119), color = Color(75, 100, 125, 255), surpresslightning = false, material = "models/props_pipes/guttermetal01a", skin = 0, bodygroup = {} },
		["fracture"] = { type = "Model", model = "models/props_wasteland/laundry_washer003.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(16, 1, -4.301), angle = Angle(180, 0, 0), size = Vector(0.25, 0.039, 0.029), color = Color(69, 77, 94, 255), surpresslightning = false, material = "models/props_pipes/guttermetal01a", skin = 0, bodygroup = {} },
		["fracture++++"] = { type = "Model", model = "models/props_c17/utilityconnecter003.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "fracture", pos = Vector(4.675, 0, -0.201), angle = Angle(0, -90, 0), size = Vector(0.625, 0.625, 0.625), color = Color(70, 87, 104, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
		["fracture+++++"] = { type = "Model", model = "models/props_c17/utilityconnecter002.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "fracture", pos = Vector(8, 0, -2.597), angle = Angle(0, -90, 180), size = Vector(0.2, 0.2, 0.2), color = Color(70, 87, 104, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
		["fracture+++++++"] = { type = "Model", model = "models/items/combine_rifle_cartridge01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "fracture", pos = Vector(0, 0, 0.25), angle = Angle(97.013, 0, 0), size = Vector(0.6, 0.4, 1.598), color = Color(77, 100, 125, 255), surpresslightning = false, material = "models/props_pipes/guttermetal01a", skin = 0, bodygroup = {} },
		["fracture++++++"] = { type = "Model", model = "models/props_c17/trappropeller_lever.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "fracture", pos = Vector(10.5, 0, -2), angle = Angle(0, -90, -33.896), size = Vector(1, 0.6, 1.2), color = Color(87, 99, 107, 255), surpresslightning = false, material = "models/props_pipes/guttermetal01a", skin = 0, bodygroup = {} },
		["fracture++"] = { type = "Model", model = "models/props_c17/factorymachine01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "fracture", pos = Vector(-5.715, 0, -1.4), angle = Angle(180, -90, 0), size = Vector(0.025, 0.025, 0.045), color = Color(75, 100, 125, 255), surpresslightning = false, material = "models/props_pipes/guttermetal01a", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_baseshotgun"

SWEP.HoldType = "shotgun"

SWEP.ViewModel = "models/weapons/cstrike/c_shot_m3super90.mdl"
SWEP.WorldModel = "models/weapons/w_shot_m3super90.mdl"
SWEP.UseHands = true

SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false

SWEP.ReloadDelay = 0.3

SWEP.Primary.Sound = Sound(")weapons/zs_glad/gladshot4.wav")
SWEP.Primary.Damage = 14
SWEP.Primary.NumShots = 16
SWEP.Primary.Delay = 1.2

SWEP.RequiredClip = 2

SWEP.Primary.ClipSize = 12
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "buckshot"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 8.5
SWEP.ConeMin = 7.25

SWEP.FireAnimSpeed = 0.8
SWEP.WalkSpeed = SPEED_SLOWEST

SWEP.Tier = 5

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -1.0625)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.90625)

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound, 77, 100, 1)
end
