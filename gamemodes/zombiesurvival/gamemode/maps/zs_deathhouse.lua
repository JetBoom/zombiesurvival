hook.Add("InitPostEntityMap", "Adding", function()
	-- Gameplay is revolving around camping the 2nd floor which has the health charger. This isn't how I wanted the map to play so the health chargers need to go.
	for _, ent in pairs(ents.FindByClass("item_healthcharger")) do
			ent:Remove()
		end
	end
end)
