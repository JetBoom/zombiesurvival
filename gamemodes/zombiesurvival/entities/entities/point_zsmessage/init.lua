ENT.Type = "point"

function ENT:Initialize()
	self.SendTo = self.SendTo or -1
	self.DisplayTime = self.DisplayTime or GAMEMODE.NotifyFadeTime
end

function ENT:Think()
end

function ENT:AcceptInput(name, caller, activator, args)
	name = string.lower(name)
	if name == "message" then
		args = args or ""

		args = string.gsub(args, "<.-=.->", "")
		args = string.gsub(args, "</.->", "")

		if self.SendTo == 0 then
			GAMEMODE:CenterNotifyAll(args,{CustomTime = self.DisplayTime})
		elseif self.SendTo == -1 then
			for _, pl in pairs(player.GetAll()) do
				if pl == activator or pl == caller then
					pl:CenterNotify(args,{CustomTime = self.DisplayTime})
					break
				end
			end
		else
			for _, pl in pairs(player.GetAll()) do
				if pl:Team() == self.SendTo then
					pl:CenterNotify(args,{CustomTime = self.DisplayTime})
				end
			end
		end

		return true
	elseif name == "setundeadhudmessage" or name == "setzombiehudmessage" then
		SetGlobalString("hudoverride"..TEAM_UNDEAD, args)
	elseif name == "sethumanhudmessage" or name == "setsurvivorhudmessage" then
		SetGlobalString("hudoverride"..TEAM_HUMAN, args)
	elseif name == "clearundeadhudmessage" or name == "clearzombiehudmessage" then
		SetGlobalString("hudoverride"..TEAM_UNDEAD, "")
	elseif name == "clearhumanhudmessage" or name == "clearsurvivorhudmessage" then
		SetGlobalString("hudoverride"..TEAM_HUMAN, "")
	elseif name == "setdisplaytime" then
		self.DisplayTime = tonumber(args)
	end
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	if key == "team" then
		value = string.lower(value or "")
		if value == "zombie" or value == "undead" or value == "zombies" then
			self.SendTo = TEAM_UNDEAD
		elseif value == "human" or value == "humans" then
			self.SendTo = TEAM_HUMAN
		elseif value == "activator" or value == "caller" or value == "private" then
			self.SendTo = -1
		else
			self.SendTo = 0
		end
	elseif key == "displaytime" then
		self.DisplayTime = tonumber(value)
	end
end
