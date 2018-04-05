ENT.Type = "point"

function ENT:AcceptInput(name, activator, caller, args)
	name = string.lower(name)
	if name == "setzombiedamagemultiplier" then
		GAMEMODE.ZombieDamageMultiplier = tonumber(args) or 1
	elseif name == "setzombiespeedmultiplier" then
		GAMEMODE.ZombieSpeedMultiplier = tonumber(args) or 1
	end
end
