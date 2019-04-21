hook.Add("InitPostEntityMap", "MPInitPostEntity", function()
	for _, ent in pairs(ents.FindByClass("func_button")) do
		ent:Remove()
	end

	ents.FindByClass("func_rot_button")[3]:Remove()
end)
