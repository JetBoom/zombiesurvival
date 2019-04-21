hook.Add("InitPostEntityMap", "Adding", function()
	

	local ent2 = ents.Create("prop_dynamic_override")
	if ent2:IsValid() then
		ent2:SetPos(Vector(-255, 1215+53, 448))
		ent2:SetAngles(Angle(90, 270, 0))
		ent2:SetKeyValue("solid", "6")
		ent2:SetModel(Model("models/props_lab/blastdoor001c.mdl"))
		ent2:SetColor(Color(0, 0, 0, 0))
		ent2:Spawn()
	end

	local ent2 = ents.Create("prop_dynamic_override")
	if ent2:IsValid() then
		ent2:SetPos(Vector(0, 1215+53, 448))
		ent2:SetAngles(Angle(90, 270, 0))
		ent2:SetKeyValue("solid", "6")
		ent2:SetModel(Model("models/props_lab/blastdoor001c.mdl"))
		ent2:SetColor(Color(0, 0, 0, 0))
		ent2:Spawn()
	end

	local ent2 = ents.Create("prop_dynamic_override")
	if ent2:IsValid() then
		ent2:SetPos(Vector(-512-53, 575, 448))
		ent2:SetAngles(Angle(90, 0, 0))
		ent2:SetKeyValue("solid", "6")
		ent2:SetModel(Model("models/props_lab/blastdoor001c.mdl"))
		ent2:SetColor(Color(0, 0, 0, 0))
		ent2:Spawn()
	end

	local ent2 = ents.Create("prop_dynamic_override")
	if ent2:IsValid() then
		ent2:SetPos(Vector(-512-53, 830, 448))
		ent2:SetAngles(Angle(90, 0, 0))
		ent2:SetKeyValue("solid", "6")
		ent2:SetModel(Model("models/props_lab/blastdoor001c.mdl"))
		ent2:SetColor(Color(0, 0, 0, 0))
		ent2:Spawn()
	end

	for _, ent in pairs(ents.FindByClass("func_breakable")) do
		ent:Fire("Break", "", 0)
	end
	
	for _, ent in pairs(ents.FindByName("blastdoor2")) do
		ent:Fire("Break", "", 0)
	end
end)
