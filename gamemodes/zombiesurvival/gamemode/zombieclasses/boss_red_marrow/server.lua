AddCSLuaFile("shared.lua")
include("shared.lua")

function CLASS:OnSpawned(pl)
	for i=1,9 do
		pl["bloodth"..i] = true
	end
end
