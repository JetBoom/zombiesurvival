hook.Add("InitPostEntityMap", "Adding", function()
	

	for _, ent in pairs(ents.FindByClass("prop_physics")) do
		if ent:GetModel() == "models/props_c17/furniturecouch001a.mdl" and ent:GetPos().z > 160 then
			ent:Remove()
		end
	end
end)
