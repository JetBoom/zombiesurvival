INC_CLIENT()

SWEP.ViewModelFOV = 47

--[[function SWEP:Holster()
	if self:GetOwner():IsValid() and self:GetOwner() == MySelf then
		self:GetOwner():SetBarricadeGhosting(false)
	end

	return self.BaseClass.Holster(self)
end]]

function SWEP:PreDrawViewModel(vm)
	self:GetOwner():CallZombieFunction0("PrePlayerDraw")
end

function SWEP:PostDrawViewModel(vm)
	self:GetOwner():CallZombieFunction0("PostPlayerDraw")
end

--[[function SWEP:Think()
	self.BaseClass.Think(self)

	if self:GetOwner():IsValid() and MySelf == self:GetOwner() then
		self:BarricadeGhostingThink()
	end
end]]
