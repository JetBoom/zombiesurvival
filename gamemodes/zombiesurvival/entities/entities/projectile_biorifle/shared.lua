ENT.Type = "anim"

ENT.IgnoreBullets = true

AccessorFuncDT(ENT, "HitTime", "Float", 0)
AccessorFuncDT(ENT, "TimeCreated", "Float", 1)

function ENT:ShouldNotCollide(ent)
	return ent:IsPlayer() and ent:Team() == TEAM_HUMAN
end

util.PrecacheModel("models/combine_helicopter/helicopter_bomb01.mdl")
