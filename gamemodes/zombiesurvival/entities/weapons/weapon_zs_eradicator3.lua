AddCSLuaFile()

SWEP.Base = "weapon_zs_eradicator2"
SWEP.PrintName = "Eradicator III"

SWEP.MeleeDamage = 40
SWEP.MeleeDamageVsProps = 42
SWEP.SlowDownScale = 0.35

function SWEP:MeleeHit(ent, trace, damage, forcescale)
	if not ent:IsPlayer() then
		damage = self.MeleeDamageVsProps
	end

	self.BaseClass.MeleeHit(self, ent, trace, damage, forcescale)
end

function SWEP:PlayAlertSound()
	self:GetOwner():EmitSound("npc/combine_gunship/gunship_moan.wav", 75, math.random(72.5,82.5))
end
SWEP.PlayIdleSound = SWEP.PlayAlertSound

function SWEP:PlayAttackSound()
	self:EmitSound("npc/antlion_guard/angry"..math.random(3)..".wav", 75, math.random(77.5,87.5))
end
