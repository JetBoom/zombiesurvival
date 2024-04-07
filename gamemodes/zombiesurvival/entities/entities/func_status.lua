ENT.Type = "brush"

ENT.TickTime = 0.5

function ENT:Initialize()
	self:SetTrigger(true)
	self:Fire("attack", "", self.TickTime)

	if self.On == nil then self.On = true end
	if self.Status == nil then self.Status = "slow" end
	if self.Linger == nil then self.Linger = false end
	if self.Duration == nil then self.Duration = 5 end
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
	elseif name == "attack" then
		self:Fire("attack", "", self.TickTime)

		for k,v in pairs(player.GetAll()) do
			if v:IsValidLivingHuman() and v.StatusZone == self then
				if not IsValid(v["status_" .. self.Status]) then
					v:GiveStatus(self.Status, self.Duration)
				end
			end
		end

		return true
	end
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	if key == "enabled" then
		self.On = tonumber(value) == 1
	elseif key == "status" then
		local val = string.lower(value)
		self.Status = (val == "slow" or val == "dimvision" or val == "enfeeble" or val == "frost") and val or "slow"
	elseif key == "linger" then
		self.Linger = tonumber(value) == 1
	elseif key == "duration" then
		self.Duration = tonumber(value)
	end
end

function ENT:Enter(ent)
	ent.StatusZone = self
end

function ENT:Leave(ent)
	if not self.Linger then
		if IsValid(ent["status_" .. self.Status]) then
			ent:RemoveStatus(self.Status)
		end
	end

	ent.StatusZone = nil
end

function ENT:Touch(ent)
	if not self.On and ent:IsPlayer() and ent.StatusZone == self then
		self:Leave(ent)
	end
end

function ENT:StartTouch(ent)
	if self.On and ent:IsPlayer() and ent:Alive() and ent:Team() == TEAM_HUMAN and not ent.StatusZone then
		self:Enter(ent)
	end
end

function ENT:EndTouch(ent)
	if ent:IsPlayer() and ent.StatusZone == self then
		self:Leave(ent)
	end
end
