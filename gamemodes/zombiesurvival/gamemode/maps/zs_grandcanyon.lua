hook.Add("InitPostEntityMap", "Adding", function()
	for _, v in pairs({Vector(3042.16, 3681.67, 798.82), Vector(2904.02, 3435.29, 805.14), Vector(3040.94, 3122.97, 792.33), Vector(2848.65, 1906.79, -164.03), Vector(3035.63, 1759.43, -140.87), Vector(-481.56, 1651.98, 492.01), Vector(-295.46, 2116.74, 482.67), Vector(2675.52, -858.01, 256.03), Vector(2710.39, -642.72, 256.03), Vector(3249.37, 370.77, 1232.03), Vector(3026.26, 645.87, 1232.03), Vector(-179.46, -1059.48, 803.04), Vector(-119.54, -1045.68, 787.50), Vector(-207.67, -1162.62, 810.87), Vector(3081.21, 3974.22, 816.03), Vector(2970.93, 3568.96, 803.32), Vector(-332.23, 4482.79, 800)}) do
		if math.random(1, 3) == 2 then
			local ent = ents.Create("info_player_human")
			if ent:IsValid() then
				ent:SetPos(v)
				ent:Spawn()
			end
		end
		local ent = ents.Create("info_player_zombie")
		if ent:IsValid() then
			ent:SetPos(v)
			ent:Spawn()
		end
	end
end)
