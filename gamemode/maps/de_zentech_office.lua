hook.Add("InitPostEntityMap", "Adding", function()
	for _, ent in pairs(ents.FindByClass("prop_physics*")) do ent:SetCollisionGroup(COLLISION_GROUP_NONE) end

	for _, ent in pairs(ents.FindByClass("func_button")) do ent:Remove() end
end)
