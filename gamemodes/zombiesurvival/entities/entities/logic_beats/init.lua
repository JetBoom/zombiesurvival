ENT.Type = "point"

function ENT:AcceptInput(name, activator, caller, args)
	name = string.lower(name)
	if name == "enable" then
		SetGlobalBool("beatsdisabled", false)
	elseif name == "disable" then
		SetGlobalBool("beatsdisabled", true)
	end
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	if key == "enabled" then
		SetGlobalBool("beatsdisabled", value == "0")
	end
end
