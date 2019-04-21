ENT.Type = "point"

function ENT:AcceptInput(name, activator, caller, args)
	name = string.lower(name)
	if name == "enable" then
		GAMEMODE:SetDynamicSpawning(true)
	elseif name == "disable" then
		GAMEMODE:SetDynamicSpawning(false)
	end
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	if key == "enabled" then
		GAMEMODE:SetDynamicSpawning(value ~= "0")
	end
end
