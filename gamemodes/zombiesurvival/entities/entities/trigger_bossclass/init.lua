ENT.Type = "brush"

function ENT:Initialize()
	self:SetTrigger(true)

	if self.On == nil then self.On = true end
	if self.Silent == nil then self.Silent = false end
	if self.InstantChange == nil then self.InstantChange = true end
end

function ENT:Think()
end

function ENT:AcceptInput(name, activator, caller, args)
	name = string.lower(name)
	if string.sub(name, 1, 2) == "on" then
		self:FireOutput(name, activator, caller, args)
	elseif name == "spawnboss" then
		GAMEMODE:SpawnBossZombie(false, self.Silent, self.BossIndex, true)
	elseif name == "seton" then
		self.On = tonumber(args) == 1
		return true
	elseif name == "enable" then
		self.On = true
		return true
	elseif name == "disable" then
		self.On = false
		return true
	elseif name == "setsilent" or name == "setinstantchange" or name == "setclass" then
		self:KeyValue(string.sub(name, 4), args)
	end
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	if string.sub(key, 1, 2) == "on" then
		self:AddOnOutput(key, value)
	elseif key == "enabled" then
		self.On = tonumber(value) == 1
	elseif key == "silent" then
		self.Silent = tonumber(value) == 1
	elseif key == "instantchange" then
		self.InstantChange = tonumber(value) == 1
	elseif key == "class" then
		self.BossIndex = nil
		for _, classtable in ipairs(GAMEMODE.ZombieClasses) do
			if classtable.Boss then
				local classname=GAMEMODE.ZombieClasses[classtable.Index].Name
				if string.lower(classname) == string.lower(value or "") then
					self.BossIndex = classtable.Index
					break
				end
			end
		end
	end
end

function ENT:StartTouch(ent)
	if self.On and ent:IsPlayer() and ent:Alive() and ent:Team() == TEAM_UNDEAD then
		if ent:GetZombieClassTable().Boss then
			self:Input("onbosstouched",ent,self,string.lower(ent:GetZombieClassTable().Name))
		else
			local prevpos = ent:GetPos()
			local prevang = ent:EyeAngles()
			GAMEMODE:SpawnBossZombie(ent, self.Silent, self.BossIndex, true)
			if self.InstantChange then
				ent:SetPos(prevpos)
				ent:SetEyeAngles(prevang)
			end
		end
	end
end
