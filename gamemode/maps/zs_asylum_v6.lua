hook.Add("InitPostEntityMap", "Adding", function()
	

	for _, ent in pairs(ents.FindInSphere(Vector(968.1165, 953.7861, 16.0313), 100)) do
		if ent:GetClass() == "info_player_human" then
			ent:Remove()
		end
	end
end)
