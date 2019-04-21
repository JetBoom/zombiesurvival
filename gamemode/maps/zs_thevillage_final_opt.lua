hook.Add("InitPostEntityMap", "Adding", function()
	local ent2 = ents.Create("prop_dynamic_override")
	if ent2:IsValid() then
		ent2:SetPos(Vector(-579, 220, 83))
		ent2:SetAngles(Angle(0, 0, 0))
		ent2:SetKeyValue("solid", "6")
		ent2:SetModel(Model("models/props_c17/oildrum001.mdl"))
		ent2:Spawn()
	end

	local ent2 = ents.Create("prop_dynamic_override")
	if ent2:IsValid() then
		ent2:SetPos(Vector(-557, 216, 91))
		ent2:SetAngles(Angle(20.5, 180, -180))
		ent2:SetKeyValue("solid", "6")
		ent2:SetModel(Model("models/props_junk/CinderBlock01a.mdl"))
		ent2:Spawn()
	end

	local ent2 = ents.Create("prop_dynamic_override")
	if ent2:IsValid() then
		ent2:SetPos(Vector(-582, 230, 133))
		ent2:SetAngles(Angle(90, 24.5, 0))
		ent2:SetKeyValue("solid", "6")
		ent2:SetModel(Model("models/props_junk/CinderBlock01a.mdl"))
		ent2:Spawn()
	end

	local ent2 = ents.Create("prop_dynamic_override")
	if ent2:IsValid() then
		ent2:SetPos(Vector(-587, 234, 144))
		ent2:SetAngles(Angle(0, 90, 90))
		ent2:SetKeyValue("solid", "6")
		ent2:SetModel(Model("models/props_junk/CinderBlock01a.mdl"))
		ent2:Spawn()
	end
	
	for _, ent in pairs(ents.FindByName("lift")) do
		ent:SetKeyValue("blockdamage", 0)
	end
end)
