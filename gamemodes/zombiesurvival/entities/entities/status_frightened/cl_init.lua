INC_CLIENT()

function ENT:OnInitialize()
	local owner = self:GetOwner()
	if owner ~= MySelf then return end

	owner:SetDSP(31, false)
	self.AmbientSound = CreateSound(self, "player/breathe1.wav")
	self.AmbientSound:Play()
	self.AmbientSound2 = CreateSound(self, "player/heartbeat1.wav")
	self.AmbientSound2:Play()
end

function ENT:OnRemove()
	local owner = self:GetOwner()
	if owner == MySelf then
		self.AmbientSound:Stop()
		self.AmbientSound2:Stop()
		owner:SetDSP(0, false)
	end

	self.BaseClass.OnRemove(self)
end
