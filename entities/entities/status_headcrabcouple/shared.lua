ENT.Type = "anim"
ENT.Base = "status__base"

function ENT:SetPartner(partner)
	partner = partner or NULL

	self:SetDTEntity(0, partner)

	local owner = self:GetOwner()
	if owner:IsValid() then
		owner:SetBodyGroup(1, partner:IsValid() and 1 or 0)
	end
end

function ENT:GetPartner()
	return self:GetDTEntity(0)
end
