ENT.Type = "anim"

ENT.CanPackUp = true
ENT.PackUpTime = 5

ENT.m_NoNailUnfreeze = true
ENT.NoNails = true

ENT.IsBarricadeObject = true
ENT.AlwaysGhostable = true

function ENT:SetObjectOwner(owner)
	self:SetDTEntity(0, owner)
end

function ENT:GetObjectOwner()
	return self:GetDTEntity(0)
end
