AddCSLuaFile()

SWEP.Base = "weapon_zs_battleaxe"

if CLIENT then
	SWEP.PrintName = "'Waraxe' Handgun"

	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/props_c17/concrete_barrier001a.mdl", bone = "v_weapon.USP_Parent", rel = "", pos = Vector(-0.69, -3.5, -1.5), angle = Angle(0, 0, 90), size = Vector(0.019, 0.019, 0.019), color = Color(203, 233, 236, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base+++"] = { type = "Model", model = "models/props_c17/canister02a.mdl", bone = "v_weapon.USP_Parent", rel = "base+", pos = Vector(-1.201, 0, -0.7), angle = Angle(90, 0, 0), size = Vector(0.129, 0.129, 0.059), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base+"] = { type = "Model", model = "models/props_junk/cinderblock01a.mdl", bone = "v_weapon.USP_Parent", rel = "base", pos = Vector(0.5, 3, 0), angle = Angle(0, 90, 90), size = Vector(0.119, 0.119, 0.119), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base++"] = { type = "Model", model = "models/props_c17/canister02a.mdl", bone = "v_weapon.USP_Parent", rel = "base+", pos = Vector(-1.201, 0, 0.699), angle = Angle(90, 0, 0), size = Vector(0.129, 0.129, 0.059), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/props_c17/concrete_barrier001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.659, 2.4, -3.651), angle = Angle(0, 85, 0), size = Vector(0.019, 0.019, 0.019), color = Color(203, 233, 236, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base+++"] = { type = "Model", model = "models/props_c17/canister02a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base+", pos = Vector(-1.201, 0, -0.7), angle = Angle(90, 0, 0), size = Vector(0.129, 0.129, 0.059), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base+"] = { type = "Model", model = "models/props_junk/cinderblock01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0.5, 3, 0), angle = Angle(0, 90, 90), size = Vector(0.119, 0.119, 0.119), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base++"] = { type = "Model", model = "models/props_c17/canister02a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base+", pos = Vector(-1.201, 0, 0.699), angle = Angle(90, 0, 0), size = Vector(0.129, 0.129, 0.059), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Primary.Damage = 14
SWEP.Primary.NumShots = 2
SWEP.Primary.Delay = 0.2

SWEP.Primary.ClipSize = 14
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 0.07
SWEP.ConeMin = 0.03

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound, 80, 75)
end
