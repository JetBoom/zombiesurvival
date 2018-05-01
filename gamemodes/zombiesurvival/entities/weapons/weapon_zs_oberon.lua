AddCSLuaFile()

SWEP.PrintName = "'Oberon' Pulse Shotgun"
SWEP.Description = "Fires a spread of pulse shots that slow targets."

if CLIENT then
	SWEP.Slot = 3
	SWEP.SlotPos = 0

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "ValveBiped.Gun"
	SWEP.HUD3DPos = Vector(2.12, -1, -8)
	SWEP.HUD3DScale = 0.025

	SWEP.ShowViewModel = true

	SWEP.VElements = {
		["base+++"] = { type = "Model", model = "models/Items/boxflares.mdl", bone = "ValveBiped.Gun", rel = "", pos = Vector(-1.283, -2.158, 1.508), angle = Angle(90, -90, -90), size = Vector(0.437, 0.226, 0.446), color = Color(255, 255, 255, 255), surpresslightning = true, material = "models/error/new light1", skin = 0, bodygroup = {} },
		["base+"] = { type = "Model", model = "models/props_combine/combine_mortar01a.mdl", bone = "ValveBiped.Pump", rel = "", pos = Vector(-1.313, 1.697, -20.396), angle = Angle(0.476, 90, 0), size = Vector(0.172, 0.179, 0.256), color = Color(255, 147, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base++"] = { type = "Model", model = "models/props_combine/combinetrain01a.mdl", bone = "ValveBiped.Gun", rel = "", pos = Vector(0.197, 3.431, 3.428), angle = Angle(-90, 0, -90.676), size = Vector(0.071, 0.019, 0.025), color = Color(255, 180, 123, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["base++"] = { type = "Model", model = "models/props_combine/combinetrain01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(18.329, 1.085, -3.164), angle = Angle(175.024, 0.411, 0), size = Vector(0.037, 0.02, 0.017), color = Color(255, 180, 123, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base+++"] = { type = "Model", model = "models/Items/boxflares.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(17.725, -0.431, -6.599), angle = Angle(6.518, 180, -90), size = Vector(0.277, 0.277, 0.469), color = Color(255, 255, 255, 255), surpresslightning = true, material = "models/error/new light1", skin = 0, bodygroup = {} },
		["base+"] = { type = "Model", model = "models/props_combine/combine_mortar01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.356, 0.796, -2.659), angle = Angle(-94.139, 1.621, 0), size = Vector(0.129, 0.136, 0.108), color = Color(255, 147, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

sound.Add(
{
	name = "Weapon_Oberon.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	soundlevel = 100,
	pitch = {85, 92},
	sound = "weapons/gauss/fire1.wav"
})

SWEP.Base = "weapon_zs_baseshotgun"

SWEP.HoldType = "shotgun"

SWEP.ViewModel = "models/weapons/c_shotgun.mdl"
SWEP.WorldModel = "models/weapons/w_shotgun.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.Primary.Sound = Sound("Weapon_Oberon.Single")
SWEP.Primary.Damage = 12
SWEP.Primary.NumShots = 5
SWEP.Primary.Delay = 0.8

SWEP.FireAnimSpeed = 0.55

SWEP.Primary.ClipSize = 7
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pulse"
SWEP.Primary.DefaultClip = 30

SWEP.ConeMax = 7.5
SWEP.ConeMin = 5

SWEP.ReloadDelay = 0.4

SWEP.WalkSpeed = SPEED_SLOWER

SWEP.TracerName = "AR2Tracer"

SWEP.PumpSound = Sound("Weapon_Shotgun.Special1")
SWEP.ReloadSound = Sound("Weapon_Shotgun.Reload")

SWEP.LegDamage = 9
SWEP.Tier = 3

SWEP.PointsMultiplier = GAMEMODE.PulsePointsMultiplier

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_LEG_DAMAGE, 1)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, "'Neptune' Pulse Shotgun", "Fast firing and reloading, uses 3x ammo", function(wept)
	wept.RequiredClip = 3
	wept.Primary.ClipSize = 21
	wept.Primary.Delay = 0.6
	wept.ReloadDelay = 0.1
	wept.ReloadSound = Sound("npc/scanner/scanner_scan4.wav")

	wept.EmitFireSound = function(self)
		self:EmitSound("weapons/stunstick/alyx_stunner2.wav", 72, 115, 0.65, CHAN_AUTO)
		self:EmitSound("weapons/gauss/fire1.wav", 72, 108, 0.65)
	end

	if CLIENT then
		wept.VElements["base+++"].color = Color(0, 255, 255)
	end
end)

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity
	if ent:IsValidLivingZombie() then
		ent:AddLegDamageExt(dmginfo:GetInflictor().LegDamage, attacker, attacker:GetActiveWeapon(), SLOWTYPE_PULSE)
	end

	if IsFirstTimePredicted() then
		util.CreatePulseImpactEffect(tr.HitPos, tr.HitNormal)
	end
end

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound)
	self:EmitSound("weapons/glock/glock18-1.wav", 75, math.random(162, 168), 0.7, CHAN_WEAPON + 20)
end
