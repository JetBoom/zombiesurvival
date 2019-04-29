ENT.Type = "point"

function ENT:Initialize()
	if not self.Initialized then -- Why is KeyValue() called before Initialize()?
		self.PartStrings = {} 
		self.Initialized = true
		self.DisplayTarget = self.DisplayTarget or ""
		self.ZSMessageMode = self.ZSMessageMode or 0
	end 
end

function ENT:Think()
end

function ENT:DisplayStrings()
	local FullString = ""
	for k,v in pairs(self.PartStrings) do
		FullString = FullString .. v
	end
	for k,v in pairs(ents.FindByName(self.DisplayTarget)) do
		local EntityClass = v:GetClass()
		if EntityClass == "game_text" then
			v:Input("AddOutput", self, self, "message "..FullString)
			v:Input("Display", self, self, FullString)
		elseif EntityClass == "point_zsmessage" then
			if self.ZSMessageMode == "1" then
				v:Input("sethumanhudmessage", self, self, FullString)
			elseif self.ZSMessageMode == "2" then
				v:Input("setzombiehudmessage", self, self, FullString)
			else
				v:Input("message", self, self, FullString)
			end
		elseif EntityClass == "point_worldhint" then
			v:Input("sethint", self, self, FullString)
		end
	end
	self:Input("OnDisplayed", self, self, FullString)
end

function ENT:AcceptInput(name, activator, caller, args)
	name = string.lower(name)
	if string.sub(name, 1, 2) == "on" then
		self:FireOutput(name, activator, caller, args)
	elseif string.sub(name, 1, 9) == "setstring" then
		self:KeyValue(string.sub(name, 4,11),args)
	elseif name == "displaystrings" then
		self:DisplayStrings()
	end
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	if string.sub(key, 1, 6) == "string" then 
		if not self.Initialized then 
			self.PartStrings = {} 
			self.Initialized = true
		end 
		local part = tonumber(string.sub(key,7,8))
		if part ~= nil then 
			self.PartStrings[part] = value
		end
	elseif key == "displayentity" then
		self.DisplayTarget = value
	elseif key == "zsmessagemode" then
		self.ZSMessageMode = value
	elseif string.sub(key, 1, 2) == "on" then
		self:AddOnOutput(key, value)
	end
end