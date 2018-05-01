SWEP.PrintName = "Mechanic's Wrench"
SWEP.Description = "This tool can be used to repair deployables as long as they were not damaged recently."

SWEP.Base = "weapon_zs_basemelee"

SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/props_c17/tools_wrench01a.mdl"
SWEP.ModelScale = 1.5
SWEP.UseHands = true

SWEP.HoldType = "melee"

SWEP.DamageType = DMG_CLUB

SWEP.Primary.Delay = 0.8
SWEP.MeleeDamage = 28
SWEP.MeleeRange = 50
SWEP.MeleeSize = 0.875

SWEP.MaxStock = 5

SWEP.HitGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.MissGesture = SWEP.HitGesture

SWEP.SwingTime = 0.19
SWEP.SwingRotation = Angle(30, -30, -30)
SWEP.SwingOffset = Vector(0, -30, 0)
SWEP.SwingHoldType = "grenade"

SWEP.HealStrength = 13

SWEP.AllowQualityWeapons = true

GAMEMODE:SetPrimaryWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.04)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MELEE_RANGE, 3, 1)

function SWEP:PlayHitSound()
	self:EmitSound("weapons/melee/crowbar/crowbar_hit-"..math.random(4)..".ogg", 75, math.random(120, 125))
end
