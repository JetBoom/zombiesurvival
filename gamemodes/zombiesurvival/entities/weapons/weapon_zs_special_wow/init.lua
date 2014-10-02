AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function SWEP:Deploy()
	self.Owner:CreateAmbience("ambience_wow")

	return true
end
