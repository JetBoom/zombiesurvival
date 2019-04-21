hook.Add("InitPostEntityMap", "Adding", function()
	local Placements = {
		Vector(-2025, 1110, -770),
		Vector(-2370, 1100, -855)
	}

	for _, pos in pairs(Placements) do
		local ent2 = ents.Create("prop_dynamic_override")
		if ent2:IsValid() then
			ent2:SetPos(pos)
			ent2:SetKeyValue("solid", "6")
			ent2:SetModel("models/props_lab/blastdoor001c.mdl")
			ent2:Spawn()
		end
	end
end)
