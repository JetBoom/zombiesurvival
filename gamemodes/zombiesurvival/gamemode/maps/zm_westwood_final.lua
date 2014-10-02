hook.Add("InitPostEntityMap", "Adding", function()
	

	local ent2 = ents.Create("prop_dynamic_override")
	if ent2:IsValid() then
		ent2:SetPos(Vector(-263, -566, -116))
		ent2:SetAngles(Angle(90, 0, 0))
		ent2:SetKeyValue("solid", SOLID_VPHYSICS)
		ent2:SetModel(Model("models/props_lab/blastdoor001b.mdl"))
		ent2:Spawn()
	end

	local ent2 = ents.Create("prop_dynamic_override")
	if ent2:IsValid() then
		ent2:SetPos(Vector(400, -792, -116))
		ent2:SetAngles(Angle(90, 0, 0))
		ent2:SetKeyValue("solid", SOLID_VPHYSICS)
		ent2:SetModel(Model("models/props_lab/blastdoor001b.mdl"))
		ent2:Spawn()
	end

	local ent2 = ents.Create("prop_dynamic_override")
	if ent2:IsValid() then
		ent2:SetPos(Vector(400, -858, -116))
		ent2:SetAngles(Angle(90, 0, 0))
		ent2:SetKeyValue("solid", SOLID_VPHYSICS)
		ent2:SetModel(Model("models/props_lab/blastdoor001b.mdl"))
		ent2:Spawn()
	end

	local ent2 = ents.Create("prop_dynamic_override")
	if ent2:IsValid() then
		ent2:SetPos(Vector(576, -851, -116))
		ent2:SetAngles(Angle(90, 0, 0))
		ent2:SetKeyValue("solid", SOLID_VPHYSICS)
		ent2:SetModel(Model("models/props_lab/blastdoor001b.mdl"))
		ent2:Spawn()
	end
end)
