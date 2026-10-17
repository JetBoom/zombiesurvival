ENT.Type = "point"

function ENT:Initialize()
	self.SendTo = self.SendTo or -1
	self.DisplayTime = self.DisplayTime or GAMEMODE.NotifyFadeTime
	self.Position = self.Position or "center"
	self.Red = self.Red or 255
	self.Green = self.Green or 255
	self.Blue = self.Blue or 255
end

function ENT:Think()
end

function ENT:AcceptInput(name, activator, caller, data)
	data = translate.MapText(data or "")
	name = string.lower(name or "")

	if name == "message" then
		data = data or ""
		data = string.gsub(data, "<.-=.->", "")
		data = string.gsub(data, "</.->", "")

		local TextColor = Color(self.Red, self.Green, self.Blue)

		if self.SendTo == 0 then
			if self.Position == "top" then
				GAMEMODE:TopNotifyAll(TextColor, data, {CustomTime = self.DisplayTime})
			else
				GAMEMODE:CenterNotifyAll(TextColor, data, {CustomTime = self.DisplayTime})
			end
		elseif self.SendTo == -1 then
			local target
			if IsValid(activator) and activator:IsPlayer() then
				target = activator
			elseif IsValid(caller) and caller:IsPlayer() then
				target = caller
			end

			if target then
				if self.Position == "top" then
					target:TopNotify(TextColor, data, {CustomTime = self.DisplayTime})
				else
					target:CenterNotify(TextColor, data, {CustomTime = self.DisplayTime})
				end
			end
		else
			for _, pl in pairs(player.GetAll()) do
				if pl:Team() == self.SendTo then
					if self.Position == "top" then
						pl:TopNotify(TextColor, data, {CustomTime = self.DisplayTime})
					else
						pl:CenterNotify(TextColor, data, {CustomTime = self.DisplayTime})
					end
				end
			end
		end

		return true
	elseif name == "setundeadhudmessage" or name == "setzombiehudmessage" then
		SetGlobalString("hudoverride"..TEAM_UNDEAD, data)
	elseif name == "sethumanhudmessage" or name == "setsurvivorhudmessage" then
		SetGlobalString("hudoverride"..TEAM_HUMAN, data)
	elseif name == "clearundeadhudmessage" or name == "clearzombiehudmessage" then
		SetGlobalString("hudoverride"..TEAM_UNDEAD, "")
	elseif name == "clearhumanhudmessage" or name == "clearsurvivorhudmessage" then
		SetGlobalString("hudoverride"..TEAM_HUMAN, "")
	elseif name == "setdisplaytime" then
		self.DisplayTime = tonumber(data)
	elseif name == "settextcolor" or name == "settextcolour" then
		self:ApplyColor(data)
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
	elseif key == "position" then
		self.Position = string.lower(value)
	elseif key == "textcolor" or key == "textcolour" then
		self:ApplyColor(value)
	end
end

function ENT:ApplyColor(colorstring)
	local col = string.ToColor(colorstring.." 255")
	self.Red = col.r or 255
	self.Green = col.g or 255
	self.Blue = col.b or 255
end
