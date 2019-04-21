hook.Add("InitPostEntityMap", "Adding", function()
	

	for _, ent in pairs(ents.FindInSphere(Vector(-360.8554, -766.1578, 35.3844))) do
		if ent:GetClass() == "info_player_human" then
			ent:Remove()
		end
	end
end)
