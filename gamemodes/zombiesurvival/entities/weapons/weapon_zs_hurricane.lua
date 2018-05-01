AddCSLuaFile()

SWEP.PrintName = "'Hurricane' Pulse SMG"
SWEP.Description = "Fires rapid pulse shots that slow targets."

if CLIENT then
	SWEP.Slot = 2
	SWEP.SlotPos = 0

	SWEP.HUD3DBone = "ValveBiped.base"
	SWEP.HUD3DPos = Vector(2.2, -0.85, 1)
	SWEP.HUD3DScale = 0.02

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/props_combine/combine_train02a.mdl", bone = "ValveBiped.base", rel = "", pos = Vector(0, -0.301, 4.731), angle = Angle(0, 180, 90), size = Vector(0.025, 0.025, 0.014), color = Color(255, 228, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base+++"] = { type = "Model", model = "models/props_c17/light_domelight01_off.mdl", bone = "ValveBiped.base", rel = "", pos = Vector(0.559, -1.04, -3.651), angle = Angle(-90, -164.752, 0), size = Vector(0.043, 0.037, 0.052), color = Color(255, 255, 255, 255), surpresslightning = true, material = "models/error/new light1", skin = 0, bodygroup = {} },
		["base+"] = { type = "Model", model = "models/props_combine/eli_pod_inner.mdl", bone = "ValveBiped.base", rel = "", pos = Vector(0.079, -2.368, -6.355), angle = Angle(-0.703, -90.113, 0), size = Vector(0.12, 0.075, 0.116), color = Color(255, 204, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base++"] = { type = "Model", model = "models/props_combine/combine_teleportplatform.mdl", bone = "ValveBiped.base", rel = "", pos = Vector(-0.002, -0.489, -8.968), angle = Angle(0, -90, -0), size = Vector(0.056, 0.019, 0.052), color = Color(255, 209, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["base+++"] = { type = "Model", model = "models/props_c17/light_domelight01_off.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.773, 2.071, -5.448), angle = Angle(0, 0, -80.556), size = Vector(0.043, 0.037, 0.052), color = Color(255, 255, 255, 255), surpresslightning = true, material = "models/error/new light1", skin = 0, bodygroup = {} },
		["base++++"] = { type = "Model", model = "models/props_c17/light_domelight01_off.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.69, 0.799, -5.528), angle = Angle(0, 0, 80.789), size = Vector(0.043, 0.037, 0.052), color = Color(255, 255, 255, 255), surpresslightning = true, material = "models/error/new light1", skin = 0, bodygroup = {} },
		["base++"] = { type = "Model", model = "models/props_combine/combine_teleportplatform.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-1.594, 1.468, -3.698), angle = Angle(103.306, 180, 0), size = Vector(0.056, 0.019, 0.052), color = Color(255, 209, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base"] = { type = "Model", model = "models/props_combine/combine_train02a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(10.47, 1.462, -6.394), angle = Angle(-175.984, -88.995, 11.291), size = Vector(0.025, 0.019, 0.014), color = Color(255, 228, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base+"] = { type = "Model", model = "models/props_combine/eli_pod_inner.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-0.541, 1.491, -6.099), angle = Angle(98.305, 179.197, 0), size = Vector(0.12, 0.075, 0.116), color = Color(255, 204, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

sound.Add(
{
	name = "Weapon_Hurricane.Single",
	channel = CHAN_WEAPON,
	volume = 0.7,
	soundlevel = 100,
	pitch = {70,80},
	sound = {"weapons/ar2/fire1.wav"}
})

SWEP.Base = "weapon_zs_base"
DEFINE_BASECLASS("weapon_zs_base")

SWEP.HoldType = "smg"

SWEP.ViewModel = "models/weapons/c_smg1.mdl"
SWEP.WorldModel = "models/weapons/w_smg1.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.ReloadSound = Sound("Weapon_SMG1.Reload")
SWEP.Primary.Sound = Sound("Weapon_Hurricane.Single")
SWEP.Primary.Damage = 14.5
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.09

SWEP.Primary.ClipSize = 40
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "pulse"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.TracerName = "AR2Tracer"

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SMG1

SWEP.ReloadSpeed = 0.9

SWEP.ConeMax = 4.3
SWEP.ConeMin = 2.5

SWEP.WalkSpeed = SPEED_NORMAL

SWEP.Tier = 2

SWEP.PointsMultiplier = GAMEMODE.PulsePointsMultiplier

SWEP.IronSightsPos = Vector(-6.425, 5, 1.02)

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.5375, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.3125, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 1, 1)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, "'Typhoon' Pulse SMG", "Less damage, more accuracy, and gains damage if spooled", function(wept)
	wept.Primary.Damage = wept.Primary.Damage * 0.82
	wept.Primary.Delay = wept.Primary.Delay * 2.3
	wept.ConeMax = wept.ConeMax * 0.5
	wept.ConeMin = wept.ConeMin * 0.7

	wept.GetFireDelay = function(self) return BaseClass.GetFireDelay(self) - (self:GetDTFloat(9) * 0.15) end
	wept.ShootBullets = function(self, dmg, numbul, cone)
		dmg = dmg + dmg * self:GetDTFloat(9) * 0.6

		BaseClass.ShootBullets(self, dmg, numbul, cone)
	end

	wept.Think = function(self)
		if self:GetReloadFinish() == 0 and self:GetOwner():KeyDown(IN_ATTACK) then
			self:SetDTFloat(9, math.min(self:GetDTFloat(9) + FrameTime() * 0.12, 1))
		else
			self:SetDTFloat(9, math.max(0, self:GetDTFloat(9) - FrameTime() * 0.5))
		end

		BaseClass.Think(self)
	end
end)

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity
	if ent:IsValid() and ent:IsPlayer() and ent:Team() == TEAM_UNDEAD then
		ent:AddLegDamageExt(3.6, attacker, attacker:GetActiveWeapon(), SLOWTYPE_PULSE)
	end

	if IsFirstTimePredicted() then
		util.CreatePulseImpactEffect(tr.HitPos, tr.HitNormal)
	end
end
