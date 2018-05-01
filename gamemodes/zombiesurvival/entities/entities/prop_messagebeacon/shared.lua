ENT.Type = "anim"

ENT.CanPackUp = true
ENT.PackUpTime = 0.05

ENT.m_NoNailUnfreeze = true
ENT.NoNails = true

ENT.IsBarricadeObject = true
ENT.AlwaysGhostable = true

function ENT:GetMessageID()
	return self:GetDTInt(0)
end

function ENT:GetMessage(id)
	return GAMEMODE.ValidBeaconMessages[id or self:GetMessageID()] or GAMEMODE.ValidBeaconMessages[1]
end

function ENT:SetObjectOwner(owner)
	self:SetDTEntity(0, owner)
end

function ENT:GetObjectOwner()
	return self:GetDTEntity(0)
end
