ENT.Type = "anim"

ENT.ExplosionDelay = 0.7
ENT.ArmTime = 8

ENT.NoPropDamageDuringWave0 = true

function ENT:ShouldNotCollide(ent)
	return ent:IsPlayer()
end

function ENT:SetExplodeTime(time)
	self:SetDTFloat(0, time)
end

function ENT:GetExplodeTime()
	return self:GetDTFloat(0)
end
