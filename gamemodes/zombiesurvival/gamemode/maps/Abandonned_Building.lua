hook.Add("InitPostEntityMap", "Adding", function()
	

	for _, ent in pairs(ents.FindByClass("func_button")) do ent:Remove() end

	local tsp = {}
	local ctsp = {}

	for _, ent in pairs(ents.FindByClass("info_player_terrorist")) do
		table.insert(tsp, ent)
	end

	for _, ent in pairs(ents.FindByClass("info_player_counterterrorist")) do
		table.insert(ctsp, ent)
	end

	for _, ent in pairs(tsp) do
		local newent = ents.Create("info_player_counterterrorist")
		if newent:IsValid() then
			newent:SetPos(ent:GetPos())
			newent:SetAngles(ent:GetAngles())
			newent:Spawn()
		end
	end

	for _, ent in pairs(ctsp) do
		local newent = ents.Create("info_player_terrorist")
		if newent:IsValid() then
			newent:SetPos(ent:GetPos())
			newent:SetAngles(ent:GetAngles())
			newent:Spawn()
		end
	end

	for _, ent in pairs(tsp) do
		ent:Remove()
	end

	for _, ent in pairs(ctsp) do
		ent:Remove()
	end
end)
