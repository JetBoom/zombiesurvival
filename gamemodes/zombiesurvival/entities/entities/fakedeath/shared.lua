ENT.Type = "anim"

AccessorFuncDT(ENT, "DeathSequence", "Int", 0)
AccessorFuncDT(ENT, "DeathAngles", "Angle", 0)
AccessorFuncDT(ENT, "DeathSequenceLength", "Float", 0)
AccessorFuncDT(ENT, "DeathSequenceStart", "Float", 1)
AccessorFuncDT(ENT, "RemoveTime", "Float", 2)

function ENT:SharedInitialize()
	self:SetSolid(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)

	self:UseClientSideAnimation(true)

	self.Created = CurTime()

	if self:GetDeathSequenceLength() == 0 then
		self:SetDeathSequenceLength(1)
	end

	if self:GetRemoveTime() == 0 then
		self:SetRemoveTime(CurTime() + 10)
	end
end
