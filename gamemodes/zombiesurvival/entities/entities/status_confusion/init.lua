AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:PlayerSet(pPlayer, bExists)
	pPlayer.Confusion = self
	pPlayer:SetDSP(7)

	if self:GetStartTime() == 0 then
		self:SetStartTime(CurTime())
	end

	if self:GetEndTime() == 0 then
		self:SetEndTime(CurTime() + 10)
	end
end

function ENT:Think()
	local owner = self:GetOwner()
	if CurTime() >= self:GetEndTime() or self.EyeEffect and owner:IsValid() and owner:WaterLevel() >= 3 then
		self:Remove()
	end
end

function ENT:OnRemove()
	local owner = self:GetOwner()
	if owner.Confusion == self then
		owner.Confusion = nil
		owner:SetDSP(0)
	end
end
