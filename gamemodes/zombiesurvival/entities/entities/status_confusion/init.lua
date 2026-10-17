INC_SERVER()

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
	local curtime = CurTime()

	if curtime >= self:GetEndTime() or (self.EyeEffect and owner:IsValid() and owner:WaterLevel() >= 3) then
		self:Remove()
		return
	end

	self:NextThink(math.min(self:GetEndTime(), curtime + 0.25))
	return true
end

function ENT:OnRemove()
	local owner = self:GetOwner()
	if owner.Confusion == self then
		owner.Confusion = nil
		owner:SetDSP(0)
	end
end
