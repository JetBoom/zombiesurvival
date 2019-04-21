hook.Add("InitPostEntityMap", "Adding", function()	
	-- The map has many viable spots, but one of them is vastly more viable than the rest due to a blue shelf. guess what this map profile does?
	for _, ent in pairs(ents.FindByClass("prop_physics")) do
		if ent:GetModel() == "models/props_wasteland/kitchen_shelf001a.mdl"then
			ent:Remove()
		end
	end
end)
