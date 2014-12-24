ENT.Type = "brush"

function ENT:Initialize()
	self:SetTrigger(true)

	if self.On == nil then self.On = true end
	if self.InstantChange == nil then self.InstantChange = true end
	if self.OnlyWhenClass == nil then self.OnlyWhenClass = -1 end
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
	elseif name == "settouchclass" or name == "setendtouchclass" or name == "settouchdeathclass" or name == "setendtouchdeathclass" or name == "setonetime" or name == "setinstantchange" or name == "setonlywhenclass" then
		self:KeyValue(string.sub(name, 4), arg)
	end
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	if key == "enabled" then
		self.On = tonumber(value) == 1
	elseif key == "touchclass" then
		self.TouchClass = string.lower(value)
	elseif key == "onlywhenclass" then
		if value == "disabled" then 
			self.OnlyWhenClass = -1
		else
			for k, v in ipairs(GAMEMODE.ZombieClasses) do
				if string.lower(v.Name) == value then
					self.OnlyWhenClass = k
					break
				else
					self.OnlyWhenClass = -1
				end
			end
		end
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

function ENT:DoTouch(ent, class_name, death_class_name)
	if self.On and ent:IsPlayer() and ent:Alive() and ent:Team() == TEAM_UNDEAD then
		if class_name and class_name ~= string.lower(ent:GetZombieClassTable().Name) then
			for k, v in ipairs(GAMEMODE.ZombieClasses) do
				if string.lower(v.Name) == class_name then
					local prev = ent:GetZombieClass()
					if self.OnlyWhenClass == prev or self.OnlyWhenClass == -1 then
						local prevpos = ent:GetPos()
						local prevang = ent:EyeAngles()
						ent:SetZombieClass(k)
						ent.DidntSpawnOnSpawnPoint = true
						ent:UnSpectateAndSpawn()
						if self.OneTime then
							ent.DeathClass = prev
						end
						if self.InstantChange then
							ent:SetPos(prevpos)
							ent:SetEyeAngles(prevang)
						end
					end
					break
				end
			end
		elseif death_class_name and death_class_name ~= string.lower(ent:GetZombieClassTable().Name) then
			for k, v in ipairs(GAMEMODE.ZombieClasses) do
				if string.lower(v.Name) == death_class_name then
					ent.DeathClass = k
					break
				end
			end
		end
	end
end

function ENT:Touch(ent)
	self:DoTouch(ent, self.TouchClass, self.TouchDeathClass)
end
ENT.StartTouch = ENT.Touch

function ENT:EndTouch(ent)
	self:DoTouch(ent, self.EndTouchClass, self.EndTouchDeathClass)
end
