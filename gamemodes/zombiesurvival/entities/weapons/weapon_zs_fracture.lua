AddCSLuaFile()

SWEP.Base = "weapon_zs_baseshotgun"
DEFINE_BASECLASS("weapon_zs_baseshotgun")

SWEP.PrintName = "'Fracture' Shotgun"
SWEP.Description = "A pump shotgun that shoots in a line spread."

if CLIENT then
	SWEP.ViewModelFlip = false

	SWEP.HUD3DBone = "v_weapon.M3_PARENT"
	SWEP.HUD3DPos = Vector(-1, -4, -3)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.015

	SWEP.VElements = {
		["fracture++++++"] = { type = "Model", model = "models/props_c17/trappropeller_lever.mdl", bone = "v_weapon.M3_PARENT", rel = "fracture", pos = Vector(10.5, 0, -2), angle = Angle(0, -90, -33.896), size = Vector(1, 0.6, 1.5), color = Color(87, 99, 118, 255), surpresslightning = false, material = "models/props_pipes/guttermetal01a", skin = 0, bodygroup = {} },
		["fracture++++"] = { type = "Model", model = "models/props_c17/utilityconnecter003.mdl", bone = "v_weapon.M3_PARENT", rel = "fracture", pos = Vector(4.675, 0, -0.201), angle = Angle(0, -90, 0), size = Vector(0.625, 0.625, 0.625), color = Color(60, 67, 90, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
		["fracture+++++"] = { type = "Model", model = "models/props_c17/utilityconnecter002.mdl", bone = "v_weapon.M3_PARENT", rel = "fracture", pos = Vector(8, 0, -2.597), angle = Angle(0, -90, 180), size = Vector(0.2, 0.2, 0.2), color = Color(60, 67, 90, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
		["fracture++"] = { type = "Model", model = "models/props_c17/factorymachine01.mdl", bone = "v_weapon.M3_PARENT", rel = "fracture", pos = Vector(-5.715, 0, -1.4), angle = Angle(180, -90, 0), size = Vector(0.025, 0.025, 0.025), color = Color(49, 54, 79, 255), surpresslightning = false, material = "models/props_pipes/guttermetal01a", skin = 0, bodygroup = {} },
		["fracture+"] = { type = "Model", model = "models/props_c17/factorymachine01.mdl", bone = "v_weapon.M3_PARENT", rel = "fracture", pos = Vector(-5.715, 0, 0), angle = Angle(0, -90, 0), size = Vector(0.025, 0.025, 0.025), color = Color(49, 54, 79, 255), surpresslightning = false, material = "models/props_pipes/guttermetal01a", skin = 0, bodygroup = {} },
		["fracture"] = { type = "Model", model = "models/props_wasteland/laundry_washer003.mdl", bone = "v_weapon.M3_PARENT", rel = "", pos = Vector(0, -4.5, -10.91), angle = Angle(90, -90, 0), size = Vector(0.15, 0.035, 0.035), color = Color(59, 70, 103, 255), surpresslightning = false, material = "models/props_pipes/guttermetal01a", skin = 0, bodygroup = {} },
		["fracture+++"] = { type = "Model", model = "models/props_wasteland/laundry_washer001a.mdl", bone = "v_weapon.M3_PARENT", rel = "fracture", pos = Vector(-1.5, 0, -1), angle = Angle(0, -90, -90), size = Vector(0.035, 0.029, 0.25), color = Color(49, 57, 74, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["fracture+++"] = { type = "Model", model = "models/props_wasteland/laundry_washer001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "fracture", pos = Vector(-1.5, 0, -1), angle = Angle(0, -90, -90), size = Vector(0.035, 0.029, 0.25), color = Color(49, 57, 74, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
		["fracture++++"] = { type = "Model", model = "models/props_c17/utilityconnecter003.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "fracture", pos = Vector(4.675, 0, -0.201), angle = Angle(0, -90, 0), size = Vector(0.625, 0.625, 0.625), color = Color(60, 67, 90, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
		["fracture"] = { type = "Model", model = "models/props_wasteland/laundry_washer003.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(16, 1, -5.715), angle = Angle(176.494, 0, 0), size = Vector(0.15, 0.035, 0.035), color = Color(59, 70, 103, 255), surpresslightning = false, material = "models/props_pipes/guttermetal01a", skin = 0, bodygroup = {} },
		["fracture+++++"] = { type = "Model", model = "models/props_c17/utilityconnecter002.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "fracture", pos = Vector(8, 0, -2.597), angle = Angle(0, -90, 180), size = Vector(0.2, 0.2, 0.2), color = Color(60, 67, 90, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
		["fracture+"] = { type = "Model", model = "models/props_c17/factorymachine01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "fracture", pos = Vector(-5.715, 0, 0), angle = Angle(0, -90, 0), size = Vector(0.025, 0.025, 0.025), color = Color(49, 54, 79, 255), surpresslightning = false, material = "models/props_pipes/guttermetal01a", skin = 0, bodygroup = {} },
		["fracture++++++"] = { type = "Model", model = "models/props_c17/trappropeller_lever.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "fracture", pos = Vector(10.5, 0, -2), angle = Angle(0, -90, -33.896), size = Vector(1, 0.6, 1.5), color = Color(87, 99, 118, 255), surpresslightning = false, material = "models/props_pipes/guttermetal01a", skin = 0, bodygroup = {} },
		["fracture++"] = { type = "Model", model = "models/props_c17/factorymachine01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "fracture", pos = Vector(-5.715, 0, -1.4), angle = Angle(180, -90, 0), size = Vector(0.025, 0.025, 0.025), color = Color(49, 54, 79, 255), surpresslightning = false, material = "models/props_pipes/guttermetal01a", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_baseshotgun"

SWEP.HoldType = "shotgun"

SWEP.ViewModel = "models/weapons/cstrike/c_shot_m3super90.mdl"
SWEP.WorldModel = "models/weapons/w_shot_m3super90.mdl"
SWEP.UseHands = true

SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false

SWEP.ReloadDelay = 0.45

SWEP.Primary.Sound = Sound("Weapon_M3.Single")
SWEP.Primary.Damage = 13
SWEP.Primary.NumShots = 7
SWEP.Primary.Delay = 0.9

SWEP.Primary.ClipSize = 6
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "buckshot"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 7.55
SWEP.ConeMin = 5.25

SWEP.FireAnimSpeed = 1
SWEP.WalkSpeed = SPEED_SLOWER

SWEP.Tier = 2

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_SHOT_COUNT, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.1, 1)

function SWEP:PrimaryAttack()
	self.AttackContext = true
	BaseClass.PrimaryAttack(self)
end

function SWEP:SecondaryAttack()
	self.AttackContext = nil
	BaseClass.PrimaryAttack(self)
end

function SWEP:EmitFireSound()
	self:EmitSound("weapons/m3/m3-1.wav", 75, math.random(134, 136), 0.7)
	self:EmitSound("weapons/xm1014/xm1014-1.wav", 75, math.random(172, 180), 0.5, CHAN_WEAPON + 20)
end

function SWEP:ShootBullets(dmg, numbul, cone)
	local owner = self:GetOwner()
	local sprd = (self.AttackContext and 2 or 2.75)*cone/6
	local recp = self.AttackContext and 2 or 1.25

	self:SendWeaponAnimation()
	owner:DoAttackEvent()

	owner:LagCompensation(true)
	for i = 1, numbul do
		local angle = owner:GetAimVector():Angle()
		angle:RotateAroundAxis(self.AttackContext and angle:Up() or angle:Right(), (i - math.ceil(self.Primary.NumShots/2)) * sprd)

		owner:FireBulletsLua(owner:GetShootPos(), angle:Forward(), cone/recp, 1, dmg, nil, self.Primary.KnockbackScale, self.TracerName, self.BulletCallback, self.Primary.HullSize, nil, self.Primary.MaxDistance, nil, self)
	end
	owner:LagCompensation(false)
end
