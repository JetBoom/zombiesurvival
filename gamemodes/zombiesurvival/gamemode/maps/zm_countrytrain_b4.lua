-- This profile removes the suitcases in the map to break the objectives from Zombie Master. Not doing this ruins the map.

hook.Add("InitPostEntityMap", "Adding", function()
	for _, ent in pairs(ents.FindByModel("models/props_c17/suitcase001a.mdl")) do
		ent:Remove()
	end
end)
