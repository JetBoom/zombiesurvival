hook.Add("InitPostEntityMap", "Adding", function()
	

	local ent = ents.Create("env_fire")
	if ent:IsValid() then
		ent:SetPos(Vector(4023.4456, 3151.3376, 0.0313))
		ent:SetKeyValue("damagescale", 60)
		ent:SetKeyValue("firesize", 200)
		ent:Spawn()
		ent:Fire("Enable", "", 0)
		ent:Fire("StartFire", "", 0)
	end

	local ent = ents.Create("env_fire")
	if ent:IsValid() then
		ent:SetPos(Vector(4120.3535, 2121.4338, 0.0313))
		ent:SetKeyValue("damagescale", 60)
		ent:SetKeyValue("firesize", 200)
		ent:Spawn()
		ent:Fire("Enable", "", 0)
		ent:Fire("StartFire", "", 0)
	end
end)
