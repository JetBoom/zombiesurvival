hook.Add("InitPostEntityMap", "Adding", function()
	-- Block off impossible camping spot.
	local ent2 = ents.Create("prop_dynamic_override")
	if ent2:IsValid() then
		ent2:SetPos(Vector(-1019.9873, 1049.5773, 76.0313))
		ent2:SetAngles(Angle(0, 90, 0))
		ent2:SetKeyValue("solid", "6")
		ent2:SetModel(Model("models/props_lab/blastdoor001c.mdl"))
		ent2:Spawn()
	end

	-- Remove virtually impossible barricade in basement.
	for _, ent in pairs(ents.FindByClass("prop_physics*")) do
		if ent:GetPos().z < 100 then
			ent:Remove()
		end
	end
end)
