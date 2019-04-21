ENT.Type = "point"

function ENT:AcceptInput(name, activator, caller, args)
	name = string.lower(name)
	if name == "enable" then
		GAMEMODE:SetPantsMode(true)
	elseif name == "disable" then
		GAMEMODE:SetPantsMode(false)
	end
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	if key == "enabled" then
		GAMEMODE:SetPantsMode(value ~= "0")
	end
end
