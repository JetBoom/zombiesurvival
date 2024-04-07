ENT.Type = "anim"

ENT.IgnoreBullets = true
ENT.IgnoreMelee = true
ENT.IgnoreTraces = true

function ENT:ShouldNotCollide(ent)
	return ent:IsPlayer() and ent:Team() == TEAM_UNDEAD or ent:IsProjectile()
end

util.PrecacheModel("models/props_wasteland/rockgranite03b.mdl")
