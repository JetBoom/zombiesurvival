SWEP.Base = "weapon_zs_zombie"

SWEP.PrintName = "Shit Slapper"

SWEP.MeleeDelay = 0.25
SWEP.MeleeReach = 74
SWEP.MeleeDamage = 38
SWEP.MeleeSize = 16
SWEP.SwingAnimSpeed = 2.82

SWEP.DelayWhenDeployed = true

function SWEP:Reload()
	self:SecondaryAttack()
end

function SWEP:StartMoaning()
end

function SWEP:StopMoaning()
end

function SWEP:IsMoaning()
	return false
end

function SWEP:PlayHitSound()
	self:EmitSound("npc/zombie/claw_strike"..math.random(3)..".wav", 75, math.random(80, 90), nil, CHAN_AUTO)
end

function SWEP:PlayMissSound()
	self:EmitSound("npc/zombie/claw_miss"..math.random(2)..".wav", 75, math.random(80, 90), nil, CHAN_AUTO)
end

function SWEP:PlayAttackSound()
	self:EmitSound("npc/zombie/zo_attack"..math.random(2)..".wav", 75, math.random(80, 90))
end

function SWEP:PlayAlertSound()
	self:GetOwner():EmitSound("npc/zombie/zombie_alert"..math.random(3)..".wav", 75, math.random(80, 90))
end

function SWEP:PlayIdleSound()
	self:GetOwner():EmitSound("npc/zombie/zombie_voice_idle"..math.random(14)..".wav", 75, math.random(80, 90))
end
