AddCSLuaFile()

SWEP.PrintName = "'Colossus' Mass Driver"
SWEP.Description = "Projects rifle ammo rounds at extremely high velocity, penetrating through multiple targets."

if CLIENT then
	SWEP.Slot = 3
	SWEP.SlotPos = 0

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 55

	SWEP.HUD3DBone = "v_weapon.xm1014_Bolt"
	SWEP.HUD3DPos = Vector(-3.75, -1, -10)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.022

	SWEP.VElements = {
		["frontbit_inner"] = { type = "Model", model = "models/hunter/tubes/tube2x2x1.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "frontbit__behind_underbit", pos = Vector(0, 0, 0), angle = Angle(0, 141.695, 0), size = Vector(0.07, 0.07, 0.215), color = Color(255, 15, 15, 255), surpresslightning = false, material = "models/props_combine/masterinterface_disp", skin = 0, bodygroup = {} },
		["frontbit_behind"] = { type = "Model", model = "models/XQM/panel360.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "side", pos = Vector(6.011, 0.037, -3.062), angle = Angle(0, 0, 0), size = Vector(1.881, 0.136, 0.136), color = Color(170, 155, 149, 255), surpresslightning = false, material = "models/props_wasteland/tugboat02", skin = 0, bodygroup = {} },
		["top"] = { type = "Model", model = "models/props_wasteland/laundry_washer001a.mdl", bone = "v_weapon.xm1014_Parent", rel = "", pos = Vector(-0.262, -3.875, -25.164), angle = Angle(0, 100.58, 0), size = Vector(0.085, 0.085, 0.143), color = Color(170, 155, 149, 255), surpresslightning = false, material = "models/props_wasteland/tugboat02", skin = 0, bodygroup = {} },
		["frontbit_behind_2+"] = { type = "Model", model = "models/hunter/triangles/trapezium3x3x1a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "frontbit_behind+", pos = Vector(-0.461, 2, 0), angle = Angle(90, 90, 0), size = Vector(0.032, 0.092, 0.089), color = Color(165, 165, 165, 255), surpresslightning = false, material = "phoenix_storms/metalset_1-2", skin = 0, bodygroup = {} },
		["frontbit_behind_bottom"] = { type = "Model", model = "models/props_docks/dock03_pole01a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "frontbit_behind_2+", pos = Vector(0, 1.937, 3.118), angle = Angle(0, 0, 10), size = Vector(0.092, 0.092, 0.012), color = Color(165, 165, 165, 255), surpresslightning = false, material = "phoenix_storms/metalset_1-2", skin = 0, bodygroup = {} },
		["frontbit_behind+"] = { type = "Model", model = "models/XQM/panel360.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "frontbit_behind", pos = Vector(10.821, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 0.136, 0.136), color = Color(170, 155, 149, 255), surpresslightning = false, material = "models/props_wasteland/tugboat02", skin = 0, bodygroup = {} },
		["frontbit_behind_mp5"] = { type = "Model", model = "models/weapons/w_smg_mp5.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "frontbit_behind_2", pos = Vector(0, -2.057, -4.428), angle = Angle(0, 90, 0), size = Vector(0.977, 1.077, 0.354), color = Color(165, 165, 165, 255), surpresslightning = false, material = "phoenix_storms/metalset_1-2", skin = 0, bodygroup = {} },
		["frontbit_behind_2"] = { type = "Model", model = "models/hunter/triangles/trapezium3x3x1a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "frontbit_behind+", pos = Vector(0, -1.275, 0), angle = Angle(-90, 90, 0), size = Vector(0.032, 0.085, 0.048), color = Color(165, 165, 165, 255), surpresslightning = false, material = "phoenix_storms/metalset_1-2", skin = 0, bodygroup = {} },
		["frontbit_pipe"] = { type = "Model", model = "models/props_debris/rebar_smallnorm01c.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "side", pos = Vector(0, 0.239, 0.003), angle = Angle(21.548, 0, 0), size = Vector(0.649, 0.666, 0.319), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/metal_plate", skin = 0, bodygroup = {} },
		["side"] = { type = "Model", model = "models/props_wasteland/horizontalcoolingtank04.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "top", pos = Vector(-0.736, -2.576, 0.358), angle = Angle(90, -78, 0), size = Vector(0.028, 0.041, 0.048), color = Color(170, 155, 149, 255), surpresslightning = false, material = "models/props_wasteland/tugboat02", skin = 0, bodygroup = {} },
		["frontbit__behind_underbit"] = { type = "Model", model = "models/hunter/tubes/tube2x2x1b.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "frontbit_behind", pos = Vector(5.613, 0.043, 0), angle = Angle(-45, 90, 90), size = Vector(0.074, 0.074, 0.231), color = Color(170, 155, 149, 255), surpresslightning = false, material = "models/props_wasteland/tugboat02", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["frontbit_behind++"] = { type = "Model", model = "models/XQM/panel360.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "side", pos = Vector(-4.196, -0.069, -3.062), angle = Angle(0, 0, 0), size = Vector(1.205, 0.119, 0.119), color = Color(0, 0, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
		["frontbit_inner"] = { type = "Model", model = "models/hunter/tubes/tube2x2x1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "frontbit__behind_underbit", pos = Vector(0, 0, 0), angle = Angle(0, 141.695, 0), size = Vector(0.07, 0.07, 0.215), color = Color(255, 15, 15, 255), surpresslightning = false, material = "models/props_combine/masterinterface_disp", skin = 0, bodygroup = {} },
		["frontbit_behind"] = { type = "Model", model = "models/XQM/panel360.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "side", pos = Vector(6.011, 0.037, -3.062), angle = Angle(0, 0, 0), size = Vector(1.881, 0.136, 0.136), color = Color(170, 155, 149, 255), surpresslightning = false, material = "models/props_wasteland/tugboat02", skin = 0, bodygroup = {} },
		["top"] = { type = "Model", model = "models/props_wasteland/laundry_washer001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(20.954, 2.823, -8.398), angle = Angle(-78.195, 180, 0), size = Vector(0.085, 0.085, 0.143), color = Color(170, 155, 149, 255), surpresslightning = false, material = "models/props_wasteland/tugboat02", skin = 0, bodygroup = {} },
		["frontbit_pipe"] = { type = "Model", model = "models/props_debris/rebar_smallnorm01c.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "side", pos = Vector(0, 0.239, 0.003), angle = Angle(21.548, 0, 0), size = Vector(0.649, 0.666, 0.319), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/metal_plate", skin = 0, bodygroup = {} },
		["side"] = { type = "Model", model = "models/props_wasteland/horizontalcoolingtank04.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "top", pos = Vector(-0.736, -2.576, 0.358), angle = Angle(90, -78, 0), size = Vector(0.028, 0.041, 0.048), color = Color(170, 155, 149, 255), surpresslightning = false, material = "models/props_wasteland/tugboat02", skin = 0, bodygroup = {} },
		["frontbit_behind+"] = { type = "Model", model = "models/XQM/panel360.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "frontbit_behind", pos = Vector(10.821, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 0.136, 0.136), color = Color(170, 155, 149, 255), surpresslightning = false, material = "models/props_wasteland/tugboat02", skin = 0, bodygroup = {} },
		["frontbit__behind_underbit"] = { type = "Model", model = "models/hunter/tubes/tube2x2x1b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "frontbit_behind", pos = Vector(5.613, 0.043, 0), angle = Angle(-45, 90, 90), size = Vector(0.074, 0.074, 0.231), color = Color(170, 155, 149, 255), surpresslightning = false, material = "models/props_wasteland/tugboat02", skin = 0, bodygroup = {} },
		["frontbit_behind_2"] = { type = "Model", model = "models/hunter/triangles/trapezium3x3x1a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "frontbit_behind+", pos = Vector(0, -1.275, 0), angle = Angle(-90, 90, 0), size = Vector(0.032, 0.085, 0.048), color = Color(165, 165, 165, 255), surpresslightning = false, material = "phoenix_storms/metalset_1-2", skin = 0, bodygroup = {} },
		["frontbit_behind_2+"] = { type = "Model", model = "models/hunter/triangles/trapezium3x3x1a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "frontbit_behind+", pos = Vector(-0.461, 2, 0), angle = Angle(90, 90, 0), size = Vector(0.032, 0.092, 0.089), color = Color(165, 165, 165, 255), surpresslightning = false, material = "phoenix_storms/metalset_1-2", skin = 0, bodygroup = {} },
		["frontbit_behind_bottom"] = { type = "Model", model = "models/props_docks/dock03_pole01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "frontbit_behind_2+", pos = Vector(0, 1.937, 3.118), angle = Angle(0, 0, 10), size = Vector(0.092, 0.092, 0.012), color = Color(165, 165, 165, 255), surpresslightning = false, material = "phoenix_storms/metalset_1-2", skin = 0, bodygroup = {} },
		["frontbit_behind_mp5"] = { type = "Model", model = "models/weapons/w_smg_mp5.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "frontbit_behind_2", pos = Vector(0, -2.057, -4.428), angle = Angle(0, 90, 0), size = Vector(0.977, 1.077, 0.354), color = Color(165, 165, 165, 255), surpresslightning = false, material = "phoenix_storms/metalset_1-2", skin = 0, bodygroup = {} }
	}

	SWEP.ViewModelBoneMods = {
		["v_weapon.xm1014_Parent"] = { scale = Vector(1, 1, 1), pos = Vector(-5, -2, -3), angle = Angle(0, 0, 0) }
	}
end

SWEP.ShowWorldModel = false
SWEP.ShowViewModel = false

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "physgun"

SWEP.ViewModel = "models/weapons/cstrike/c_shot_xm1014.mdl"
SWEP.WorldModel = "models/weapons/w_shot_xm1014.mdl"
SWEP.UseHands = false

SWEP.Primary.Damage = 135
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 1
SWEP.HeadshotMulti = 1.75
SWEP.ReloadSound = Sound("ambient/machines/thumper_startup1.wav")

SWEP.Primary.ClipSize = 1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "357"
SWEP.Primary.DefaultClip = 9

SWEP.ConeMax = 0.25
SWEP.ConeMin = 0.25

SWEP.Recoil = 5

SWEP.IronSightsPos = Vector(5.015, -8, 2.52)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.WalkSpeed = SPEED_SLOWER

SWEP.FireAnimSpeed = 0.4

SWEP.TracerName = "tracer_colossus"

SWEP.ReloadSpeed = 1
SWEP.Tier = 5

SWEP.MaxStock = 2
SWEP.Pierces = 3

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.032)

function SWEP:ShootBullets(dmg, numbul, cone)
	local owner = self:GetOwner()
	self:SendWeaponAnimation()
	owner:DoAttackEvent()

	local dir = owner:GetAimVector()
	local dirang = dir:Angle()
	local start = owner:GetShootPos()

	dirang:RotateAroundAxis(dirang:Forward(), util.SharedRandom("bulletrotate1", 0, 360))
	dirang:RotateAroundAxis(dirang:Up(), util.SharedRandom("bulletangle1", -cone, cone))

	dir = dirang:Forward()
	local tr = owner:CompensatedPenetratingMeleeTrace(4092, 0.01, start, dir)
	local ent

	local dmgf = function(i) return dmg * (1 - 0.1 * i) end

	owner:LagCompensation(true)
	for i, trace in ipairs(tr) do
		if not trace.Hit then continue end
		if i > self.Pierces - 1 then break end

		ent = trace.Entity

		if ent and ent:IsValid() then
			owner:FireBulletsLua(trace.HitPos, dir, 0, numbul, dmgf(i-1), nil, self.Primary.KnockbackScale, "", self.BulletCallback, self.Primary.HullSize, nil, self.Primary.MaxDistance, nil, self)
		end
	end
	owner:FireBulletsLua(start, dir, cone, numbul, 0, nil, self.Primary.KnockbackScale, self.TracerName, self.BulletCallback, self.Primary.HullSize, nil, self.Primary.MaxDistance, nil, self)
	owner:LagCompensation(false)
end

function SWEP:SendWeaponAnimation()
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

	local owner = self:GetOwner()
	local vm = owner:GetViewModel()
	local speed = self.ReloadSpeed * self:GetReloadSpeedMultiplier()

	if vm:IsValid() then
		vm:SetPlaybackRate(0.25 * speed)
	end

	self:SetReloadFinish(CurTime() + 2.1 / speed)

	if IsFirstTimePredicted() then
		self:EmitSound("ambient/machines/thumper_startup1.wav", 70, 147, 1, CHAN_WEAPON + 21)
	end
end

function SWEP:MockReload()
	local speed = self.ReloadSpeed * self:GetReloadSpeedMultiplier()
	self:SetReloadFinish(CurTime() + 2.1 / speed)
end

function SWEP:Reload()
	local owner = self:GetOwner()
	if owner:IsHolding() then return end

	if self:GetIronsights() then
		self:SetIronsights(false)
	end

	if self:CanReload() then
		self:MockReload()
	end
end

function SWEP:Deploy()
	self.BaseClass.Deploy(self)

	if self:Clip1() <= 0 then
		self:MockReload()
	end

	return true
end

function SWEP:Think()
	self.BaseClass.Think(self)

	if self:Clip1() <= 0 and self:GetPrimaryAmmoCount() <= 0 then
		self:MockReload()
	end
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local effectdata = EffectData()
		effectdata:SetOrigin(tr.HitPos)
		effectdata:SetNormal(tr.HitNormal)
	util.Effect("hit_hunter", effectdata)
end

function SWEP:EmitReloadSound()

end

function SWEP:EmitReloadFinishSound()
end

function SWEP:EmitFireSound()
	self:EmitSound("weapons/m4a1/m4a1_unsil-1.wav", 76, 45, 0.35)
	self:EmitSound("weapons/zs_rail/rail.wav", 76, 100, 0.95, CHAN_WEAPON + 20)
end
