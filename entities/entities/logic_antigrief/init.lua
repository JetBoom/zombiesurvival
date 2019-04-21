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
				ent.m_AntiGrief = nil
			end
		end
		return true
	elseif name == "enablethese" then
		for _, entname in pairs(string.Explode(",", args)) do
			for __, ent in pairs(self:FindByNameHammer(entname, activator, caller)) do
				ent.m_AntiGrief = true
			end
		end
		return true
	end
end

function ENT:KeyValue(key, value)
end
