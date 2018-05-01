AddCSLuaFile()

SWEP.PrintName = "'Proliferator' SMG"
SWEP.Description = "Hold right click to use the Storm firing mode: fire rate is reduced to 60% but a wider fan of bullets are fired."
SWEP.Slot = 2
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 50

	SWEP.HUD3DBone = "v_weapon.mac10_bolt"
	SWEP.HUD3DPos = Vector(-2.2, 1, 0)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.015

	SWEP.VElements = {
		["top2"] = { type = "Model", model = "models/props_c17/playground_teetertoter_stan.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "top", pos = Vector(0, -1.201, -0.602), angle = Angle(180, 0, 0), size = Vector(0.057, 0.611, 0.068), color = Color(170, 130, 120, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["barrel"] = { type = "Model", model = "models/props_c17/TrapPropeller_Engine.mdl", bone = "v_weapon.mac10_parent", rel = "", pos = Vector(-0.064, -3.6, -2), angle = Angle(180, -90, 0), size = Vector(0.167, 0.119, 0.442), color = Color(72, 85, 100, 255), surpresslightning = false, material = "models/props_pipes/guttermetal01a", skin = 0, bodygroup = {} },
		["top"] = { type = "Model", model = "models/props_combine/combine_train02b.mdl", bone = "v_weapon.mac10_parent", rel = "", pos = Vector(-0.178, -5.091, -1.982), angle = Angle(180, 0, 90), size = Vector(0.021, 0.02, 0.009), color = Color(72, 85, 100, 255), surpresslightning = false, material = "models/props_pipes/guttermetal01a", skin = 0, bodygroup = {} },
		["laser+"] = { type = "Model", model = "models/hunter/blocks/cube075x1x025.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "top2", pos = Vector(0, 0, 0.843), angle = Angle(90, 90, 0), size = Vector(0.023, 0.037, 0.021), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_smg1/texture5", skin = 0, bodygroup = {} },
		["fracture"] = { type = "Model", model = "models/props_wasteland/laundry_washer003.mdl", bone = "v_weapon.M3_PARENT", rel = "top2", pos = Vector(0, -0.5, -1.1), angle = Angle(0, -90, 0), size = Vector(0.17, 0.045, 0.045), color = Color(65, 70, 75, 255), surpresslightning = false, material = "models/props_pipes/guttermetal01a", skin = 0, bodygroup = {} },
		["fracture+++++"] = { type = "Model", model = "models/props_c17/utilityconnecter002.mdl", bone = "v_weapon.M3_PARENT", rel = "fracture", pos = Vector(-5, 0, -2), angle = Angle(0, -90, 180), size = Vector(0.2, 0.2, 0.2), color = Color(70, 87, 100, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
		["laser"] = { type = "Model", model = "models/hunter/blocks/cube075x1x025.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "top2", pos = Vector(0, 0, 0.577), angle = Angle(-90, 90, 0), size = Vector(0.023, 0.037, 0.021), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_smg1/texture5", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["top2"] = { type = "Model", model = "models/props_c17/playground_teetertoter_stan.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "barrel", pos = Vector(1.906, 0.238, 3.084), angle = Angle(0, 90, 90), size = Vector(0.057, 0.611, 0.068), color = Color(170, 170, 160, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["barrel"] = { type = "Model", model = "models/props_c17/TrapPropeller_Engine.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.876, 0.9, -3.771), angle = Angle(-91.623, -4.99, 0), size = Vector(0.167, 0.119, 0.442), color = Color(72, 85, 100, 255), surpresslightning = false, material = "models/props_pipes/guttermetal01a", skin = 0, bodygroup = {} },
		["top"] = { type = "Model", model = "models/props_combine/combine_train02b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "barrel", pos = Vector(1.287, 0.241, 2.313), angle = Angle(0, -90, 90), size = Vector(0.021, 0.02, 0.009), color = Color(72, 85, 100, 255), surpresslightning = false, material = "models/props_pipes/guttermetal01a", skin = 0, bodygroup = {} },
		["laser+"] = { type = "Model", model = "models/hunter/blocks/cube075x1x025.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "top2", pos = Vector(0, 0, 0.843), angle = Angle(90, 90, 0), size = Vector(0.023, 0.037, 0.021), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_smg1/texture5", skin = 0, bodygroup = {} },
		["fracture"] = { type = "Model", model = "models/props_wasteland/laundry_washer003.mdl", bone = "v_weapon.M3_PARENT", rel = "top2", pos = Vector(0, -0.5, -1.1), angle = Angle(0, -90, 0), size = Vector(0.17, 0.045, 0.045), color = Color(65, 70, 75, 255), surpresslightning = false, material = "models/props_pipes/guttermetal01a", skin = 0, bodygroup = {} },
		["fracture+++++"] = { type = "Model", model = "models/props_c17/utilityconnecter002.mdl", bone = "v_weapon.M3_PARENT", rel = "fracture", pos = Vector(-5, 0, -2), angle = Angle(0, -90, 180), size = Vector(0.2, 0.2, 0.2), color = Color(70, 87, 100, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
		["laser"] = { type = "Model", model = "models/hunter/blocks/cube075x1x025.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "top2", pos = Vector(0, 0, 0.577), angle = Angle(-90, 90, 0), size = Vector(0.023, 0.037, 0.021), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_smg1/texture5", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "pistol"

SWEP.ViewModel = "models/weapons/cstrike/c_smg_mac10.mdl"
SWEP.WorldModel = "models/weapons/w_smg_mac10.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("weapons/zs_scar/scar_fire1.ogg")
SWEP.Primary.Damage = 7.2
SWEP.Primary.NumShots = 3
SWEP.Primary.Delay = 0.15

SWEP.Primary.ClipSize = 28
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 6.3
SWEP.ConeMin = 3.5

SWEP.ReloadSpeed = 0.95

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SMG1

SWEP.WalkSpeed = SPEED_NORMAL

SWEP.Tier = 3

SWEP.FireAnimSpeed = 1.7

SWEP.IronSightsPos = Vector(-7, 15, 0)
SWEP.IronSightsAng = Vector(3, -3, -10)

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.9)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.5)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.01, 1)

function SWEP:EmitFireSound()
	self:EmitSound("weapons/sg552/sg552-1.wav", 75, 195, 0.45, CHAN_WEAPON + 20)
	self:EmitSound(self.Primary.Sound, 75, 199, 0.45, CHAN_WEAPON + 21)
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	local ironsights = self:GetIronsights()

	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay() * (ironsights and 1.2 or 1))

	self:EmitFireSound()
	self:TakeAmmo()
	self:ShootBullets(self.Primary.Damage * (ironsights and 0.6 or 1), ironsights and 5 or 3, self:GetCone())
	self.IdleAnimation = CurTime() + self:SequenceDuration()
end

function SWEP:SetIronsights(b)
	if self:GetIronsights() ~= b then
		if b then
			self:EmitSound("npc/scanner/scanner_scan4.wav", 40)
		else
			self:EmitSound("npc/scanner/scanner_scan2.wav", 40)
		end
	end

	self.BaseClass.SetIronsights(self, b)
end

function SWEP:CanPrimaryAttack()
	if self:GetIronsights() and self:Clip1() == 1 then
		self:SetIronsights(false)
	end

	return self.BaseClass.CanPrimaryAttack(self)
end

function SWEP:SecondaryAttack()
	if self:GetNextSecondaryFire() <= CurTime() and not self:GetOwner():IsHolding() and self:GetReloadFinish() == 0 then
		self:SetIronsights(true)
	end
end

function SWEP:ShootBullets(dmg, numbul, cone)
	local owner = self:GetOwner()
	local ironsights = self:GetIronsights()
	local sprd = (ironsights and 2 or 2.75)*cone/6
	local recp = ironsights and 2 or 1.25

	self:SendWeaponAnimation()
	owner:DoAttackEvent()

	owner:LagCompensation(true)
	for i = 1, numbul do
		local angle = owner:GetAimVector():Angle()
		angle:RotateAroundAxis(angle:Up(), (i - math.ceil((ironsights and 5 or 3)/2)) * sprd)

		owner:FireBulletsLua(owner:GetShootPos(), angle:Forward(), cone/recp, 1, dmg, nil, self.Primary.KnockbackScale, self.TracerName, self.BulletCallback, self.Primary.HullSize, nil, self.Primary.MaxDistance, nil, self)
	end
	owner:LagCompensation(false)
end

util.PrecacheSound("npc/scanner/scanner_scan4.wav")
util.PrecacheSound("npc/scanner/scanner_scan2.wav")
