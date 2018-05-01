ENT.Type = "point"

function ENT:Initialize()
end

function ENT:Think()
end

function ENT:AcceptInput(name, activator, caller, args)
	name = string.lower(name)
	if name == "sethumanxpmulti" then
		self:SetKeyValue("humanxpmulti", args)

		return true
	elseif name == "setzombiexpmulti" then
		self:SetKeyValue("zombiexpmulti", args)

		return true
	end
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	if key == "humanxpmulti" then
		GAMEMODE.HumanXPMulti = math.max(0, tonumber(value)) or 1
	elseif key == "zombiexpmulti" then
		GAMEMODE.ZombieXPMulti = math.max(0, tonumber(value)) or 1
	end
end
