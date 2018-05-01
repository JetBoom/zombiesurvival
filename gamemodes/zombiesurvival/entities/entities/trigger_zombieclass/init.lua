ENT.Type = "brush"

function ENT:Initialize()
	self:SetTrigger(true)

	if self.On == nil then self.On = true end
	if self.InstantChange == nil then self.InstantChange = true end
	if self.OnlyWhenClass == nil then
		self.OnlyWhenClass = {}
		self.OnlyWhenClass[1] = -1
	end
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
		self.OnlyWhenClass = {}
		if value == "disabled" then
			self.OnlyWhenClass[1] = -1
		else
			self.OnlyWhenClass[1] = -1
			for i, allowed_class in pairs(string.Explode(",", string.lower(value))) do
				for k, v in ipairs(GAMEMODE.ZombieClasses) do
					if string.lower(v.Name) == allowed_class then
						self.OnlyWhenClass[i] = k
						break
					end
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
	if self.On and ent:IsValidLivingZombie() then
		local prev = ent:GetZombieClass()
		if table.HasValue( self.OnlyWhenClass, prev ) or self.OnlyWhenClass[1] == -1 then
			if class_name and class_name ~= string.lower(ent:GetZombieClassTable().Name) then
				for k, v in ipairs(GAMEMODE.ZombieClasses) do
					if string.lower(v.Name) == class_name then
						local prevpos = ent:GetPos()
						local prevang = ent:EyeAngles()
						ent:KillSilent()
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
						break
					end
				end
			end
			if death_class_name and death_class_name ~= string.lower(ent:GetZombieClassTable().Name) then
				for k, v in ipairs(GAMEMODE.ZombieClasses) do
					if string.lower(v.Name) == death_class_name then
						ent.DeathClass = k
					break
					end
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
