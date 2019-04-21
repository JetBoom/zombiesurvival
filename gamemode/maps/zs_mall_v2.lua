hook.Add("InitPostEntityMap", "Adding", function()
	

	for _, ent in pairs(ents.FindByClass("prop_physics")) do ent:Remove() end
end)
