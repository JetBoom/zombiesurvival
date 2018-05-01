INC_SERVER()

ENT.TickTime = 1
ENT.Ticks = 10
ENT.HealPower = 2.5

function ENT:Initialize()
	local owner = self:GetOwner()

	self:DrawShadow(false)
	self.Ticks = math.floor(self.Ticks * (owner:IsValidLivingHuman() and owner.CloudTime or 1))

	self:Fire("heal", "", self.TickTime)
	self:Fire("kill", "", self.TickTime * self.Ticks + 0.01)
end

function ENT:AcceptInput(name, activator, caller, arg)
	if name ~= "heal" then return end

	self.Ticks = self.Ticks - 1

	local healer = self:GetOwner()
	if not healer:IsValidLivingHuman() then healer = self end

	local vPos = self:GetPos()
	for _, ent in pairs(ents.FindInSphere(vPos, self.Radius * (healer.CloudRadius or 1))) do
		if ent and ent:IsValidLivingHuman() and WorldVisible(vPos, ent:NearestPoint(vPos)) then
			healer:HealPlayer(ent, self.HealPower, 0.5, true)
		end
	end

	if self.Ticks > 0 then
		self:Fire("heal", "", self.TickTime)
	end

	return true
end
