ENT.Type = "anim"

ENT.IgnoreBullets = true
ENT.IgnoreMelee = true
ENT.IgnoreTraces = true

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:ShouldNotCollide(ent)
	return ent:IsPlayer() and ent:Team() == TEAM_UNDEAD or ent:IsProjectile()
end

util.PrecacheModel("models/props_wasteland/rockcliff01g.mdl")
