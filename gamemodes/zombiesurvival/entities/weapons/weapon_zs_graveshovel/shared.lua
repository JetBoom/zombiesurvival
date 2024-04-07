SWEP.PrintName = "Grave Shovel"
SWEP.Description = "The Grave Digger's shovel. Instantly kills knocked down zombies and permanently gains damage when doing so."

SWEP.Base = "weapon_zs_basemelee"

SWEP.HoldType = "melee2"

SWEP.DamageType = DMG_CLUB

SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.UseHands = true

SWEP.MeleeDamage = 130
SWEP.MeleeRange = 78
SWEP.MeleeSize = 1.5
SWEP.MeleeKnockBack = 220

SWEP.Primary.Delay = 1.2

SWEP.WalkSpeed = SPEED_SLOWER

SWEP.SwingRotation = Angle(0, -90, -60)
SWEP.SwingOffset = Vector(0, 30, -40)
SWEP.SwingTime = 0.65
SWEP.SwingHoldType = "melee"

SWEP.Tier = 4
SWEP.MaxStock = 3

SWEP.AllowQualityWeapons = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.12)

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(65, 70))
end

function SWEP:PlayHitSound()
	self:EmitSound("weapons/melee/shovel/shovel_hit-0"..math.random(4)..".ogg", 75, 80)
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav")
end

function SWEP:SetShovelCharge(charge)
	self:SetDTInt(9, charge)
end

function SWEP:GetShovelCharge()
	return self:GetDTInt(9)
end
