ENT.Type = "point"

function ENT:Initialize()
end

function ENT:Think()
end

function ENT:AcceptInput(name, activator, caller, args)
	name = string.lower(name)
	if name == "setstartingworth" then
		self:SetKeyValue("startingworth", args)
	end
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	if key == "startingworth" then
		GAMEMODE.OverrideStartingWorth = true
		GAMEMODE.StartingWorth = tonumber(value) or 100
	end
end
