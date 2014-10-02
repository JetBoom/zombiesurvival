ENT.Type = "point"

ENT.ValidTeam = TEAM_HUMAN

function ENT:Add(pl, amount)
	if pl and pl:IsValid() and pl:IsPlayer() and pl:Team() == self.ValidTeam then
		amount = math.Round(amount)
		if amount < 0 then
			pl:TakePoints(-amount)
		else
			pl:AddPoints(amount)
		end
	end
end

function ENT:Set(pl, amount)
	if pl and pl:IsValid() and pl:IsPlayer() and pl:Team() == self.ValidTeam then
		self:SetAmount(pl, amount)
	end
end

function ENT:SetAmount(pl, amount)
	pl:SetPoints(amount)
end

function ENT:GetAmount(pl)
	return pl:GetPoints()
end

function ENT:CallIf(pl, amount)
	if pl and pl:IsValid() and pl:IsPlayer() then
		self:Input(pl:Team() == self.ValidTeam and self:GetAmount(pl) >= amount and "onconditionpassed" or "onconditionfailed", pl, self, amount)
	end
end

function ENT:CallIfNot(pl, amount)
	if pl and pl:IsValid() and pl:IsPlayer() then
		self:Input(pl:Team() == self.ValidTeam and self:GetAmount(pl) >= amount and "onconditionfailed" or "onconditionpassed", pl, self, amount)
	end
end

function ENT:AcceptInput(name, activator, caller, args)
	name = string.lower(name)
	local amount = tonumber(args) or 0
	if string.sub(name, 1, 2) == "on" then
		self:FireOutput(name, activator, caller, args)
	elseif name == "addtoactivator" then
		self:Add(activator, amount)
	elseif name == "takefromactivator" then
		self:Add(activator, -amount)
	elseif name == "addtocaller" then
		self:Add(caller, amount)
	elseif name == "takefromcaller" then
		self:Add(caller, -amount)
	elseif name == "callifactivatorhave" then
		self:CallIf(activator, amount)
	elseif name == "callifactivatornothave" then
		self:CallIfNot(activator, amount)
	elseif name == "callifcallerhave" then
		self:CallIf(caller, amount)
	elseif name == "callifcallernothave" then
		self:CallIfNot(caller, amount)
	elseif name == "setactivatoramount" then
		self:Set(activator, amount)
	elseif name == "setcalleramount" then
		self:Set(caller, amount)
	end
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	if string.sub(key, 1, 2) == "on" then
		self:AddOnOutput(key, value)
	end
end
