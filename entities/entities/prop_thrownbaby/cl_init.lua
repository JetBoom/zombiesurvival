include("shared.lua")

function ENT:Initialize()
	self:SetModelScale(1.3, 0)
end

function ENT:Draw()
	self:DrawModel()
end
