hook.Add("InitPostEntityMap", "Adding", function()
	

	for _, ent in pairs(ents.FindByClass("func_door*")) do ent:Remove() end
	for _, ent in pairs(ents.FindByClass("trigger_teleport")) do ent:Remove() end

	local ent2 = ents.Create("prop_dynamic_override")
	if ent2:IsValid() then
		ent2:SetPos(Vector(-0.7995, -28.3111, 0))
		ent2:SetAngles(Angle(0, 90, 0))
		ent2:SetKeyValue("solid", "6")
		ent2:SetModel(Model("models/props_lab/blastdoor001b.mdl"))
		ent2:Spawn()
		ent2:SetColor(Color(0, 0, 0, 0))
	end

	local ent2 = ents.Create("prop_dynamic_override")
	if ent2:IsValid() then
		ent2:SetPos(Vector(563.9561, -531.1329, -119.9688))
		ent2:SetKeyValue("solid", "6")
		ent2:SetModel(Model("models/props_lab/blastdoor001b.mdl"))
		ent2:Spawn()
		ent2:SetColor(Color(0, 0, 0, 255))
	end
end)
