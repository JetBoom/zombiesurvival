hook.Add("InitPostEntityMap", "Adding", function()
	

	local ent2 = ents.Create("prop_dynamic_override")
	if ent2:IsValid() then
		ent2:SetPos(Vector(286.3725, 1232.6808, -491.9688))
		ent2:SetAngles(Angle(0, 90, 0))
		ent2:SetKeyValue("solid", "6")
		ent2:SetModel(Model("models/props_lab/blastdoor001c.mdl"))
		ent2:Spawn()
	end

	for _, ent in pairs(ents.FindInSphere(Vector(280.2706, 1271.7953, 0), 400)) do
		if string.find(ent:GetClass(), "info_player") then
			ent:Remove()
		end
	end
end)
