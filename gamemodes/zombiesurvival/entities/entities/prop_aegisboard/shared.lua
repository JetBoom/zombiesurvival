ENT.Type = "anim"

ENT.m_NoNailUnfreeze = true
ENT.NoNails = true

ENT.CanPackUp = true
ENT.PackUpTime = 3

ENT.IsBarricadeObject = true

function ENT:GetObjectHealth()
	return self:GetDTFloat(0)
end

function ENT:SetMaxObjectHealth(health)
	self:SetDTFloat(1, health)
end

function ENT:GetMaxObjectHealth()
	return self:GetDTFloat(1)
end

function ENT:SetObjectOwner(ent)
	self:SetDTEntity(0, ent)
end

function ENT:GetObjectOwner()
	return self:GetDTEntity(0)
end

function ENT:ClearObjectOwner()
	self:SetObjectOwner(NULL)
end

function ENT:HitByWrench(wep, owner, tr)
	return true
end

function ENT:CanBePackedBy(pl)
	local owner = self:GetObjectOwner()
	return not owner:IsValid() or owner == pl or owner:Team() ~= TEAM_HUMAN or gamemode.Call("PlayerIsAdmin", pl)
end
