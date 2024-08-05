hook.Add("InitPostEntityMap", "Adding", function()
	for _, v in pairs(ents.FindByClass("info_player_*")) do
		local pos = v:GetPos()
		
		if pos == Vector(-1466.000000, -933.000000, 80.000000) then
			v:Remove()
		end
		
		if pos == Vector(-1304.000000, -1008.000000, 80.000000) then
			v:Remove()
		end
		
		if pos == Vector(-1371.000000, -1099.000000, 80.000000) then
			v:Remove()
		end
		
		if pos == Vector(-1315.000000, -1099.000000, 80.000000) then
			v:Remove()
		end
		
		if pos == Vector(-1466.000000, -877.000000, 80.000000) then
			v:Remove()
		end
		
		if pos == Vector(-1416.000000, -1008.000000, 80.000000) then
			v:Remove()
		end
		
		if pos == Vector(-1360.000000, -1008.000000, 80.000000) then
			v:Remove()
		end
	end
	
	for _, v in pairs({Vector(43.85, -527.57, 328.03), Vector(-1371.71, -843.65, 408.03), Vector(-1465.54, -873.10, 328.18), Vector(-1059.75, -774.52, 328.03), Vector(-1258.89, -892.01, 328.03), Vector(-629.26, -777.94, 328.02)}) do
		local ent = ents.Create("info_player_zombie")
		if ent:IsValid() then
			ent:SetPos(v)
			ent:Spawn()
		end
	end
end)