ENT.Base = "prop_gunturret"

ENT.SWEP = "weapon_zs_gunturret_rocket"

ENT.AmmoType = "impactmine"
ENT.FireDelay = 2
ENT.NumShots = 1
ENT.Damage = 97
ENT.PlayLoopingShootSound = false
ENT.Spread = 0.75
ENT.MaxAmmo = 30
ENT.MaxHealth = 225

function ENT:PlayShootSound()
	self:EmitSound("weapons/stinger_fire1.wav", 80, math.random(148, 153), 0.8)
	self:EmitSound("weapons/grenade_launcher1.wav", 80, math.random(86, 92), 0.7, CHAN_WEAPON + 20)
end
