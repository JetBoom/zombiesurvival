ENT.Type = "brush"

function ENT:Initialize()
	self:SetTrigger(true)

	if self.On == nil then self.On = true end
end

function ENT:Think()
end

function ENT:AcceptInput(name, caller, activator, arg)
	name = string.lower(name)
	if name == "seton" then
		self.On = tonumber(arg) == 1
		return true
	elseif name == "enable" then
		self.On = true
		return true
	elseif name == "disable" then
		self.On = false
		return true
	end
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	if key == "enabled" then
		self.On = tonumber(value) == 1
	end
end

function ENT:Enter(ent)
	ent.ArsenalZone = self
end

function ENT:Leave(ent)
	ent.ArsenalZone = nil
end

function ENT:Touch(ent)
	if not self.On and ent:IsPlayer() and ent.ArsenalZone == self then
		self:Leave(ent)
	end
end

function ENT:StartTouch(ent)
	if self.On and ent:IsPlayer() and ent:Alive() and ent:Team() == TEAM_HUMAN and not ent.ArsenalZone then
		self:Enter(ent)
	end
end

function ENT:EndTouch(ent)
	if ent:IsPlayer() and ent.ArsenalZone == self then
		self:Leave(ent)
	end
end
