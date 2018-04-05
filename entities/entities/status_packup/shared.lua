ENT.Type = "anim"
ENT.Base = "status__base"

ENT.PackUpOverride = 4

function ENT:GetTimeRemaining()
	return math.max(0, self:GetEndTime() - CurTime())
end

function ENT:RefreshMaxTime()
	self:SetMaxTime(math.max(self:GetMaxTime(), self:GetEndTime() - self:GetStartTime()))
end

function ENT:SetMaxTime(time)
	self:SetDTFloat(2, time)
end

function ENT:GetMaxTime()
	return self:GetDTFloat(2)
end

function ENT:SetEndTime(time)
	self:SetDTFloat(0, time)
	self:RefreshMaxTime()
end

function ENT:GetEndTime()
	return self:GetDTFloat(0)
end

function ENT:GetStartTime()
	return self:GetDTFloat(1)
end

function ENT:SetStartTime(time)
	self:SetDTFloat(1, time)
	self:RefreshMaxTime()
end

function ENT:SetPackUpEntity(ent)
	self:SetDTEntity(0, ent)
end

function ENT:GetPackUpEntity()
	return self:GetDTEntity(0)
end

function ENT:SetNotOwner(notowner)
	self:SetDTBool(0, notowner)
end

function ENT:GetNotOwner()
	return self:GetDTBool(0)
end
