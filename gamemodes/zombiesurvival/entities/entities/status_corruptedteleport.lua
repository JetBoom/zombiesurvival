AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "status_sigilteleport"

ENT.ParticleMaterial = "particle/smokesprites_0001"

function ENT:SetParticleColor(particle)
	particle:SetColor(38, 255, 102)
end
