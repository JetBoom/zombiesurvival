AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

SWEP.Undroppable = true

function SWEP:OnDrop()
	if self:IsValid() then
		self.Weapon:Remove()
	end
end
