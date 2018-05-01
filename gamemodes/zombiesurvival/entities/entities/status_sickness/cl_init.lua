INC_CLIENT()

function ENT:OnInitialize()
	local owner = self:GetOwner()
	if owner ~= MySelf then return end

	self.AmbientSound = CreateSound(self, "player/heartbeat1.wav")
	self.AmbientSound:PlayEx(1, 222)
end

function ENT:OnRemove()
	local owner = self:GetOwner()
	if owner == MySelf then
		self.AmbientSound:Stop()
	end

	self.BaseClass.OnRemove(self)
end
