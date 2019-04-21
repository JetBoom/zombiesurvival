ENT.Type = "anim"
ENT.AlwaysImpactBullets = true

function ENT:ShouldNotCollide(ent)
	return ent:IsPlayer() and ent:Team() == TEAM_HUMAN or ent:IsProjectile()
end
