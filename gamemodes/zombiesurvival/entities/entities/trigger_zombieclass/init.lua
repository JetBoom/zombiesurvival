ENT.Type = "brush"

function ENT:Initialize()
	self:SetTrigger(true)

	if self.On == nil then self.On = true end
	if self.InstantChange == nil then self.InstantChange = true end
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
	elseif name == "settouchclass" or name == "setendtouchclass" or name == "settouchdeathclass" or name == "setendtouchdeathclass" or name == "setonetime" or name == "setinstantchange" then
		self:KeyValue(string.sub(name, 4), arg)
	end
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	if key == "enabled" then
		self.On = tonumber(value) == 1
	elseif key == "touchclass" then
		self.TouchClass = string.lower(value)
	elseif key == "endtouchclass" then
		self.EndTouchClass = string.lower(value)
	elseif key == "touchdeathclass" then
		self.TouchDeathClass = string.lower(value)
	elseif key == "endtouchdeathclass" then
		self.EndTouchDeathClass = string.lower(value)
	elseif key == "onetime" then
		self.OneTime = tonumber(value) == 1
	elseif key == "instantchange" then
		self.InstantChange = tonumber(value) == 1
	end
end

function ENT:Touch(ent)
	if self.On and ent:IsPlayer() and ent:Alive() and ent:Team() == TEAM_UNDEAD then
		if self.TouchClass and self.TouchClass ~= string.lower(ent:GetZombieClassTable().Name) then
			for k, v in ipairs(GAMEMODE.ZombieClasses) do
				if string.lower(v.Name) == self.TouchClass then
					local prev = ent:GetZombieClass()
					local prevpos = ent:GetPos()
					ent:SetZombieClass(k)
					ent:UnSpectateAndSpawn()
					if self.OneTime then
						ent.DeathClass = prev
					end
					if self.InstantChange then
						ent:SetPos(prevpos)
					end

					break
				end
			end
		elseif self.TouchDeathClass and self.TouchDeathClass ~= string.lower(ent:GetZombieClassTable().Name) then
			for k, v in ipairs(GAMEMODE.ZombieClasses) do
				if string.lower(v.Name) == self.TouchDeathClass then
					ent.DeathClass = k
					break
				end
			end
		end
	end
end
ENT.StartTouch = ENT.Touch

function ENT:EndTouch(ent)
	if self.On and ent:IsPlayer() and ent:Alive() and ent:Team() == TEAM_UNDEAD then
		if self.EndTouchClass and self.EndTouchClass ~= string.lower(ent:GetZombieClassTable().Name) then
			for k, v in ipairs(GAMEMODE.ZombieClasses) do
				if string.lower(v.Name) == self.EndTouchClass then
					local prev = ent:GetZombieClass()
					local prevpos = ent:GetPos()
					ent:SetZombieClass(k)
					ent:UnSpectateAndSpawn()
					if self.OneTime then
						ent.DeathClass = prev
					end
					if self.InstantChange then
						ent:SetPos(prevpos)
					end

					break
				end
			end
		elseif self.EndTouchDeathClass and self.EndTouchDeathClass ~= string.lower(ent:GetZombieClassTable().Name) then
			for k, v in ipairs(GAMEMODE.ZombieClasses) do
				if string.lower(v.Name) == self.EndTouchDeathClass then
					ent.DeathClass = k
					break
				end
			end
		end
	end
end
