hook.Add("InitPostEntityMap", "Adding", function()
	for _, ent in pairs(ents.FindByClass("trigger_teleport")) do
		ent:Remove()
	end
	for _, ent in pairs(ents.FindByClass("func_button")) do
		ent:Remove()
	end
end)
