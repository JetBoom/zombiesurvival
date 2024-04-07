ENT.Type = "anim"
ENT.Base = "status__base"

ENT.Ephemeral = true

AccessorFuncDT(ENT, "Duration", "Float", 0)
AccessorFuncDT(ENT, "StartTime", "Float", 4)

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	self:DrawShadow(false)

	if CLIENT then
		hook.Add("RenderScreenspaceEffects", self, self.RenderScreenspaceEffects)
	end

	self:GetOwner().DimVision = self
end

function ENT:OnRemove()
	self.BaseClass.OnRemove(self)

	self:GetOwner().DimVision = nil
end

function ENT:PlayerSet()
	self:SetStartTime(CurTime())

	local owner = self:GetOwner()
	if owner:IsValid() and owner.VisionAlterDurationMul then
		local newdur = self:GetDuration() * owner.VisionAlterDurationMul
		self.DieTime = CurTime() + newdur
		self:SetDuration(newdur)
	end
end
