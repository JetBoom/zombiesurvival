include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 80))

	if self:GetStartTime() == 0 then
		self:SetStartTime(CurTime())
	end

	self:GetOwner().PackUp = self
end

function ENT:OnRemove()
end

function ENT:Think()
end

function ENT:Draw()
end
