ENT.Type = "point"

function ENT:Initialize()
	self.Class = self.Class or 1
	self.BossesEnabled = GAMEMODE.BossZombies
end

function ENT:Think()
end

function ENT:AcceptInput(name, activator, caller, args)
	name = string.lower(name)
	if string.sub(name, 1, 2) == "on" then
		self:FireOutput(name, activator, caller, args)
	elseif name == "lockclass" then
		local classname = string.lower(args)
		for k, v in ipairs(GAMEMODE.ZombieClasses) do
			if classname == "all" or string.lower(v.Name) == classname then
				v.Locked = true
				v.Unlocked = false

				net.Start("zs_classunlockstate")
					net.WriteInt(k, 8)
					net.WriteBool(v.Unlocked)
				net.Broadcast()

				if classname ~= "all" then
					for _, pl in pairs(player.GetAll()) do
						if pl:GetZombieClass() == k then
							for classid, classtab in ipairs(GAMEMODE.ZombieClasses) do
								if GAMEMODE:IsClassUnlocked(k) and not classtab.Hidden then
									pl.DeathClass = classid
									break
								end
							end
						end
					end
				end
			end
		end
	elseif name == "unlockclass" then
		local classname = string.lower(args)
		for k, v in ipairs(GAMEMODE.ZombieClasses) do
			if classname == "all" or string.lower(v.Name) == classname then
				v.Unlocked = true
				v.Locked = false

				net.Start("zs_classunlockstate")
					net.WriteInt(k, 8)
					net.WriteBool(v.Unlocked)
				net.Broadcast()
			end
		end
	elseif name == "defaultclass" then
		local classname = string.lower(args)
		for k, v in ipairs(GAMEMODE.ZombieClasses) do
			if string.lower(v.Name) == classname then
				v.IsDefault = true
				GAMEMODE.DefaultZombieClass = k
			else
				v.IsDefault = nil
			end
		end
	elseif name == "setbossesenabled" then
		self:KeyValue("BossesEnabled",args)
	end
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	if key == "class" then
		self.Class = value or self.Class
	elseif key == "bossesenabled" then
		local enabled = tonumber(value) == 1
		self.BossesEnabled = enabled
		GAMEMODE.BossZombies = enabled
	elseif string.sub(key, 1, 2) == "on" then
		self:AddOnOutput(key, value)
	end
end
