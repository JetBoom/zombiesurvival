AddCSLuaFile()

SWEP.PrintName = "Cracked Bottle"
SWEP.Description = "A cracked bottle."

if CLIENT then
	SWEP.ViewModelFOV = 55
	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/props_junk/glassbottle01a_chunk01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.635, 1.557, -4.676), angle = Angle(180, -111.04, 155.455), size = Vector(1.144, 1.144, 1.144), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/props_junk/glassbottle01a_chunk01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.714, 2.596, -2.597), angle = Angle(38.57, -68.961, 22.208), size = Vector(1.274, 1.274, 1.274), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.HoldType = "knife"

SWEP.DamageType = DMG_SLASH

SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/cstrike/c_knife_t.mdl"
SWEP.WorldModel = "models/props_junk/glassbottle01a_chunk01a.mdl"
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false
SWEP.UseHands = true

SWEP.AutoSwitchFrom	= true

SWEP.MeleeDamage = 20
SWEP.MeleeRange = 45
SWEP.MeleeSize = 0.875

SWEP.WalkSpeed = SPEED_FASTEST

SWEP.Primary.Delay = 0.8

SWEP.HitDecal = "Manhackcut"

SWEP.HitGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_KNIFE
SWEP.MissGesture = SWEP.HitGesture

SWEP.HitAnim = ACT_VM_MISSCENTER
SWEP.MissAnim = ACT_VM_PRIMARYATTACK

SWEP.NoHitSoundFlesh = true

SWEP.NoGlassWeapons = true

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/knife/knife_slash"..math.random(2)..".wav")
end

function SWEP:PlayHitSound()
	self:EmitSound("physics/glass/glass_bottle_break2.wav")
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/glass/glass_bottle_break2.wav")
end

function SWEP:OnMeleeHit(hitent, hitflesh)
	if hitent:IsValid() and SERVER then
		timer.Simple(0, function() self:GetOwner():StripWeapon(self:GetClass()) end)
	end
end
