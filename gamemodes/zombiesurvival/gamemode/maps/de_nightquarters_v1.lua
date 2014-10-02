hook.Add("InitPostEntityMap", "Adding", function()
	

	local ent2 = ents.Create("env_fire")
	if ent2:IsValid() then
		ent2:SetPos(Vector(-341.7814, -380.7280, 345.9983))
		ent2:SetKeyValue("damagescale", 30)
		ent2:SetKeyValue("firesize", 200)
		ent2:Spawn()
		ent2:Fire("Enable", "", 0)
		ent2:Fire("StartFire", "", 0.1)
	end
end)
