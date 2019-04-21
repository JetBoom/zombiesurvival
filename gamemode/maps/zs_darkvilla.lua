hook.Add("InitPostEntityMap", "Adding", function()
	

	for _, ent in pairs(ents.FindByClass("trigger_teleport")) do
		ent:Remove()
	end

	for _, ent in pairs(ents.FindByClass("func_button")) do
		ent:Remove()
	end

	for _, ent in pairs(ents.FindByClass("prop_dynamic")) do
		local pro = ents.Create("prop_physics")
		if pro:IsValid() then
			pro:SetModel(ent:GetModel())
			pro:SetPos(ent:GetPos())
			pro:SetAngles(ent:GetAngles())
			pro:Spawn()
			ent:Remove()
		end
	end

	local ent2 = ents.Create("prop_dynamic_override")
	if ent2:IsValid() then
		ent2:SetPos(Vector(900, -228, -151))
		ent2:SetAngles(Angle(0, 180, 0))
		ent2:SetKeyValue("solid", "6")
		ent2:SetModel(Model("models/props_lab/blastdoor001b.mdl"))
		ent2:SetColor(Color(0, 0, 0, 0))
		ent2:Spawn()
	end
end)
