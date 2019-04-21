hook.Add("InitPostEntityMap", "Adding", function()
	

	local ent2 = ents.Create("prop_dynamic_override")
	if ent2:IsValid() then
		ent2:SetPos(Vector(-541.4225, 15.8781, 512.0313))
		ent2:SetAngles(Angle(-60, 90, 0))
		ent2:SetKeyValue("solid", "6")
		ent2:SetModel(Model("models/props_lab/blastdoor001a.mdl"))
		ent2:Spawn()
	end

	local ent2 = ents.Create("prop_dynamic_override")
	if ent2:IsValid() then
		ent2:SetPos(Vector(-541.4225, -76.1219, 564.0313))
		ent2:SetAngles(Angle(-60, 90, 0))
		ent2:SetKeyValue("solid", "6")
		ent2:SetModel(Model("models/props_lab/blastdoor001a.mdl"))
		ent2:Spawn()
	end
end)
