INC_SERVER()

function ENT:Think()
	local owner = self:GetOwner()

	if owner:GetStatus("shockdebuff") then
		self:Remove()
		return
	end

	if self.DieTime <= CurTime() then
		self:Remove()
	end

	self:NextThink(CurTime() + 0.1)
	return true
end
