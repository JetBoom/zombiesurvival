AddCSLuaFile()

DEFINE_BASECLASS("weapon_zs_lacerator")

SWEP.PrintName = "Mutated Lacerator"

SWEP.MeleeDamage = 11

SWEP.SlowMeleeDelay = 0.95
SWEP.SlowMeleeDamage = 24
SWEP.PounceDamage = 32

function SWEP:MeleeHit(ent, trace, damage, forcescale)
	if not ent:IsPlayer() then
		damage = math.floor(damage * 18/22)
	end

	ent:PoisonDamage(damage, self:GetOwner(), self, trace.HitPos)
end
