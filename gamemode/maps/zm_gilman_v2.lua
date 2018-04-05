-- This profile removes the ZM objectives from the map.

hook.Add("InitPostEntityMap", "MapProfile", function()
	for _, ent in pairs(ents.FindByClass("prop_dynamic*")) do
		if ent:GetModel() == "models/alyx.mdl" then
			ent:Remove()
		end
	end

	for _, ent in pairs(ents.FindByModel("models/items/car_battery01.mdl")) do
		ent:Remove()
	end
end)
