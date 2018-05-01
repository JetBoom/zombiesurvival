ENT.Type = "anim"

function ENT:ShouldNotCollide(ent)
	return ent:IsPlayer() or ent:IsProjectile() or ent.ZombieConstruction
end

util.PrecacheModel("models/props_junk/sawblade001a.mdl")
