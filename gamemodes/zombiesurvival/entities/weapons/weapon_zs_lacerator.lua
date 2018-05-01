AddCSLuaFile()

DEFINE_BASECLASS("weapon_zs_fastzombie")

SWEP.PrintName = "Lacerator"

SWEP.ViewModel = Model("models/weapons/v_fza.mdl") --Model("models/weapons/v_pza.mdl")
SWEP.WorldModel = ""

if CLIENT then
	SWEP.ViewModelFOV = 42
end

sound.Add({
	name = "Weapon_Lacerator.Swinging",
	channel = CHAN_AUTO,
	volume = 0.55,
	level = 75,
	pitch = 100,
	sound = "npc/antlion_guard/confused1.wav"
})

SWEP.MeleeDamage = 9

SWEP.SlowMeleeDelay = 0.8
SWEP.SlowMeleeDamage = 22
SWEP.PounceDamage = 30

function SWEP:MeleeHit(ent, trace, damage, forcescale)
	if not ent:IsPlayer() then
		damage = math.floor(damage * 18/22)
	end

	self.BaseClass.MeleeHit(self, ent, trace, damage, forcescale)
end

function SWEP:PlayPounceHitSound()
	self:EmitSound("physics/flesh/flesh_strider_impact_bullet1.wav")
	self:EmitSound("npc/fast_zombie/wake1.wav", 75, math.random(75, 80), nil, CHAN_AUTO)
end

function SWEP:PlayPounceStartSound()
	self:EmitSound("npc/fast_zombie/leap1.wav", 75, math.random(75, 80), nil, CHAN_AUTO)
end

function SWEP:PlayPounceSound()
	self:EmitSound("npc/ichthyosaur/attack_growl1.wav", 75, math.random(100, 116), nil, CHAN_AUTO)
end

function SWEP:PlaySwingEndSound()
	self:EmitSound("npc/zombie_poison/pz_alert2.wav", 75, nil, nil, CHAN_AUTO)
end

function SWEP:StartSwingingSound()
	self:EmitSound("Weapon_Lacerator.Swinging")
end

function SWEP:StopSwingingSound()
	self:StopSound("Weapon_Lacerator.Swinging")
end

function SWEP:PlaySlowSwingSound()
	self:EmitSound("npc/antlion_guard/angry"..math.random(3)..".wav")
end

function SWEP:PlayAlertSound()
	self:GetOwner():EmitSound("npc/zombie/zombie_alert"..math.random(1, 3)..".wav", 75, math.random(80, 85))
end
SWEP.PlayIdleSound = SWEP.PlayAlertSound
