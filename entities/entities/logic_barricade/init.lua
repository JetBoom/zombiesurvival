ENT.Type = "point"

function ENT:Initialize()
end

function ENT:Think()
end

function ENT:AcceptInput(name, activator, caller, args)
	name = string.lower(name)
	if name == "disablethese" then
		for _, entname in pairs(string.Explode(",", args)) do
			for __, ent in pairs(self:FindByNameHammer(entname, activator, caller)) do
				ent.NoNails = true
			end
		end
		return true
	elseif name == "enablethese" then
		for _, entname in pairs(string.Explode(",", args)) do
			for __, ent in pairs(self:FindByNameHammer(entname, activator, caller)) do
				ent.NoNails = nil
			end
		end
		return true
	end
end

-- Just in case people use these as key values.
function ENT:KeyValue(key, value)
	key = string.lower(key)
	if key == "disablethese" or key == "enablethese" then
		self:Fire(key, value, 0)
	end
end
