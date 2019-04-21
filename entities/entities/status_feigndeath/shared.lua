ENT.Type = "anim"
ENT.Base = "status__base"

function ENT:Move(pl, move)
	if pl ~= self:GetOwner() then return end

	move:SetMaxSpeed(0)
	move:SetMaxClientSpeed(0)
end

function ENT:SetState(state)
	self:SetDTInt(0, state)
end

function ENT:GetState()
	return self:GetDTInt(0)
end

function ENT:SetStateEndTime(time)
	self:SetDTFloat(0, time)
end

function ENT:GetStateEndTime()
	return self:GetDTFloat(0)
end

function ENT:SetDirection(m)
	self:SetDTInt(1, m)
end

function ENT:GetDirection()
	return self:GetDTInt(1)
end
