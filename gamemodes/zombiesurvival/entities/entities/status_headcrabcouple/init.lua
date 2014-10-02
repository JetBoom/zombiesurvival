AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:PlayerSet(pPlayer, bExists)
	pPlayer.m_Couple = self
end

function ENT:Remove()
	local owner = self:GetOwner()
	if owner:IsValid() and owner.m_Couple == self then
		owner:SetBodyGroup(1, 0)
		owner.m_Couple = nil
	end
end

function ENT:Think()
end
