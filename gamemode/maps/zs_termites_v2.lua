hook.Add("InitPostEntityMap", "Adding", function()
	

	local ent2 = ents.Create("prop_dynamic_override")
	if ent2:IsValid() then
		ent2:SetPos(Vector(179.0722, -540.1974, -190.9688))
		ent2:SetAngles(Angle(0, 90, 0))
		ent2:SetKeyValue("solid", "6")
		ent2:SetModel(Model("models/props_lab/blastdoor001c.mdl"))
		ent2:Spawn()
	end
end)
