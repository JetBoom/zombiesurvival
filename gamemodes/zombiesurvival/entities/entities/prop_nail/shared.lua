ENT.Type = "anim"

function ENT:GetDeployer()
	return self:GetOwner()
end

function ENT:GetMaxNailHealth()
	local ent = self:GetBaseEntity()
	if ent:IsValid() then
		return ent:GetMaxBarricadeHealth()
	end

	return 0
end

function ENT:GetNailHealth()
	local ent = self:GetBaseEntity()
	if ent:IsValid() then
		return ent:GetBarricadeHealth()
	end

	return 0
end

function ENT:GetRepairs()
	local ent = self:GetBaseEntity()
	if ent:IsValid() then
		return ent:GetBarricadeRepairs()
	end

	return 0
end

function ENT:GetMaxRepairs()
	local ent = self:GetBaseEntity()
	if ent:IsValid() then
		return ent:GetMaxBarricadeRepairs()
	end

	return 0
end

function ENT:SetMaxRepairs(m)
end

function ENT:SetBaseEntity(ent)
	self:SetDTEntity(0, ent)
end

function ENT:GetBaseEntity()
	return self:GetDTEntity(0)
end

function ENT:GetAttachEntity()
	return self.m_AttachEntity or NULL
end

function ENT:GetActualPos()
	local offset = self:GetActualOffset()
	if offset then
		local parent = self:GetParent()
		if parent:IsValid() then
			return parent:LocalToWorld(offset)
		end
	end

	return self:GetPos()
end

function ENT:GetActualOffset()
	return self.m_ActualOffset
end

function ENT:SetActualOffset(pos, ent)
	self.m_ActualOffset = ent:WorldToLocal(pos)
end
