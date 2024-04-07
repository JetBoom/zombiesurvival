ENT.Type = "anim"

function ENT:ShouldNotCollide(ent)
	return ent:IsPlayer() and ent:Team() == TEAM_UNDEAD
end

util.PrecacheModel("models/props_wasteland/dockplank_chunk01d.mdl")
util.PrecacheSound("npc/antlion_grub/squashed.wav")
