local function PlayerInitialSpawn(pl)
	http.Fetch("http://www.noxiousnet.com/api/player/memberlevel?steamid="..pl:SteamID(), function(body, len, headers, code)
		local level = tonumber(body)
		if level == 1 or level == 2 then
			pl._SUPPORTER_ = true
			pl:PrintMessage(HUD_PRINTCONSOLE, "GREETINGS FROM NOX, FELLOW SUPPORTER!")
		end
	end)
end

--if not NDB then
	--hook.Add("PlayerInitialSpawn", "noxapi", PlayerInitialSpawn)
--end

hook.Add("Initialize", "noxapi", function()
	resource.AddFile("materials/noxiousnet/noxicon.png")
end)
