ENT.Type = "anim"
ENT.Heal = 7

function ENT:ShouldNotCollide(ent)
	return ent:IsProjectile()
end
