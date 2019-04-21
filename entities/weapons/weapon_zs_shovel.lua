AddCSLuaFile()

SWEP.PrintName = "Shovel"
SWEP.Description = "A shovel instantly kills zombies that are knocked down, and it's an effective melee weapon even otherwise."

if CLIENT then
	SWEP.ViewModelFOV = 60

	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false

	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/props_junk/shovel01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1.363, 1.363, -7.728), angle = Angle(0, 0, 0), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/props_junk/shovel01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5, 1.363, -15), angle = Angle(-3, 180, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.HoldType = "melee2"

SWEP.DamageType = DMG_CLUB

SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/props_junk/shovel01a.mdl"
SWEP.UseHands = true

SWEP.MeleeDamage = 50
SWEP.MeleeRange = 68
SWEP.MeleeSize = 1.5
SWEP.MeleeKnockBack = 230

SWEP.Primary.Delay = 1.2

SWEP.Tier = 2

SWEP.WalkSpeed = SPEED_SLOWER

SWEP.SwingRotation = Angle(0, -90, -60)
SWEP.SwingOffset = Vector(0, 30, -40)
SWEP.SwingTime = 0.65
SWEP.SwingHoldType = "melee"

SWEP.AllowQualityWeapons = true
SWEP.DismantleDiv = 2

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.09, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MELEE_IMPACT_DELAY, -0.06, 1)

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(65, 70))
end

function SWEP:PlayHitSound()
	self:EmitSound("weapons/melee/shovel/shovel_hit-0"..math.random(4)..".ogg")
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav")
end

function SWEP:PostOnMeleeHit(hitent, hitflesh, tr)
	if hitent:IsValid() and hitent:IsPlayer() and hitent.Revive and hitent.Revive:IsValid() and gamemode.Call("PlayerShouldTakeDamage", hitent, self:GetOwner()) then
		hitent:TakeSpecialDamage(hitent:Health(), DMG_DIRECT, self:GetOwner(), self, tr.HitPos)
	end
end
