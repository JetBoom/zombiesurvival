ENT.Type = "anim"

ENT.CanPackUp = true
ENT.PackUpTime = 3

ENT.m_NoNailUnfreeze = true
ENT.NoNails = true

function ENT:ShouldNotCollide(ent)
	return not ent:IsPlayer() and not ent:IsProjectile()
end
