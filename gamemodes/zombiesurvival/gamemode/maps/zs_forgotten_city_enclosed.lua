hook.Add("InitPostEntityMap", "Adding", function()
	

	for _, ent in pairs(ents.FindByClass("info_player_counterterrorist")) do
		ent:Remove()
	end
end)
