ENT.Type = "anim"

ENT.NoNails = true
ENT.MinionSpawn = true

function ENT:ShouldNotCollide(ent)
	return ent:IsPlayer() and ent:Team() == TEAM_UNDEAD
end

AccessorFuncDT(ENT, "Settled", "Bool", 0)
