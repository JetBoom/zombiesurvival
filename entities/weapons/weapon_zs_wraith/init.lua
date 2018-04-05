AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

SWEP.MoanDelay = 3

--[[function SWEP:Think()
	self.BaseClass.Think(self)

	self:BarricadeGhostingThink()
end

function SWEP:Holster()
	if self.Owner:IsValid() then
		self.Owner:SetBarricadeGhosting(false)
	end

	return self.BaseClass.Holster(self)
end]]
