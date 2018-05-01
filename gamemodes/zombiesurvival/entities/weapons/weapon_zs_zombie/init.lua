INC_SERVER()

SWEP.MoanDelay = 1

function SWEP:Reload()
	if CurTime() < self:GetNextSecondaryFire() then return end
	self:SetNextSecondaryFire(CurTime() + self.MoanDelay)

	if self:IsMoaning() then
		self:StopMoaning()
	else
		self:StartMoaning()
	end
end
