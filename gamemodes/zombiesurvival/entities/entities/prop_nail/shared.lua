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

function ENT:SetAttachEntity(ent, physbone1, physbone2)
	self.m_AttachEntity = ent

	if not SERVER then return end

	local baseent = self:GetBaseEntity()
	if not baseent:IsValid() then return end

	local cons = constraint.Weld(baseent, ent, physbone1 or 0, physbone2 or 0, 0, true)
	if cons ~= nil then
		for _, oldcons in pairs(constraint.FindConstraints(baseent, "Weld")) do
			if oldcons.Ent1 == ent or oldcons.Ent2 == ent then
				cons = oldcons.Constraint
				break
			end
		end
	end

	cons:DeleteOnRemove(self)
	self:SetNailConstraint(cons)

	if baseent:IsValid() then
		baseent:CollisionRulesChanged()
	end
	if ent and ent:IsValid() then
		ent:CollisionRulesChanged()
	end

	timer.Simple(0.1, function() GAMEMODE:EvaluatePropFreeze() end)

	return cons
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
