ENT.Type = "anim"

ENT.Radius = 75

function ENT:ShouldNotCollide(ent)
	return ent:IsPlayer()
end
