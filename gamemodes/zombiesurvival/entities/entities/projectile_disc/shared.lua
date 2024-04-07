ENT.Type = "anim"

function ENT:ShouldNotCollide(ent)
	return ent:IsPlayer()
end

util.PrecacheModel("models/props_junk/sawblade001a.mdl")
