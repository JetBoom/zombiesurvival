AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = "'Innervator' Voltgun"
SWEP.Description = "An electric volt cannon."

if CLIENT then
	SWEP.Slot = 3
	SWEP.SlotPos = 0

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 49

	SWEP.HUD3DBone = "v_weapon.xm1014_Bolt"
	SWEP.HUD3DPos = Vector(-1.2, -1.1, 2)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.02

	SWEP.ViewModelBoneMods = {
		["v_weapon.xm1014_Shell"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.xm1014_Parent"] = { scale = Vector(1.2, 1.2, 1.2), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}

	SWEP.VElements = {
		["laser+++++"] = { type = "Model", model = "models/props_wasteland/laundry_washer001a.mdl", bone = "v_weapon.xm1014_Bolt", rel = "laser", pos = Vector(0.1, 3, -0.601), angle = Angle(180, 0, -91), size = Vector(0.019, 0.021, 0.3), color = Color(89, 89, 97, 255), surpresslightning = false, material = "models/props/de_nuke/coolingtower", skin = 0, bodygroup = {} },
		["laser+++++++++"] = { type = "Model", model = "models/props_lab/rotato.mdl", bone = "v_weapon.xm1014_Bolt", rel = "laser", pos = Vector(0.1, 4.9, 0.699), angle = Angle(180, 0, -90), size = Vector(0.449, 1, 0.1), color = Color(108, 118, 133, 255), surpresslightning = false, material = "models/props/de_train/fence_sheet01", skin = 0, bodygroup = {} },
		["laser++++"] = { type = "Model", model = "models/props_combine/combine_lock01.mdl", bone = "v_weapon.xm1014_Bolt", rel = "laser", pos = Vector(-0.301, -7.5, 0.5), angle = Angle(0, 180, -120.39), size = Vector(0.129, 0.1, 0.189), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["laser++++++++"] = { type = "Model", model = "models/props_lab/rotato.mdl", bone = "v_weapon.xm1014_Bolt", rel = "laser", pos = Vector(0.1, 9.869, 0.699), angle = Angle(180, 0, -90), size = Vector(0.5, 1, 0.1), color = Color(108, 118, 133, 255), surpresslightning = false, material = "models/props/de_train/fence_sheet01", skin = 0, bodygroup = {} },
		["laser+++++++"] = { type = "Model", model = "models/props_lab/rotato.mdl", bone = "v_weapon.xm1014_Bolt", rel = "laser", pos = Vector(0.1, -4.901, 0.699), angle = Angle(180, 0, -90), size = Vector(0.349, 1, 0.4), color = Color(108, 118, 133, 255), surpresslightning = false, material = "models/props/de_train/fence_sheet01", skin = 0, bodygroup = {} },
		["laser++"] = { type = "Model", model = "models/props_combine/combine_generator01.mdl", bone = "v_weapon.xm1014_Bolt", rel = "laser", pos = Vector(-1, 15, 2), angle = Angle(0, 180, 90), size = Vector(0.079, 0.039, 0.119), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["laser"] = { type = "Model", model = "models/props_pipes/pipe02_straight01_long.mdl", bone = "v_weapon.xm1014_Bolt", rel = "", pos = Vector(0, -1.601, -2.401), angle = Angle(0, 0, 90), size = Vector(0.2, 0.2, 0.2), color = Color(0, 255, 186, 255), surpresslightning = false, material = "models/props_lab/eyescanner_disp", skin = 0, bodygroup = {} },
		["laser+++"] = { type = "Model", model = "models/props_combine/combine_generator01.mdl", bone = "v_weapon.xm1014_Bolt", rel = "laser", pos = Vector(-0.22, 16, -0.5), angle = Angle(180, 0, 90), size = Vector(0.029, 0.059, 0.15), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["laser+"] = { type = "Model", model = "models/props_pipes/pipe02_straight01_long.mdl", bone = "v_weapon.xm1014_Bolt", rel = "laser", pos = Vector(0, 16.104, 0), angle = Angle(0, 0, 0), size = Vector(0.25, 0.25, 0.2), color = Color(0, 255, 186, 255), surpresslightning = false, material = "models/props_lab/eyescanner_disp", skin = 0, bodygroup = {} },
		["laser++++++"] = { type = "Model", model = "models/props_wasteland/laundry_washer001a.mdl", bone = "v_weapon.xm1014_Bolt", rel = "laser", pos = Vector(0.1, 3, 2.5), angle = Angle(180, 0, -90), size = Vector(0.029, 0.029, 0.449), color = Color(89, 89, 97, 255), surpresslightning = false, material = "models/props/de_nuke/coolingtower", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["laser+++++"] = { type = "Model", model = "models/props_wasteland/laundry_washer001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "laser", pos = Vector(0.1, 3, -0.601), angle = Angle(180, 0, -91), size = Vector(0.019, 0.021, 0.3), color = Color(89, 89, 97, 255), surpresslightning = false, material = "models/props/de_nuke/coolingtower", skin = 0, bodygroup = {} },
		["laser++++++++"] = { type = "Model", model = "models/props_lab/rotato.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "laser", pos = Vector(0.1, 9.869, 0.699), angle = Angle(180, 0, -90), size = Vector(0.5, 1, 0.1), color = Color(108, 118, 133, 255), surpresslightning = false, material = "models/props/de_train/fence_sheet01", skin = 0, bodygroup = {} },
		["laser+++++++++"] = { type = "Model", model = "models/props_lab/rotato.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "laser", pos = Vector(0.1, 4.9, 0.699), angle = Angle(180, 0, -90), size = Vector(0.449, 1, 0.1), color = Color(108, 118, 133, 255), surpresslightning = false, material = "models/props/de_train/fence_sheet01", skin = 0, bodygroup = {} },
		["laser++++"] = { type = "Model", model = "models/props_combine/combine_lock01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "laser", pos = Vector(-0.301, -7.5, 0.5), angle = Angle(0, 180, -120.39), size = Vector(0.129, 0.1, 0.189), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["laser+++++++"] = { type = "Model", model = "models/props_lab/rotato.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "laser", pos = Vector(0.009, -4.901, 0.699), angle = Angle(180, 0, -90), size = Vector(0.349, 1, 0.4), color = Color(108, 118, 133, 255), surpresslightning = false, material = "models/props/de_train/fence_sheet01", skin = 0, bodygroup = {} },
		["laser+++"] = { type = "Model", model = "models/props_combine/combine_generator01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "laser", pos = Vector(-0.22, 16, -0.5), angle = Angle(180, 0, 90), size = Vector(0.029, 0.059, 0.15), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["laser+"] = { type = "Model", model = "models/props_pipes/pipe02_straight01_long.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "laser", pos = Vector(0, 16.104, 0), angle = Angle(0, 0, 0), size = Vector(0.25, 0.25, 0.2), color = Color(0, 255, 186, 255), surpresslightning = false, material = "models/props_lab/eyescanner_disp", skin = 0, bodygroup = {} },
		["laser++"] = { type = "Model", model = "models/props_combine/combine_generator01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "laser", pos = Vector(-1, 15, 2), angle = Angle(0, 180, 90), size = Vector(0.079, 0.039, 0.119), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["laser"] = { type = "Model", model = "models/props_pipes/pipe02_straight01_long.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(8, 1, -5), angle = Angle(0, 90, 10), size = Vector(0.2, 0.2, 0.2), color = Color(0, 255, 186, 255), surpresslightning = false, material = "models/props_lab/eyescanner_disp", skin = 0, bodygroup = {} },
		["laser++++++"] = { type = "Model", model = "models/props_wasteland/laundry_washer001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "laser", pos = Vector(0.1, 3, 2.5), angle = Angle(180, 0, -90), size = Vector(0.029, 0.029, 0.449), color = Color(89, 89, 97, 255), surpresslightning = false, material = "models/props/de_nuke/coolingtower", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "shotgun"

SWEP.ViewModel = "models/weapons/cstrike/c_shot_xm1014.mdl"
SWEP.WorldModel = "models/weapons/w_shot_xm1014.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("weapons/zs_inner/innershot.ogg")
SWEP.ReloadSound = Sound("ambient/machines/thumper_startup1.wav")
SWEP.Primary.Damage = 11
SWEP.Primary.NumShots = 5
SWEP.Primary.Delay = 1.6
SWEP.Primary.MaxDistance = 288
SWEP.Primary.BurstShots = 5

SWEP.Primary.ClipSize = 30
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "pulse"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ReloadSpeed = 0.33

SWEP.RequiredClip = 6

SWEP.ConeMax = 6.5
SWEP.ConeMin = 5

SWEP.WalkSpeed = SPEED_SLOWER

SWEP.Tier = 4

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.8125)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.625)

SWEP.TracerName = "tracer_volt"

function SWEP:EmitFireSound()
	self:EmitSound("weapons/m4a1/m4a1_unsil-1.wav", 85, 130, 0.65)
	self:EmitSound("weapons/zs_inner/innershot.ogg", 85, 128, 0.85, CHAN_WEAPON + 20)
end

function SWEP:SendReloadAnimation()
	self:SendWeaponAnim(ACT_VM_DRAW)
end

function SWEP:SecondaryAttack()
end

function SWEP:EmitReloadSound()
	if IsFirstTimePredicted() then
		self:EmitSound("npc/scanner/combat_scan1.wav", 70, 15, 0.9, CHAN_WEAPON + 21)
		self:EmitSound("items/battery_pickup.wav", 70, 47, 0.85, CHAN_WEAPON + 22)
	end
end

function SWEP:EmitReloadFinishSound()
	if IsFirstTimePredicted() then
		self:EmitSound("npc/scanner/combat_scan2.wav", 70, 135)
	end
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
	self:EmitFireSound()

	self:TakeAmmo()
	self:SetNextShot(CurTime())
	self:SetShotsLeft(self.Primary.BurstShots)

	self.IdleAnimation = CurTime() + self:SequenceDuration()
end

function SWEP:Think()
	BaseClass.Think(self)

	local shotsleft = self:GetShotsLeft()
	if shotsleft > 0 and CurTime() >= self:GetNextShot() then
		self:SetShotsLeft(shotsleft - 1)
		self:SetNextShot(CurTime() + self:GetFireDelay()/12)

		if self:GetReloadFinish() == 0 then
			self:EmitFireSound()
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

if not CLIENT then return end

local ghostlerp = 0
function SWEP:CalcViewModelView(vm, oldpos, oldang, pos, ang)
	if self:GetOwner():GetBarricadeGhosting() or self:GetReloadFinish() > 0 then
		ghostlerp = math.min(1, ghostlerp + FrameTime() * 2)
	elseif ghostlerp > 0 then
		ghostlerp = math.max(0, ghostlerp - FrameTime() * 2.5)
	end

	if ghostlerp > 0 then
		ang:RotateAroundAxis(ang:Right(), -35 * ghostlerp)
	end

	return pos, ang
end
