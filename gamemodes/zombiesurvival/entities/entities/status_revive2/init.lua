AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:PlayerSet(pPlayer, bExists)
	pPlayer.Revive = self
end

function ENT:Think()
	local owner = self:GetOwner()
	if owner:IsValid() and (owner:Alive() or self:GetReviveTime() <= CurTime()) then
		self:Remove()
	end
end

function ENT:OnRemove()
	local parent = self:GetParent()
	if parent:IsValid() then
		parent.Revive = nil
		if not parent:Alive() then
			parent:SecondWind()
		end
	end
end
