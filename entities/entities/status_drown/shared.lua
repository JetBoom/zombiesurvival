ENT.Type = "anim"
ENT.Base = "status__base"

function ENT:SetDrown(drownamount)
	self:SetDTFloat(0, CurTime())
	self:SetDTFloat(1, drownamount)
end

function ENT:SetUnderwater(underwater)
	self:SetDrown(self:GetDrown())

	self:SetDTBool(0, underwater)
end

function ENT:GetUnderwater()
	return self:GetDTBool(0)
end
ENT.IsUnderwater = ENT.GetUnderwater

function ENT:GetDrown()
	if self:IsUnderwater() then
		return math.Clamp(self:GetDTFloat(1) + (CurTime() - self:GetDTFloat(0)) / self:GetDrownTime(), 0, 1)
	else
		return math.Clamp(self:GetDTFloat(1) - (CurTime() - self:GetDTFloat(0)) / self:GetRecoverTime(), 0, 1)
	end
end

function ENT:GetDrownTime()
	local owner = self:GetOwner()
	if owner:IsValid() and owner:HasTrinket("oxygentank") then
		return 300
	end

	return 30
end

function ENT:GetRecoverTime()
	local owner = self:GetOwner()
	if owner:IsValid() and owner:HasTrinket("oxygentank") then
		return 20
	end

	return 10
end

function ENT:IsDrowning()
	return self:GetDrown() == 1 and self:GetUnderwater()
end
