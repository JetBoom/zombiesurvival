ENT.Type = "point"

function ENT:Initialize()
	self.EntityToWatch = self.EntityToWatch or "_____"
end

function ENT:Think()
end

function ENT:AcceptInput(name, activator, caller, args)
	name = string.lower(name)
	if string.sub(name, 1, 2) == "on" then
		self:FireOutput(name, activator, caller, args)
		return true
	elseif name == "disablepickup" then
		for _, ent in pairs(ents.FindByName(self.EntityToWatch)) do
			ent.m_NoPickup = true
		end
		return true
	elseif name == "enablepickup" then
		for _, ent in pairs(ents.FindByName(self.EntityToWatch)) do
			ent.m_NoPickup = nil
		end
		return true
	elseif name	== "forcedrop" then
		for _, ent in pairs(ents.FindByClass("status_human_holding")) do
			local object = ent:GetObject()
			if object:IsValid() and object:GetName() == self.EntityToWatch then
				ent:Remove()
			end
		end
		return true
	end
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	if key == "entitytowatch" then
		self.EntityToWatch = value or self.EntityToWatch
	elseif string.sub(key, 1, 2) == "on" then
		self:AddOnOutput(key, value)
	end
end
