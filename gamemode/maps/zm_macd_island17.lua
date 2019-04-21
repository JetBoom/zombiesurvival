hook.Add("InitPostEntityMap", "Adding", function()
	

	local ent = ents.Create("prop_dynamic_override")
	if ent:IsValid() then
		ent:SetPos(Vector(236, 1427, 660.5))
		ent:SetAngles(Angle(90, 0, 0))
		ent:SetKeyValue("solid", "6")
		ent:SetModel(Model("models/props_lab/blastdoor001c.mdl"))
		ent:Spawn()
		ent:SetColor(Color(0, 0, 0, 0))
	end
end)
