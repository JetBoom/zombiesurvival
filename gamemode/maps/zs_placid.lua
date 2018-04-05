hook.Add("InitPostEntityMap", "Adding", function()
	

	local ent2 = ents.Create("env_fire")
	if ent2:IsValid() then
		ent2:SetPos(Vector(-3577.2402, -2450.1162, -398.9688))
		ent2:SetKeyValue("damagescale", 60)
		ent2:SetKeyValue("firesize", 200)
		ent2:Spawn()
		ent2:Fire("Enable", "", 0)
		ent2:Fire("StartFire", "", 0)
	end

	local ent3 = ents.Create("env_fire")
	if ent3:IsValid() then
		ent3:SetPos(Vector(-3696.8652, 2621.0576, -239.1022))
		ent3:SetKeyValue("damagescale", 60)
		ent3:SetKeyValue("firesize", 200)
		ent3:Spawn()
		ent3:Fire("Enable", "", 0)
		ent3:Fire("StartFire", "", 0)
	end
end)
