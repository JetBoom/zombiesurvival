hook.Add("InitPostEntityMap", "Adding", function()
	

	local ent2 = ents.Create("prop_dynamic_override")
	if ent2:IsValid() then
		ent2:SetPos(Vector(-413.3240, 2016.3511, 247.6189))
		ent2:SetAngles(Angle(0, 90, 0))
		ent2:SetKeyValue("solid", "6")
		ent2:SetModel(Model("models/props_lab/blastdoor001c.mdl"))
		ent2:Spawn()
		ent2:SetColor(Color(0, 0, 0, 0))
	end

	local ent2 = ents.Create("prop_dynamic_override")
	if ent2:IsValid() then
		ent2:SetPos(Vector(-413.3240, 2016.3511, 354.1814))
		ent2:SetAngles(Angle(0, 90, 0))
		ent2:SetKeyValue("solid", "6")
		ent2:SetModel(Model("models/props_lab/blastdoor001c.mdl"))
		ent2:Spawn()
		ent2:SetColor(Color(0, 0, 0, 0))
	end

	local ent2 = ents.Create("prop_dynamic_override")
	if ent2:IsValid() then
		ent2:SetPos(Vector(1141.4768, 2121.8750, 128.0313))
		ent2:SetAngles(Angle(0, 90, 0))
		ent2:SetKeyValue("solid", "6")
		ent2:SetModel(Model("models/props_lab/blastdoor001c.mdl"))
		ent2:Spawn()
		ent2:SetColor(Color(0, 0, 0, 0))
	end

	local ent2 = ents.Create("prop_dynamic_override")
	if ent2:IsValid() then
		ent2:SetPos(Vector(-502.0918, 2096.4048, 128.0313))
		ent2:SetAngles(Angle(0, 90, 0))
		ent2:SetKeyValue("solid", "6")
		ent2:SetModel(Model("models/props_lab/blastdoor001c.mdl"))
		ent2:Spawn()
		ent2:SetColor(Color(0, 0, 0, 0))
	end

	local ent2 = ents.Create("prop_dynamic_override")
	if ent2:IsValid() then
		ent2:SetPos(Vector(-332.6040, 2233.0410, 128.0313))
		ent2:SetKeyValue("solid", "6")
		ent2:SetModel(Model("models/props_lab/blastdoor001c.mdl"))
		ent2:Spawn()
		ent2:SetColor(Color(0, 0, 0, 0))
	end
end)
