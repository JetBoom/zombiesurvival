ENT.Type = "point"

function ENT:Initialize()
	self.Infliction = self.Infliction or 0.5
end

function ENT:Think()
end

function ENT:AcceptInput(name, activator, caller, args)
	name = string.lower(name)
	if string.sub(name, 1, 2) == "on" then
		self:FireOutput(name, activator, caller, args)
	elseif name == "capinfliction" then
		GAMEMODE.CappedInfliction = math.max(GAMEMODE.CappedInfliction, tonumber(args) or 0)
	elseif name == "setinfliction" then
		GAMEMODE.CappedInfliction = tonumber(args) or 0
	end
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	if key == "infliction" then
		self.Infliction = tonumber(value) or self.Infliction
	elseif string.sub(key, 1, 2) == "on" then
		self:AddOnOutput(key, value)
	end
end
