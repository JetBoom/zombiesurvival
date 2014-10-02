hook.Add("InitPostEntityMap", "Adding", function()
	

	for _, ent in pairs(ents.FindByClass("point_worldhint")) do ent:Remove() end
end)
