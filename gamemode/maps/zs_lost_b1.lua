hook.Add("InitPostEntityMap", "Adding", function()
	-- The map has a super long hallway one way cade just like all subersive maps. This gets rid of human's favorite prop, but I think it would be best to remove the map from the server.
	for _, ent in pairs(ents.FindByClass("prop_physics")) do
		if ent:GetModel() == "models/props_wasteland/kitchen_shelf001a.mdl"then
			ent:Remove()
		end
	end
end)
