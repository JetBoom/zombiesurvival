ENT.Type = "anim"

function ENT:ShouldNotCollide(ent)
	return ent:IsPlayer() and ent:Team() == TEAM_HUMAN
end

util.PrecacheModel("models/combine_helicopter/helicopter_bomb01.mdl")
