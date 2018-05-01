hook.Add("InitPostEntityMap", "Adding", function()
	

	for _, ent in pairs(ents.FindByClass("func_door")) do
		ent:Remove()
	end
end)
