ENT.Type = "anim"
ENT.Base = "status__base"

function ENT:SetDamage(damage)
	self:SetDTFloat(0, math.min(15, damage))
end

function ENT:GetDamage()
	return self:GetDTFloat(0)
end

function ENT:SetPuller(puller)
	self:SetDTEntity(0, puller)
end

function ENT:GetPuller()
	return self:GetDTEntity(0)
end
