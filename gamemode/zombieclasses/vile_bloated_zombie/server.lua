AddCSLuaFile("shared.lua")
include("shared.lua")

function CLASS:OnSpawned(pl)
	pl:CreateAmbience("vbloatedambience")
end

function CLASS:OnKilled(pl, attacker, inflictor, suicide, headshot, dmginfo, assister)
	--nothing
end
