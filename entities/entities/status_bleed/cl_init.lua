include("shared.lua")

function ENT:Draw()
end

function ENT:Initialize()
	self:GetOwner().Bleed = self
end
