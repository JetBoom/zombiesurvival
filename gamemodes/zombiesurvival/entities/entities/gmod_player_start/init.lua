-- This makes old gmod9 ZS maps playable

ENT.Type = "point"

function ENT:Initialize()
	if self.RedTeam or self.GreenTeam or self.YellowTeam or self.BlueTeam then
		self.BlueTeam = self.BlueTeam or false
		self.GreenTeam = self.GreenTeam or false
		self.YellowTeam = self.YellowTeam or false
		self.RedTeam = self.RedTeam or false
	else
		self.BlueTeam = true
		self.GreenTeam = true
		self.YellowTeam = true
		self.RedTeam = true
	end
	self.Entity:GetTable().BlueTeam = self.BlueTeam
	self.Entity:GetTable().GreenTeam = self.GreenTeam
	self.Entity:GetTable().RedTeam = self.RedTeam
	self.Entity:GetTable().YellowTeam = self.YellowTeam
end

function ENT:KeyValue(key, value)
	if key == "spawnflags" then
		local sf = tonumber(value)
		for i=15, 0, -1 do
			local bit = math.pow(2, i)
			if sf - bit >= 0 then
				if bit == 8 then self.RedTeam = true self.Entity:GetTable().RedTeam = true
				elseif bit == 4 then self.GreenTeam = true self.Entity:GetTable().GreenTeam = true
				elseif bit == 2 then self.YellowTeam = true self.Entity:GetTable().YellowTeam = true
				elseif bit == 1 then self.BlueTeam = true self.Entity:GetTable().BlueTeam = true
				end
				sf = sf - bit
			else
				if bit == 8 then self.RedTeam = false self.Entity:GetTable().RedTeam = false
				elseif bit == 4 then self.GreenTeam = false self.Entity:GetTable().GreenTeam = false
				elseif bit == 2 then self.YellowTeam = false self.Entity:GetTable().YellowTeam = false
				elseif bit == 1 then self.BlueTeam = false self.Entity:GetTable().BlueTeam = false
				end
			end
		end
	end
end