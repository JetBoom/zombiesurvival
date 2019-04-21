hook.Add("InitPostEntityMap", "Adding", function()
	

	local ent2 = ents.Create("prop_dynamic_override")
	if ent2:IsValid() then
		ent2:SetPos(Vector(2702, 377, 47))
		ent2:SetAngles(Angle(0, 0, 0))
		ent2:SetKeyValue("solid", "6")
		ent2:SetModel(Model("models/props_wasteland/controlroom_filecabinet001a.mdl"))
		ent2:Spawn()
	end
end)
