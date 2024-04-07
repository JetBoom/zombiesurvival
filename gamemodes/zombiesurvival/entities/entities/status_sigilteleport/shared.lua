ENT.Type = "anim"
ENT.Base = "status__base"

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

function ENT:GetTargetSigil()
	local owner = self:GetParent()
	if owner:IsValid() then
		return owner:SigilTeleportDestination(self:GetFromSigil():IsValid() and self:GetFromSigil():IsWeapon(), self:GetClass() == "status_corruptedteleport")
	end

	return NULL
end

function ENT:SetFromSigil(ent)
	self:SetDTEntity(1, ent)
end

function ENT:GetFromSigil()
	return self:GetDTEntity(1)
end
