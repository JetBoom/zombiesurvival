ENT.Type = "anim"

ENT.NoReviveFromKills = true

function ENT:ShouldNotCollide(ent)
	return ent:IsPlayer() and ent:Team() == TEAM_HUMAN or ent:IsProjectile()
end

util.PrecacheModel("models/props_junk/harpoon002a.mdl")
util.PrecacheSound("weapons/iceaxe/iceaxe_swing1.wav")
util.PrecacheSound("physics/metal/metal_sheet_impact_bullet1.wav")
util.PrecacheSound("physics/metal/metal_sheet_impact_bullet2.wav")
util.PrecacheSound("npc/strider/strider_skewer1.wav")
