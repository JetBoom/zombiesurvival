hook.Add("InitPostEntityMap", "Adding", function()
	

	for _, ent in pairs(ents.FindByClass("item_ammo_crate")) do ent:Remove() end

	for _, ent in pairs(ents.FindByClass("trigger_hurt")) do ent:Remove() end

	for _, ent in pairs(ents.FindInSphere(Vector(447.7879, -630.0, 0), 32)) do ent:Remove() end
end)
