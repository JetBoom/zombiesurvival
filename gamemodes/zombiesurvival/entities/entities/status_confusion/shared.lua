ENT.Type = "anim"
ENT.Base = "status__base"

function ENT:SetEndTime(time)
	self:SetDTFloat(0, time)
end

function ENT:GetEndTime()
	return self:GetDTFloat(0)
end

function ENT:SetStartTime(time)
	self:SetDTFloat(1, time)
end

function ENT:GetStartTime()
	return self:GetDTFloat(1)
end

function ENT:GetPower()
	local curtime = CurTime()
	local power = math.min(1, curtime - self:GetStartTime())
	if power == 1 then
		power = math.min(1, self:GetEndTime() - curtime)
	end

	return power
end
