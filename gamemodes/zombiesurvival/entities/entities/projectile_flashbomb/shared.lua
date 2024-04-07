ENT.Type = "anim"

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.LifeTime = 1.5
ENT.Radius = 510

function ENT:ShouldNotCollide(ent)
	return ent:IsPlayer()
end
