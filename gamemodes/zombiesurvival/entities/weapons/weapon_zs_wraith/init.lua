INC_SERVER()

SWEP.MoanDelay = 3

--[[function SWEP:Think()
	self.BaseClass.Think(self)

	self:BarricadeGhostingThink()
end

function SWEP:Holster()
	if self:GetOwner():IsValid() then
		self:GetOwner():SetBarricadeGhosting(false)
	end

	return self.BaseClass.Holster(self)
end]]
