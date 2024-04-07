AddCSLuaFile()

SWEP.PrintName = "Skullsmasher"
SWEP.Description = "A heavy, but powerful melee weapon. A target struck by the force of it will receive considerable knockback."

if CLIENT then
	SWEP.ViewModelFOV = 70
end

SWEP.Base = "mfrp_base"
SWEP.HoldType = "melee2"

SWEP.Parrying = true 

SWEP.DamageType = DMG_CLUB

SWEP.ViewModel 	= "models/aoc_weapon/w_spikedmace.mdl" 
SWEP.WorldModel = "models/aoc_weapon/w_spikedmace.mdl" 
SWEP.UseHands = true

SWEP.MeleeDamage = 250
SWEP.MeleeRange = 75
SWEP.MeleeSize = 1.95
SWEP.MeleeKnockBack = 280

SWEP.Primary.Delay = 1.5

SWEP.Tier = 5

SWEP.WalkSpeed = SPEED_SLOWEST

SWEP.SwingRotation = Angle(60, 0, -80)
SWEP.SwingOffset = Vector(0, -30, 0)
SWEP.SwingTime = 0.80
SWEP.SwingHoldType = "melee"

SWEP.AllowQualityWeapons = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MELEE_IMPACT_DELAY, -0.1, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.1, 1)

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(35, 45))
end

function SWEP:PlayHitSound()
	self:EmitSound("physics/metal/metal_canister_impact_hard"..math.random(3)..".wav", 75, math.Rand(86, 90))
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 75, math.Rand(86, 90))
end
