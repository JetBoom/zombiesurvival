ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_OPAQUE

ENT.SWEP = "weapon_zs_camera"
ENT.MaxHealth = 75

ENT.m_NoNailUnfreeze = true
ENT.NoNails = true
ENT.IgnoreBullets = true

ENT.CanPackUp = true
ENT.PackUpTime = 1

ENT.AlwaysGhostable = true

function ENT:GetObjectHealth()
	return self:GetDTFloat(3)
end

function ENT:GetMaxObjectHealth()
	return self:GetDTInt(1)
end

function ENT:GetObjectOwner()
	return self:GetDTEntity(1)
end
