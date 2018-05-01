hook.Add("InitPostEntityMap", "Adding", function()
	

	for _, ent in pairs(ents.FindByName("Gunstoredoor")) do ent:Remove() end
	for _, ent in pairs(ents.FindByName("Store3F2")) do ent:Remove() end
	for _, ent in pairs(ents.FindByName("Store1F2")) do ent:Remove() end
end)
