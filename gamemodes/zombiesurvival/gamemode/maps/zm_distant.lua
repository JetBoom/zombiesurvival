hook.Add("InitPostEntityMap", "Adding", function()
	

	for _, ent in pairs(ents.FindByClass("trigger_teleport")) do
		ent:Remove()
	end

	local ent = ents.Create("prop_dynamic_override")
	if ent:IsValid() then
		ent:SetPos(Vector(-867.2750, -749.3450, -340.1626))
		ent:SetKeyValue("solid", "6")
		ent:SetModel(Model("models/props_lab/blastdoor001c.mdl"))
		ent:Spawn()
		ent:SetColor(Color(0, 0, 0, 255))
	end

	local ent = ents.Create("prop_dynamic_override")
	if ent:IsValid() then
		ent:SetPos(Vector(-497.7150, -1303.8472, 0))
		ent:SetAngles(Angle(90, 90, 0))
		ent:SetKeyValue("solid", "6")
		ent:SetModel(Model("models/props_lab/blastdoor001c.mdl"))
		ent:Spawn()
		ent:SetColor(Color(0, 0, 0, 255))
	end

	local ent = ents.Create("prop_dynamic_override")
	if ent:IsValid() then
		ent:SetPos(Vector(1394.0304, 1602.6035, 0.0313))
		ent:SetAngles(Angle(0, 90, 0))
		ent:SetKeyValue("solid", "6")
		ent:SetModel(Model("models/props_lab/blastdoor001c.mdl"))
		ent:Spawn()
		ent:SetColor(Color(0, 0, 0, 255))
	end

	local ent = ents.Create("prop_dynamic_override")
	if ent:IsValid() then
		ent:SetPos(Vector(448.1150, 217.9688, 247.7707))
		ent:SetAngles(Angle(90, 0, 90))
		ent:SetKeyValue("solid", "6")
		ent:SetModel(Model("models/props_lab/blastdoor001c.mdl"))
		ent:Spawn()
		ent:SetColor(Color(0, 0, 0, 255))
	end

	 local ent2 = ents.Create("prop_dynamic_override")
   if ent2:IsValid() then
      ent2:SetPos(Vector(250, 826, 568))
      ent2:SetAngles(Angle(0, 196, 90))
      ent2:SetKeyValue("solid", "6")
      ent2:SetModel(Model("models/props_lab/blastdoor001c.mdl"))
      ent2:SetColor(Color(0, 0, 0, 0))
      ent2:Spawn()
   end
   local ent2 = ents.Create("prop_dynamic_override")
   if ent2:IsValid() then
      ent2:SetPos(Vector(250, 826, 568))
      ent2:SetAngles(Angle(0, 165, 90))
      ent2:SetKeyValue("solid", "6")
      ent2:SetModel(Model("models/props_lab/blastdoor001c.mdl"))
      ent2:SetColor(Color(0, 0, 0, 0))
      ent2:Spawn()
   end
end)
