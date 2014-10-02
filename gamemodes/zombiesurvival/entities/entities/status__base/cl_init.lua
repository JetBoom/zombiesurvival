include("shared.lua")

function ENT:Draw()
end

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 80))

	local owner = self:GetOwner()
	if owner:IsValid() then
		owner[self:GetClass()] = self
	end

	self:OnInitialize()
end

function ENT:Think()
	local owner = self:GetOwner()
	if owner:IsValid() then self:SetPos(owner:EyePos()) end
end

function ENT:OnRemove()
	local owner = self:GetOwner()
	if owner:IsValid() and owner[self:GetClass()] == self then
		owner[self:GetClass()] = nil
	end
end
