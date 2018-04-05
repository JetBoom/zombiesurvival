ENT.Type = "anim"

ENT.m_NoNailUnfreeze = true
ENT.NoNails = true

ENT.RiseTime = 4

ENT.OpenTime = 10

AccessorFuncDT(ENT, "OpenStartTime", "Float", 0)
AccessorFuncDT(ENT, "CreationTime", "Float", 1)

function ENT:GetOpenedPercent()
	if not self:IsOpening() then return 0 end

	return math.Clamp((CurTime() - self:GetOpenStartTime()) / self.OpenTime, 0, 1)
end

function ENT:IsOpened()
	return self:GetOpenStartTime() ~= 0 and CurTime() >= self:GetOpenStartTime() + self.OpenTime
end

function ENT:IsOpening()
	return self:GetOpenStartTime() ~= 0
end

function ENT:GetRise()
	return math.Clamp((CurTime() - self:GetCreationTime()) / self.RiseTime, 0, 1)
end
