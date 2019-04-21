AddCSLuaFile()

SWEP.PrintName = "Stun Baton"
SWEP.Description = "This baton has the ability to slow zombies with pulse slowing technology and it gains +25% extra points."

if CLIENT then
	SWEP.ViewModelFOV = 50
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.ViewModel = "models/weapons/c_stunstick.mdl"
SWEP.WorldModel = "models/weapons/w_stunbaton.mdl"
SWEP.UseHands = true

SWEP.HoldType = "melee"

SWEP.MeleeDamage = 32
SWEP.LegDamage = 20
SWEP.MeleeRange = 49
SWEP.MeleeSize = 1.5
SWEP.Primary.Delay = 0.9

SWEP.SwingTime = 0.25
SWEP.SwingRotation = Angle(60, 0, 0)
SWEP.SwingOffset = Vector(0, -50, 0)
SWEP.SwingHoldType = "grenade"

SWEP.PointsMultiplier = GAMEMODE.PulsePointsMultiplier

SWEP.AllowQualityWeapons = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.09)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_LEG_DAMAGE, 2)

function SWEP:PlaySwingSound()
	self:EmitSound("Weapon_StunStick.Swing")
end

function SWEP:PlayHitSound()
	self:EmitSound("Weapon_StunStick.Melee_HitWorld")
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("Weapon_StunStick.Melee_Hit")
end

function SWEP:OnMeleeHit(hitent, hitflesh, tr)
	if hitent:IsValid() and hitent:IsPlayer() then
		hitent:AddLegDamageExt(self.LegDamage, self:GetOwner(), self, SLOWTYPE_PULSE)
	end
end
