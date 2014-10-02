hook.Add("InitPostEntityMap", "Adding", function()
	

	-- Removes a bunch of lag.
	for _, ent in pairs(ents.FindByClass("func_smokevolume")) do ent:Remove() end
end)
