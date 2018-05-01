ENT.Type = "point"

function ENT:Initialize()
	if self.ForceSpawn == nil then self.ForceSpawn = false end
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	if key == "forcespawn" then
		self.ForceSpawn = tonumber(value) == 1
	end
end
