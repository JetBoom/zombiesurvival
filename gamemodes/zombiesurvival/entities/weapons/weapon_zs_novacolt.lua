AddCSLuaFile()

SWEP.PrintName = "'Nova Colt' Handcannon"
SWEP.Description = "A heavy handgun which deals impressive burst damage but has a significant reload time."
SWEP.Slot = 1
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 56

	SWEP.HUD3DBone = "v_weapon.Deagle_Parent"
	SWEP.HUD3DPos = Vector(0.1, -5.5, 1.22)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.016

	SWEP.VElements = {
		["novacolt++++++"] = { type = "Model", model = "models/props_combine/breenlight.mdl", bone = "v_weapon.Deagle_Parent", rel = "novacolt", pos = Vector(0, 4.524, 4.07), angle = Angle(113.376, -90, 0), size = Vector(0.451, 0.298, 0.365), color = Color(148, 152, 183, 255), surpresslightning = false, material = "models/props_c17/clockwood01", skin = 0, bodygroup = {} },
		["novacolt++"] = { type = "Model", model = "models/props_combine/combinethumper002.mdl", bone = "v_weapon.Deagle_Parent", rel = "novacolt", pos = Vector(-0.612, 3.635, 1.74), angle = Angle(0, 0, 180), size = Vector(0.05, 0.059, 0.059), color = Color(170, 181, 185, 255), surpresslightning = false, material = "models/weapons/v_stunstick/v_stunstick_diffuse", skin = 0, bodygroup = {} },
		["novacolt"] = { type = "Model", model = "models/props_wasteland/laundry_washer001a.mdl", bone = "v_weapon.Deagle_Parent", rel = "", pos = Vector(0, -5.56, -2.725), angle = Angle(0, 0, 0), size = Vector(0.045, 0.045, 0.059), color = Color(80, 87, 99, 255), surpresslightning = false, material = "models/weapons/v_shotgun/vshotgun_albedo", skin = 0, bodygroup = {} },
		["novacolt+++++"] = { type = "Model", model = "models/props_wasteland/laundry_dryer001.mdl", bone = "v_weapon.Deagle_Parent", rel = "novacolt", pos = Vector(0, 0.6, 3), angle = Angle(110, -90, 0), size = Vector(0.019, 0.041, 0.034), color = Color(75, 82, 95, 255), surpresslightning = false, material = "models/props_c17/column02a", skin = 0, bodygroup = {} },
		["novacolt+"] = { type = "Model", model = "models/props_wasteland/laundry_washer001a.mdl", bone = "v_weapon.Deagle_Parent", rel = "novacolt", pos = Vector(0, 3, -0.35), angle = Angle(90, 0, 0), size = Vector(0.029, 0.029, 0.05), color = Color(92, 108, 118, 255), surpresslightning = false, material = "models/weapons/v_smg1/texture4", skin = 0, bodygroup = {} },
		["novacolt+++++++"] = { type = "Model", model = "models/props_lab/eyescanner.mdl", bone = "v_weapon.Deagle_Parent", rel = "novacolt", pos = Vector(0, -1.601, 2.2), angle = Angle(66.62, 90, 0), size = Vector(0.129, 0.15, 0.159), color = Color(47, 52, 56, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["novacolt++++"] = { type = "Model", model = "models/props_combine/combine_train02a.mdl", bone = "v_weapon.Deagle_Parent", rel = "novacolt", pos = Vector(0, 0.47, -5.652), angle = Angle(-180, 180, 90), size = Vector(0.019, 0.028, 0.019), color = Color(75, 87, 79, 255), surpresslightning = false, material = "models/weapons/w_irifle/w_irifle", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["novacolt"] = { type = "Model", model = "models/props_wasteland/laundry_washer001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.314, 1.432, -5.409), angle = Angle(0, 90, -86.532), size = Vector(0.045, 0.045, 0.059), color = Color(80, 87, 99, 255), surpresslightning = false, material = "models/weapons/v_shotgun/vshotgun_albedo", skin = 0, bodygroup = {} },
		["novacolt++++"] = { type = "Model", model = "models/props_combine/combine_train02a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "novacolt", pos = Vector(0, 0.47, -5.652), angle = Angle(-180, 180, 90), size = Vector(0.019, 0.028, 0.019), color = Color(75, 87, 79, 255), surpresslightning = false, material = "models/weapons/w_irifle/w_irifle", skin = 0, bodygroup = {} },
		["novacolt+++++"] = { type = "Model", model = "models/props_wasteland/laundry_dryer001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "novacolt", pos = Vector(0, 0.6, 3), angle = Angle(110, -90, 0), size = Vector(0.019, 0.041, 0.034), color = Color(75, 82, 95, 255), surpresslightning = false, material = "models/props_c17/column02a", skin = 0, bodygroup = {} },
		["novacolt+"] = { type = "Model", model = "models/props_wasteland/laundry_washer001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "novacolt", pos = Vector(0, 3, -0.35), angle = Angle(90, 0, 0), size = Vector(0.029, 0.029, 0.05), color = Color(92, 108, 118, 255), surpresslightning = false, material = "models/weapons/v_smg1/texture4", skin = 0, bodygroup = {} },
		["novacolt++"] = { type = "Model", model = "models/props_combine/combinethumper002.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "novacolt", pos = Vector(-0.612, 3.635, 1.74), angle = Angle(0, 0, 180), size = Vector(0.05, 0.059, 0.059), color = Color(170, 181, 185, 255), surpresslightning = false, material = "models/weapons/v_stunstick/v_stunstick_diffuse", skin = 0, bodygroup = {} },
		["novacolt+++++++"] = { type = "Model", model = "models/props_lab/eyescanner.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "novacolt", pos = Vector(0, -1.601, 2.2), angle = Angle(66.62, 90, 0), size = Vector(0.129, 0.15, 0.159), color = Color(47, 52, 56, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["novacolt++++++"] = { type = "Model", model = "models/props_combine/breenlight.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "novacolt", pos = Vector(0, 4.524, 4.07), angle = Angle(113.376, -90, 0), size = Vector(0.451, 0.298, 0.365), color = Color(148, 152, 183, 255), surpresslightning = false, material = "models/props_c17/clockwood01", skin = 0, bodygroup = {} }
	}

	SWEP.IronSightsPos = Vector(-6.321, 0, -0.561)
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "revolver"

SWEP.ViewModel = "models/weapons/cstrike/c_pist_deagle.mdl"
SWEP.WorldModel = "models/weapons/w_pist_deagle.mdl"

SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false
SWEP.UseHands = true

SWEP.Primary.Damage = 85
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.31

SWEP.Primary.ClipSize = 8
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 3.05
SWEP.ConeMin = 1.35

SWEP.FireAnimSpeed = 1.35
SWEP.ReloadSpeed = 0.43

SWEP.Tier = 5
SWEP.MaxStock = 2

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 1, 1)

function SWEP:EmitFireSound()
	self:EmitSound("weapons/deagle/deagle-1.wav", 75, math.random(81, 85), 0.8)
	self:EmitSound("weapons/galil/galil-1.wav", 75, math.random(142, 148), 0.7, CHAN_WEAPON + 20)
end

function SWEP:EmitReloadSound()
	if IsFirstTimePredicted() then
		self:EmitSound("weapons/357/357_reload1.wav", 75, 75, 1, CHAN_WEAPON + 21)
	end
end

function SWEP:EmitReloadFinishSound()
	if IsFirstTimePredicted() then
		self:EmitSound("weapons/357/357_spin1.wav", 70, 90)
	end
end

function SWEP:SendReloadAnimation()
	self:SendWeaponAnim(ACT_VM_DRAW)
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity

	if SERVER and ent and ent:IsValidLivingZombie() then
		dmginfo:SetDamageForce(attacker:GetUp() * 7000 + attacker:GetForward() * 25000)
	end
end

local ghostlerp = 0
function SWEP:CalcViewModelView(vm, oldpos, oldang, pos, ang)
	if self:GetOwner():GetBarricadeGhosting() or self:GetReloadFinish() > 0 then
		ghostlerp = math.min(1, ghostlerp + FrameTime() * 0.1)
	elseif ghostlerp > 0 then
		ghostlerp = math.max(0, ghostlerp - FrameTime() * 0.9)
	end

	if ghostlerp > 0 then
		ang:RotateAroundAxis(ang:Right(), -65 * ghostlerp)
	end

	return pos, ang
end
