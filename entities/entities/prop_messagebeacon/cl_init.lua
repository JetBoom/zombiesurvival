include("shared.lua")

function ENT:Initialize()
	self:SetModelScale(0.333, 0)
end

function ENT:SetMessageID(id)
	self:SetDTInt(0, id)
end
