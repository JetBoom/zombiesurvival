-- Removes teleports and other annoying ZM garbage.

hook.Add("InitPostEntityMap", "Adding", function()
	for _, ent in pairs(ents.FindByClass("trigger_push")) do ent:Remove() end
	for _, ent in pairs(ents.FindByClass("trigger_teleport")) do ent:Remove() end
end)
