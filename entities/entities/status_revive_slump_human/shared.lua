ENT.Type = "anim"
ENT.Base = "status_revive_slump"

function ENT:SetZombieInitializeTime(time)
	self:SetDTFloat(1, time)
end

function ENT:GetZombieInitializeTime()
	return self:GetDTFloat(1)
end
