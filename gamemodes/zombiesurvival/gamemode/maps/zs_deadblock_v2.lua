hook.Add("InitPostEntityMap", "Adding", function()
	-- I think its about time that this map be purged of blue shelves.
	for _, ent in pairs(ents.FindByClass("prop_physics")) do
		if ent:GetModel() == "models/props_wasteland/kitchen_shelf001a.mdl"then
			ent:Remove()
		end
	end
end)
