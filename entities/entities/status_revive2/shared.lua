ENT.Type = "anim"
ENT.Base = "status__base"

function ENT:IsRising()
	return self:GetReviveTime() - 2.5 <= CurTime()
end

function ENT:SetReviveTime(tim)
	self:SetDTFloat(0, tim)
end

function ENT:GetReviveTime()
	return self:GetDTFloat(0)
end
