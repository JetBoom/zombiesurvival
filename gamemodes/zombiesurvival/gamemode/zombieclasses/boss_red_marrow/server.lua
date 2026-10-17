AddCSLuaFile("shared.lua")
include("shared.lua")

function CLASS:OnSpawned(pl)
	pl._bloodThresholds = { true, true, true, true, true, true, true, true, true }
end
