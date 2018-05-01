hook.Add("InitPostEntityMap", "Adding", function()
	for _, ent in pairs(ents.FindByClass("prop_physics*")) do
		if ent:GetModel() == "models/props_wasteland/kitchen_shelf001a.mdl"then
			ent:Remove()
		end
	end
end)
