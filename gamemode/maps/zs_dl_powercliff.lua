hook.Add("InitPostEntityMap", "Adding", function()
	local pos = Vector(-2580, 2294, 48)
	for _, ent in pairs(ents.FindByClass("info_player_zombie")) do
		local rand = VectorRand()
		rand.z = 0
		rand = rand * 100

		ent:SetPos(pos + rand)
	end
end)
