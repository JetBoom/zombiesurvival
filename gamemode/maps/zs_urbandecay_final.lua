hook.Add("InitPostEntityMap", "Adding", function()
	

	for _, ent in pairs(ents.FindByClass("item_ammo_crate")) do ent:Remove() end
end)
