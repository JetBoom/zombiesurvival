AddCSLuaFile()

SWEP.PrintName = "'Blareduct' Zip Gun"
SWEP.Slot = 3
SWEP.SlotPos = 0

if CLIENT then
	SWEP.HUD3DBone = "ValveBiped.Gun"
	SWEP.HUD3DPos = Vector(1.65, 0, -8)
	SWEP.HUD3DScale = 0.025

	SWEP.ViewModelFlip = false

	SWEP.VElements = {
		["pipe++"] = { type = "Model", model = "models/props_vehicles/carparts_axel01a.mdl", bone = "ValveBiped.Gun", rel = "pipe", pos = Vector(0.699, 0, 0), angle = Angle(0, 0, 90), size = Vector(0.15, 0.4, 0.2), color = Color(105, 115, 130, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["pipe+"] = { type = "Model", model = "models/props_vehicles/carparts_muffler01a.mdl", bone = "ValveBiped.Gun", rel = "pipe", pos = Vector(1, -0.201, -15), angle = Angle(90, -90, 0), size = Vector(0.2, 0.3, 0.25), color = Color(105, 115, 130, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["pipe+++"] = { type = "Model", model = "models/props_vehicles/carparts_axel01a.mdl", bone = "ValveBiped.Gun", rel = "pipe", pos = Vector(0, 0, -10), angle = Angle(0, 0, 90), size = Vector(0.25, 0.3, 0.15), color = Color(77, 77, 82, 255), surpresslightning = false, material = "models/props_lab/ravendoor_sheet", skin = 0, bodygroup = {} },
		["pipe"] = { type = "Model", model = "models/props_canal/mattpipe.mdl", bone = "ValveBiped.Gun", rel = "", pos = Vector(0, 0.5, 7), angle = Angle(0, -90, 0), size = Vector(1, 1, 0.899), color = Color(65, 69, 84, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["pipe++"] = { type = "Model", model = "models/props_vehicles/carparts_axel01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "pipe", pos = Vector(0.699, 0, 0), angle = Angle(0, 0, 90), size = Vector(0.15, 0.4, 0.2), color = Color(105, 115, 130, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["pipe+"] = { type = "Model", model = "models/props_vehicles/carparts_muffler01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "pipe", pos = Vector(1, -0.201, -15), angle = Angle(90, -90, 0), size = Vector(0.2, 0.3, 0.25), color = Color(105, 115, 130, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["pipe+++"] = { type = "Model", model = "models/props_vehicles/carparts_axel01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "pipe", pos = Vector(0, 0, -10), angle = Angle(0, 0, 90), size = Vector(0.25, 0.3, 0.15), color = Color(77, 77, 82, 255), surpresslightning = false, material = "models/props_lab/ravendoor_sheet", skin = 0, bodygroup = {} },
		["pipe"] = { type = "Model", model = "models/props_canal/mattpipe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(19, 1, -5), angle = Angle(85.324, 0, 180), size = Vector(1, 1, 0.899), color = Color(65, 69, 84, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_baseshotgun"
DEFINE_BASECLASS("weapon_zs_baseshotgun")

SWEP.HoldType = "shotgun"

SWEP.ViewModel = "models/weapons/c_shotgun.mdl"
SWEP.WorldModel = "models/weapons/w_shotgun.mdl"
SWEP.UseHands = true

SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false

SWEP.Primary.Sound = Sound("weapons/shotgun/shotgun_dbl_fire.wav")
SWEP.Primary.Damage = 7.7625
SWEP.Primary.NumShots = 8
SWEP.Primary.Delay = 0.75

SWEP.Primary.ClipSize = 1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "buckshot"
SWEP.ReloadSound = Sound("weapons/aug/aug_boltslap.wav")
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ReloadSpeed = 0.45
SWEP.ReloadDelay = 0.45

SWEP.Recoil = 70

SWEP.FireAnimSpeed = 0.5

SWEP.ConeMax = 8
SWEP.ConeMin = 7

SWEP.WalkSpeed = SPEED_NORMAL

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.19, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RECOIL, -32.5)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -1)

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound, 75, math.random(187, 193), 0.7)
	self:EmitSound("weapons/shotgun/shotgun_fire6.wav", 75, math.random(102, 148), 0.6, CHAN_WEAPON + 20)
end

function SWEP:SecondaryAttack()
end

if not CLIENT then return end

local ghostlerp = 0
function SWEP:CalcViewModelView(vm, oldpos, oldang, pos, ang)
	if self:GetOwner():GetBarricadeGhosting() or self:IsReloading() then
		ghostlerp = math.min(1, ghostlerp + FrameTime() * 0.5)
	elseif ghostlerp > 0 then
		ghostlerp = math.max(0, ghostlerp - FrameTime() * 0.5)
	end

	if ghostlerp > 0 then
		ang:RotateAroundAxis(ang:Right(), -35 * ghostlerp)
	end

	return pos, ang
end
