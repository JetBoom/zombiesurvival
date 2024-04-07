ENT.Type = "anim"

ENT.LifeTime = 2.5

ENT.NoPropDamageDuringWave0 = true

function ENT:ShouldNotCollide(ent)
	return ent:IsPlayer()
end

util.PrecacheSound("physics/metal/metal_grenade_impact_hard1.wav")
util.PrecacheSound("physics/metal/metal_grenade_impact_hard2.wav")
util.PrecacheSound("physics/metal/metal_grenade_impact_hard3.wav")
