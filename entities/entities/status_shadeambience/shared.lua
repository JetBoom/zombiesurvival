ENT.Type = "anim"

function ENT:SetLastDamaged(time)
	self:SetDTFloat(0, time)
end

function ENT:GetLastDamaged()
	return self:GetDTFloat(0)
end

function ENT:SetLastDamage(damage)
	self:SetDTFloat(1, damage)
end

function ENT:GetLastDamage()
	return self:GetDTFloat(1)
end

function ENT:SetLastReflect(time)
	self:SetDTFloat(2, time)
end

function ENT:GetLastReflect()
	return self:GetDTFloat(2)
end
