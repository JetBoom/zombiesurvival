ENT.Type = "point"

function ENT:Initialize()
end

function ENT:Think()
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	if key == "winmulti" then
		GAMEMODE.WinXPMulti = tonumber(value) or 1
	end
end
