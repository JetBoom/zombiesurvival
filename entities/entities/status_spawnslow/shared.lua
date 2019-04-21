ENT.Type = "anim"
ENT.Base = "status__base"

AccessorFuncDT(ENT, "Duration", "Float", 0)
AccessorFuncDT(ENT, "StartTime", "Float", 4)

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	self.Seed = math.Rand(0, 10)

	if CLIENT then
		hook.Add("RenderScreenspaceEffects", self, self.RenderScreenspaceEffects)
	end

	hook.Add("Move", self, self.Move)
end

function ENT:Move(pl, move)
	if pl ~= self:GetOwner() then return end

	local sloweffect = 0.4

	move:SetMaxSpeed(move:GetMaxSpeed() * sloweffect)
	move:SetMaxClientSpeed(move:GetMaxClientSpeed() * sloweffect)
end

function ENT:PlayerSet()
	self:SetStartTime(CurTime())
end
