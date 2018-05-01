AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = "'Onyx' Rifle"
SWEP.Description = "Reliable balanced sniper rifle with good accuracy, clip size and damage."

SWEP.Slot = 3
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false

	SWEP.HUD3DBone = "v_weapon.sg550_Parent"
	SWEP.HUD3DPos = Vector(-1, -5.2, -2)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.02

	SWEP.VElements = {
		["svu++"] = { type = "Model", model = "models/props_wasteland/gaspump001a.mdl", bone = "v_weapon.sg550_Parent", rel = "svu", pos = Vector(2, 0, 0.5), angle = Angle(-90, 0, 73.636), size = Vector(0.029, 0.059, 0.1), color = Color(49, 54, 52, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
		["svu+++++++"] = { type = "Model", model = "models/hunter/tubes/tube1x1x2.mdl", bone = "v_weapon.sg550_Parent", rel = "svu", pos = Vector(9, -2.6, 0.5), angle = Angle(90, 0, 0), size = Vector(0.034, 0.034, 0.034), color = Color(90, 85, 75, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["svu+++"] = { type = "Model", model = "models/props_wasteland/laundry_washer001a.mdl", bone = "v_weapon.sg550_Parent", rel = "svu", pos = Vector(-2, 0.6, 0.5), angle = Angle(92.337, -90, -90), size = Vector(0.019, 0.039, 0.15), color = Color(69, 94, 138, 255), surpresslightning = false, material = "models/props_pipes/pipeset_metal", skin = 0, bodygroup = {} },
		["svu++++++++++"] = { type = "Model", model = "models/hunter/blocks/cube1x1x1.mdl", bone = "v_weapon.sg550_Clip", rel = "", pos = Vector(0, 1.6, 0.5), angle = Angle(0, 0, 11), size = Vector(0.013, 0.109, 0.068), color = Color(27, 31, 34, 255), surpresslightning = false, material = "phoenix_storms/concrete2", skin = 0, bodygroup = {} },
		["svu++++++++++++"] = { type = "Model", model = "models/props_junk/ibeam01a.mdl", bone = "v_weapon.sg550_Parent", rel = "svu", pos = Vector(2.5, -1, 0.5), angle = Angle(0, 0, 90), size = Vector(0.009, 0.09, 0.15), color = Color(128, 113, 94, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["svu+++++++++++"] = { type = "Model", model = "models/props_wasteland/laundry_washer001a.mdl", bone = "v_weapon.sg550_Parent", rel = "svu", pos = Vector(11, 0.6, 0.5), angle = Angle(92.337, -90, -90), size = Vector(0.017, 0.035, 0.14), color = Color(85, 113, 160, 255), surpresslightning = false, material = "models/props_pipes/pipeset_metal", skin = 0, bodygroup = {} },
		["svu"] = { type = "Model", model = "models/props_phx/torpedo.mdl", bone = "v_weapon.sg550_Parent", rel = "", pos = Vector(0.6, -5, -3), angle = Angle(90, 0, 0), size = Vector(0.15, 0.09, 0.05), color = Color(80, 78, 85, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["svu++++"] = { type = "Model", model = "models/props_wasteland/laundry_washer001a.mdl", bone = "v_weapon.sg550_Parent", rel = "svu", pos = Vector(-14, 0, 0.5), angle = Angle(92.337, -90, -90), size = Vector(0.019, 0.019, 0.15), color = Color(74, 94, 138, 255), surpresslightning = false, material = "models/props_pipes/pipeset_metal", skin = 0, bodygroup = {} },
		["svu+++++++++++++"] = { type = "Model", model = "models/props_junk/ibeam01a.mdl", bone = "v_weapon.sg550_Parent", rel = "svu", pos = Vector(6.5, -1, 0.5), angle = Angle(0, 0, 90), size = Vector(0.009, 0.09, 0.15), color = Color(128, 113, 94, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["svu++++++"] = { type = "Model", model = "models/hunter/tubes/tube1x1x2.mdl", bone = "v_weapon.sg550_Parent", rel = "svu", pos = Vector(6, -2.6, 0.5), angle = Angle(90, 0, 0), size = Vector(0.029, 0.029, 0.09), color = Color(161, 163, 132, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["svu+++++++++"] = { type = "Model", model = "models/XQM/panel360.mdl", bone = "v_weapon.sg550_Parent", rel = "svu", pos = Vector(9.5, -2.6, 0.5), angle = Angle(0, 0, 0), size = Vector(0.029, 0.029, 0.029), color = Color(25, 33, 51, 255), surpresslightning = false, material = "models/props/cs_office/snowmana", skin = 0, bodygroup = {} },
		["svu++++++++"] = { type = "Model", model = "models/hunter/tubes/tube1x1x2.mdl", bone = "v_weapon.sg550_Parent", rel = "svu", pos = Vector(9.5, -2.6, 0.5), angle = Angle(90, 0, 0), size = Vector(0.037, 0.037, 0.009), color = Color(72, 67, 62, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["svu+"] = { type = "Model", model = "models/props_wasteland/gaspump001a.mdl", bone = "v_weapon.sg550_Parent", rel = "svu", pos = Vector(13, 0, 0.5), angle = Angle(-90, 0, 90), size = Vector(0.05, 0.119, 0.059), color = Color(49, 44, 49, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
		["svu+++++"] = { type = "Model", model = "models/props_wasteland/prison_flourescentlight001a.mdl", bone = "v_weapon.sg550_Parent", rel = "svu", pos = Vector(4, -0.741, 0.5), angle = Angle(90, 0, 90), size = Vector(0.119, 0.119, 0.039), color = Color(176, 170, 153, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["svu++"] = { type = "Model", model = "models/props_wasteland/gaspump001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "svu", pos = Vector(2, 0, 0.5), angle = Angle(-90, 0, 73.636), size = Vector(0.029, 0.059, 0.1), color = Color(49, 54, 52, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
		["svu+++++++"] = { type = "Model", model = "models/hunter/tubes/tube1x1x2.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "svu", pos = Vector(9, -2.6, 0.5), angle = Angle(90, 0, 0), size = Vector(0.034, 0.034, 0.034), color = Color(90, 85, 75, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["svu+++"] = { type = "Model", model = "models/props_wasteland/laundry_washer001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "svu", pos = Vector(-2, 0.6, 0.5), angle = Angle(92.337, -90, -90), size = Vector(0.019, 0.039, 0.15), color = Color(69, 94, 138, 255), surpresslightning = false, material = "models/props_pipes/pipeset_metal", skin = 0, bodygroup = {} },
		["svu+++++"] = { type = "Model", model = "models/props_wasteland/prison_flourescentlight001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "svu", pos = Vector(4, -0.741, 0.5), angle = Angle(90, 0, 90), size = Vector(0.119, 0.119, 0.039), color = Color(176, 170, 153, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["svu+"] = { type = "Model", model = "models/props_wasteland/gaspump001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "svu", pos = Vector(13, 0, 0.5), angle = Angle(-90, 0, 90), size = Vector(0.05, 0.119, 0.059), color = Color(49, 44, 49, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
		["svu++++++++++"] = { type = "Model", model = "models/hunter/blocks/cube1x1x1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "svu", pos = Vector(-1, 2, 0.25), angle = Angle(90, 0, 11), size = Vector(0.013, 0.109, 0.068), color = Color(27, 31, 34, 255), surpresslightning = false, material = "phoenix_storms/concrete2", skin = 0, bodygroup = {} },
		["svu"] = { type = "Model", model = "models/props_phx/torpedo.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.5, 0, -4), angle = Angle(171.817, 0, 90), size = Vector(0.15, 0.09, 0.05), color = Color(80, 78, 85, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["svu++++"] = { type = "Model", model = "models/props_wasteland/laundry_washer001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "svu", pos = Vector(-14, 0, 0.5), angle = Angle(92.337, -90, -90), size = Vector(0.019, 0.019, 0.159), color = Color(74, 94, 138, 255), surpresslightning = false, material = "models/props_pipes/pipeset_metal", skin = 0, bodygroup = {} },
		["svu+++++++++++++"] = { type = "Model", model = "models/props_junk/ibeam01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "svu", pos = Vector(6.5, -1, 0.5), angle = Angle(0, 0, 90), size = Vector(0.009, 0.09, 0.15), color = Color(128, 113, 94, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["svu++++++"] = { type = "Model", model = "models/hunter/tubes/tube1x1x2.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "svu", pos = Vector(6, -2.6, 0.5), angle = Angle(90, 0, 0), size = Vector(0.029, 0.029, 0.09), color = Color(161, 163, 132, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["svu+++++++++"] = { type = "Model", model = "models/XQM/panel360.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "svu", pos = Vector(9.5, -2.6, 0.5), angle = Angle(0, 0, 0), size = Vector(0.029, 0.029, 0.029), color = Color(25, 33, 51, 255), surpresslightning = false, material = "models/props/cs_office/snowmana", skin = 0, bodygroup = {} },
		["svu++++++++"] = { type = "Model", model = "models/hunter/tubes/tube1x1x2.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "svu", pos = Vector(9.5, -2.6, 0.5), angle = Angle(90, 0, 0), size = Vector(0.037, 0.037, 0.009), color = Color(72, 67, 62, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["svu++++++++++++"] = { type = "Model", model = "models/props_junk/ibeam01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "svu", pos = Vector(2.5, -1, 0.5), angle = Angle(0, 0, 90), size = Vector(0.009, 0.09, 0.15), color = Color(128, 113, 94, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["svu+++++++++++"] = { type = "Model", model = "models/props_wasteland/laundry_washer001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "svu", pos = Vector(11, 0.6, 0.5), angle = Angle(92.337, -90, -90), size = Vector(0.017, 0.035, 0.14), color = Color(85, 113, 160, 255), surpresslightning = false, material = "models/props_pipes/pipeset_metal", skin = 0, bodygroup = {} }
	}
end

SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/cstrike/c_snip_sg550.mdl"
SWEP.WorldModel = "models/weapons/w_snip_sg550.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("weapons/sg550/sg550-1.wav")
SWEP.Primary.Damage = 86.5
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 1

SWEP.Primary.ClipSize = 6
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "357"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN

SWEP.ConeMax = 6.5
SWEP.ConeMin = 0

SWEP.IronSightsPos = Vector(11, -9, -2.2)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.WalkSpeed = SPEED_SLOWER

SWEP.Tier = 3

SWEP.FireAnimSpeed = 0.6

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.1, 1)

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound, 77, 75, 1)
	self:EmitSound("weapons/sg552/sg552-1.wav", 70, 185, 0.95, CHAN_AUTO)
end

function SWEP:IsScoped()
	return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.25 <= CurTime()
end

if CLIENT then
	SWEP.IronsightsMultiplier = 0.25

	function SWEP:GetViewModelPosition(pos, ang)
		if GAMEMODE.DisableScopes then return end

		if self:IsScoped() then
			return pos + ang:Up() * 256, ang
		end

		return BaseClass.GetViewModelPosition(self, pos, ang)
	end

	function SWEP:DrawHUDBackground()
		if GAMEMODE.DisableScopes then return end

		if self:IsScoped() then
			self:DrawRegularScope()
		end
	end
end
