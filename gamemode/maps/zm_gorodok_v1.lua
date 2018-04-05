-- This profile gets rid of laggy func_dustcloud's

hook.Add("InitPostEntityMap", "Adding", function()
	

	for _, ent in pairs(ents.FindByClass("func_dustcloud")) do
		ent:Remove()
	end
end)
