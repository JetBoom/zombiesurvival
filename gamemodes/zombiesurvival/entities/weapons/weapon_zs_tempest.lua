AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = "'Tempest' Burst Pistol"
SWEP.Description = "Fires in bursts and uses ammunition extremely quickly."
SWEP.Slot = 1
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFOV = 60
	SWEP.ViewModelFlip = false

	SWEP.HUD3DBone = "v_weapon.FIVESEVEN_PARENT"
	SWEP.HUD3DPos = Vector(-1, -2.5, -1)
	SWEP.HUD3DAng = Angle(0, 0, 0)

	SWEP.VElements = {
		["top2"] = { type = "Model", model = "models/combine_turrets/ground_turret.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "top+", pos = Vector(0.1, 0, 1.5), angle = Angle(-90, 0, 0), size = Vector(0.2, 0.079, 0.1), color = Color(208, 229, 255, 255), surpresslightning = false, material = "models/weapons/v_models/pist_fiveseven/pist_fiveseven", skin = 0, bodygroup = {} },
		["bottom"] = { type = "Model", model = "models/props_combine/combinethumper001a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "top+", pos = Vector(0.699, 0, -2), angle = Angle(0, 90, 0), size = Vector(0.009, 0.014, 0.019), color = Color(171, 191, 204, 255), surpresslightning = false, material = "models/weapons/v_models/pist_fiveseven/pist_fiveseven", skin = 0, bodygroup = {} },
		["top"] = { type = "Model", model = "models/props_lab/hev_case.mdl", bone = "v_weapon.FIVESEVEN_SLIDE", rel = "", pos = Vector(0, 7.989, -0.28), angle = Angle(-90, 90, 0), size = Vector(0.029, 0.028, 0.104), color = Color(49, 55, 62, 255), surpresslightning = false, material = "phoenix_storms/concrete2", skin = 0, bodygroup = {} },
		["top+"] = { type = "Model", model = "models/props_lab/hev_case.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "", pos = Vector(0, -2, -9.429), angle = Angle(0, -90, 0), size = Vector(0.025, 0.035, 0.108), color = Color(49, 52, 55, 255), surpresslightning = false, material = "phoenix_storms/concrete2", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["top2"] = { type = "Model", model = "models/combine_turrets/ground_turret.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "top+", pos = Vector(0.1, 0, 1.5), angle = Angle(-90, 0, 0), size = Vector(0.2, 0.079, 0.1), color = Color(208, 229, 255, 255), surpresslightning = false, material = "models/weapons/v_models/pist_fiveseven/pist_fiveseven", skin = 0, bodygroup = {} },
		["bottom"] = { type = "Model", model = "models/props_combine/combinethumper001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "top+", pos = Vector(0.699, 0, -2), angle = Angle(0, 90, 0), size = Vector(0.009, 0.014, 0.019), color = Color(171, 191, 204, 255), surpresslightning = false, material = "models/weapons/v_models/pist_fiveseven/pist_fiveseven", skin = 0, bodygroup = {} },
		["top+"] = { type = "Model", model = "models/props_lab/hev_case.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(10.5, 2.2, -2.5), angle = Angle(90, 174, 180), size = Vector(0.025, 0.035, 0.108), color = Color(49, 52, 55, 255), surpresslightning = false, material = "phoenix_storms/concrete2", skin = 0, bodygroup = {} },
		["top"] = { type = "Model", model = "models/props_lab/hev_case.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "top+", pos = Vector(-2, 0, -0.101), angle = Angle(180, 0, 180), size = Vector(0.029, 0.028, 0.104), color = Color(49, 55, 62, 255), surpresslightning = false, material = "phoenix_storms/concrete2", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "pistol"

SWEP.ViewModel = "models/weapons/cstrike/c_pist_fiveseven.mdl"
SWEP.WorldModel = "models/weapons/w_pist_fiveseven.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("weapons/ar2/npc_ar2_altfire.wav")
SWEP.Primary.Damage = 37
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.41
SWEP.Primary.BurstShots = 3

SWEP.Primary.ClipSize = 21
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "pistol"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 3.6
SWEP.ConeMin = 1.8

SWEP.Tier = 3
SWEP.FireAnimSpeed = 1.5

SWEP.ReloadSpeed = 1.05

SWEP.IronSightsPos = Vector(-5.95, 0, 2.5)

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.37, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.25, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.03, 1)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, "'Tempest' Automatic Pistol", "Makes the pistol fully automatic at the cost of damage", function(wept)
	wept.Primary.Damage = wept.Primary.Damage * 0.9
	wept.Primary.Delay = wept.Primary.Delay * 0.375
	wept.PrimaryAttack = function(self, ent) BaseClass.PrimaryAttack(self) end
end)
local branch = GAMEMODE:AddNewRemantleBranch(SWEP, 2, "'Cosmos' Pulse Blaster", "Turns the Tempest in a burst pulse ammo blaster", function(wept)
	wept.Primary.Damage = wept.Primary.Damage * 0.55
	wept.Primary.Delay = wept.Primary.Delay * 1.5
	wept.ConeMin = wept.ConeMin * 0.75

	wept.MaxDistance = 512
	wept.TracerName = "tracer_cosmos"
	wept.Primary.Ammo = "pulse"

	wept.EmitFireSound = function(self)
		self:EmitSound("weapons/stunstick/alyx_stunner2.wav", 70, 155, 0.65, CHAN_AUTO)
		self:EmitSound("weapons/stunstick/alyx_stunner2.wav", 70, 157, 0.65, CHAN_WEAPON + 20)
	end

	wept.EmitReloadFinishSound = function(self)
		if IsFirstTimePredicted() then
			self:EmitSound("items/battery_pickup.wav", 70, 156, 0.85, CHAN_AUTO)
		end
	end

	wept.VElements = {
		["lucasarts+"] = { type = "Model", model = "models/items/combine_rifle_cartridge01.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "", pos = Vector(0, -2, -5), angle = Angle(0, 90, 0), size = Vector(0.449, 0.899, 1.08), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["lucasarts++"] = { type = "Model", model = "models/props_lab/reciever01a.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "lucasarts+", pos = Vector(0.5, 0, 1.899), angle = Angle(0, 0, 90), size = Vector(0.079, 0.37, 0.2), color = Color(112, 125, 133, 255), surpresslightning = false, material = "models/props_lab/ravendoor_sheet", skin = 0, bodygroup = {} },
		["lucasarts+++"] = { type = "Model", model = "models/items/car_battery01.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "lucasarts+", pos = Vector(1, 0, 2), angle = Angle(0, 90, 90), size = Vector(0.109, 0.5, 0.119), color = Color(204, 255, 255, 255), surpresslightning = false, material = "models/props_building_details/courtyard_template001c_bars_dark", skin = 0, bodygroup = {} },
		["lucasarts++++"] = { type = "Model", model = "models/items/grenadeammo.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "lucasarts+", pos = Vector(1, 0, -7), angle = Angle(0, 90, 0), size = Vector(0.4, 0.4, 1.2), color = Color(92, 110, 135, 255), surpresslightning = false, material = "models/props_lab/ravendoor_sheet", skin = 0, bodygroup = {} },
		["lucasarts"] = { type = "Model", model = "models/props_pipes/valve001.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "lucasarts+", pos = Vector(-2, 0, -2), angle = Angle(0, 90, 0), size = Vector(0.1, 0.2, 0.05), color = Color(90, 102, 123, 255), surpresslightning = false, material = "models/props_interiors/radiator01c", skin = 0, bodygroup = {} }
	}

	wept.WElements = {
		["lucasarts+"] = { type = "Model", model = "models/items/combine_rifle_cartridge01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 1.5, -3), angle = Angle(-90, -5, 180), size = Vector(0.449, 0.899, 1.08), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["lucasarts++"] = { type = "Model", model = "models/props_lab/reciever01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "lucasarts+", pos = Vector(0.5, 0, 1.899), angle = Angle(0, 0, 90), size = Vector(0.079, 0.37, 0.2), color = Color(112, 125, 133, 255), surpresslightning = false, material = "models/props_lab/ravendoor_sheet", skin = 0, bodygroup = {} },
		["lucasarts+++"] = { type = "Model", model = "models/items/car_battery01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "lucasarts+", pos = Vector(1, 0, 2), angle = Angle(0, 90, 90), size = Vector(0.109, 0.5, 0.119), color = Color(204, 255, 255, 255), surpresslightning = false, material = "models/props_building_details/courtyard_template001c_bars_dark", skin = 0, bodygroup = {} },
		["lucasarts++++"] = { type = "Model", model = "models/items/grenadeammo.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "lucasarts+", pos = Vector(1, 0, -7), angle = Angle(0, 90, 0), size = Vector(0.4, 0.4, 1.2), color = Color(92, 110, 135, 255), surpresslightning = false, material = "models/props_lab/ravendoor_sheet", skin = 0, bodygroup = {} },
		["lucasarts"] = { type = "Model", model = "models/props_pipes/valve001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "lucasarts+", pos = Vector(-2, 0, -2), angle = Angle(0, 90, 0), size = Vector(0.1, 0.2, 0.05), color = Color(90, 102, 123, 255), surpresslightning = false, material = "models/props_interiors/radiator01c", skin = 0, bodygroup = {} }
	}
end)
branch.Colors = {Color(100, 130, 180), Color(90, 120, 170), Color(70, 100, 160)}
branch.NewNames = {"Jovial", "Orbital", "Celestial"}
branch.Killicon = "weapon_zs_cosmos"

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
	self:EmitFireSound()

	self:SetNextShot(CurTime())
	self:SetShotsLeft(self.Primary.BurstShots)

	self.IdleAnimation = CurTime() + self:SequenceDuration()
end

function SWEP:Think()
	BaseClass.Think(self)

	local shotsleft = self:GetShotsLeft()
	if shotsleft > 0 and CurTime() >= self:GetNextShot() then
		self:SetShotsLeft(shotsleft - 1)
		self:SetNextShot(CurTime() + self:GetFireDelay()/6)

		if self:Clip1() > 0 and self:GetReloadFinish() == 0 then
			self:EmitFireSound()
			self:TakeAmmo()
			self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())

			self.IdleAnimation = CurTime() + self:SequenceDuration()
		else
			self:SetShotsLeft(0)
		end
	end
end

function SWEP:SetNextShot(nextshot)
	self:SetDTFloat(5, nextshot)
end

function SWEP:GetNextShot()
	return self:GetDTFloat(5)
end

function SWEP:SetShotsLeft(shotsleft)
	self:SetDTInt(1, shotsleft)
end

function SWEP:GetShotsLeft()
	return self:GetDTInt(1)
end
