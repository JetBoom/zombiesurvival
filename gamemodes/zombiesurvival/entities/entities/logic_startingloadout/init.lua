ENT.Type = "point"

function ENT:Initialize()
end

function ENT:Think()
end

function ENT:AcceptInput(name, activator, caller, args)
	name = string.lower(name)
	if name == "setstartingloadout" then
		self:SetKeyValue("startingloadout", args)

		return true
	elseif name == "setredeemloadout" then
		self:SetKeyValue("redeemloadout", args)

		return true
	end
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	if key == "startingloadout" then
		if value == "worth" then
			GAMEMODE.StartingLoadout = nil
		elseif value == "none" then
			GAMEMODE.StartingLoadout = {}
		else
			local tab = {}
			for k, v in pairs(string.Explode(",", value)) do
				local item, amount = string.match(v, "(.+):(%d+)")
				if item and amount then
					tab[item] = tonumber(amount) or 1
				end
			end

			GAMEMODE.StartingLoadout = tab
		end
	elseif key == "redeemloadout" then
		if value == "none" then
			GAMEMODE.RedeemLoadout = {}
		else
			local tab = {}
			for k, v in pairs(string.Explode(",", value)) do
				local item, amount = string.match(v, "(.+):(%d+)")
				if item and amount then
					tab[item] = tonumber(amount) or 1
				end
			end

			GAMEMODE.RedeemLoadout = tab
		end
	end
end
