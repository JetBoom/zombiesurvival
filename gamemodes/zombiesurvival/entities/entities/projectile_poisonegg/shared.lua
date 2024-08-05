ENT.Type = "anim"

function ENT:ShouldNotCollide(ent)
	return ent:IsPlayer() and ent:Team() == TEAM_UNDEAD
end

util.PrecacheModel("models/props/cs_italy/orange.mdl")