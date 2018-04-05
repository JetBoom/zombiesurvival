include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)

	self:GetOwner().m_Couple = self
end

function ENT:OnRemove()
	local owner = self:GetOwner()
	if owner:IsValid() and owner.m_Couple == self then
		owner.m_Couple = nil
	end
end
