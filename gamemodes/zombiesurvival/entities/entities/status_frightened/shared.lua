AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "status__base"

ENT.Ephemeral = true

AccessorFuncDT(ENT, "Duration", "Float", 0)
AccessorFuncDT(ENT, "StartTime", "Float", 4)

function ENT:PlayerSet()
	self:SetStartTime(CurTime())

	local owner = self:GetOwner()
	if owner:IsValid() and owner.FrightDurationMul then
		local newdur = self:GetDuration() * owner.FrightDurationMul
		self.DieTime = CurTime() + newdur
		self:SetDuration(newdur)
	end
end
