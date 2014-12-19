local SUPPORTER_MESSAGE = "JetBoom says: thank you for supporting my gamemodes!"

local CACHE = {
	MaxSize = 128,
	BufferTime = 6,
	Cache = {}
}

local Buffer = {}

function CACHE:Set(steamid, memberlevel, nolookup)
	if nolookup then
		table.insert(self.Cache, {steamid, memberlevel})
	else
		for i, tab in pairs(self.Cache) do
			if tab[1] == steamid then
				tab[2] = memberlevel
				return
			end
		end

		table.insert(self.Cache, {steamid, memberlevel})
	end

	if #self.Cache > self.MaxSize then
		table.remove(self.Cache, 1)
	end
end

function CACHE:Get(steamid)
	for i, tab in pairs(self.Cache) do
		if tab[1] == steamid then
			return tab[2]
		end
	end
end

function CACHE:Remove(steamid)
	for i, tab in pairs(self.Cache) do
		if tab[1] == steamid then
			table.remove(self.Cache, i)
			break
		end
	end
end

function CACHE:Save()
	local tosave = {}

	for steamid, level in pairs(self.Cache) do
		table.insert(tosave, steamid.."="..level)
	end

	file.Write("noxapi_cache.txt", table.concat(tosave, "\n"))
end

function CACHE:Load()
	if file.Exists("noxapi_cache.txt", "DATA") then
		self.Cache = {}

		for i, line in pairs(string.Explode("\n", file.Read("noxapi_cache.txt", "DATA"))) do
			local cont = string.Explode("=", line)
			local steamid, memberlevel = cont[1], tonumber(cont[2]) or 0

			self:Set(steamid, memberlevel, true)
		end
	end
end

function CACHE:BufferRequest()
	local IDS = {}
	for i=1, math.min(10, #Buffer) do
		IDS[#IDS + 1] = {Buffer[1][1], Buffer[1][2]}
		table.remove(Buffer, 1)
	end
	local SIDS = {}
	for k, v in pairs(IDS) do
		SIDS[k] = v[1]
	end

	http.Fetch("http://www.noxiousnet.com/api/player/memberlevel?steamids="..table.concat(SIDS, ","), function(body, len, headers, code)
		local levels = string.Explode(",", body)
		if #levels == #SIDS then
			for k, v in pairs(levels) do
				local steamid = IDS[k][1]

				local pl = IDS[k][2]
				if pl and pl:IsValid() then
					pl:SetDTBool(15, true)
					pl:PrintMessage(HUD_PRINTTALK, SUPPORTER_MESSAGE)
				end

				CACHE:Set(steamid, level)
			end
		end
	end)

	if #Buffer > 0 then
		CACHE:WaitForBuffer()
	end
end

function CACHE:WaitForBuffer()
	if not timer.Exists("noxapibuffer") then
		timer.Create("noxapibuffer", CACHE.BufferTime, 1, CACHE.BufferRequest)
	end
end

hook.Add("PlayerInitialSpawn", "noxapi", function(pl)
	if NDB or pl:IsBot() then return end

	local steamid = pl:SteamID()
	local memberlevel = CACHE:Get(steamid)
	if memberlevel then
		if level == 1 or level == 2 then
			pl:SetDTBool(15, true)
			pl:PrintMessage(HUD_PRINTTALK, SUPPORTER_MESSAGE)
		end
	else
		http.Fetch("http://www.noxiousnet.com/api/player/memberlevel?steamid="..steamid, function(body, len, headers, code)
			local level = tonumber(body) or 0

			if level == 1 or level == 2 then
				pl:SetDTBool(15, true)
				pl:PrintMessage(HUD_PRINTTALK, SUPPORTER_MESSAGE)
			end

			CACHE:Set(steamid, level)
		end)

		table.insert(Buffer, {steamid, pl})
		CACHE:WaitForBuffer()
	end
end)

hook.Add("Initialize", "noxapi", function()
	resource.AddFile("materials/noxiousnet/noxicon.png")

	if not NDB then
		CACHE:Load()
	end
end)

hook.Add("ShutDown", "noxapi", function()
	if not NDB then
		CACHE:Save()
	end
end)

concommand.Add("noxapi_forcerefresh", function(sender, command, arguments)
	if sender._ForcedNoxAPILookup or sender:IsNoxSupporter() then return end

	sender._ForcedNoxAPILookup = true

	local steamid = sender:SteamID()

	CACHE:Remove(steamid)

	http.Fetch("http://www.noxiousnet.com/api/player/memberlevel?steamid="..steamid, function(body, len, headers, code)
		local level = tonumber(body) or 0

		if level == 1 or level == 2 then
			pl:SetDTBool(15, true)
			pl:PrintMessage(HUD_PRINTTALK, SUPPORTER_MESSAGE)
		end

		CACHE:Set(steamid, level)
	end)
end)
