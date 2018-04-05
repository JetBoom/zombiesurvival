-- thanks garry

local ENT = {}

ENT.Type = "point"

function ENT:Initialize()
end

function ENT:Think()
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	if key == "disabled" then
		self.Disabled = tonumber(value) == 1
	elseif key == "active" then
		self.Disabled = tonumber(value) == 0
	end
end

function ENT:AcceptInput(name, activator, caller, arg)
	name = string.lower(name)
	if name == "enable" then
		self.Disabled = false
		return true
	elseif name == "disable" then
		self.Disabled = true
		return true
	elseif name == "toggle" then
		self.Disabled = not self.Disabled
		return true
	end
end

function GM:RegisterPlayerSpawnEntities()
	scripted_ents.Register(ENT, "info_player_zombie")
	scripted_ents.Register(ENT, "info_player_undead")
	scripted_ents.Register(ENT, "info_player_human")
end
