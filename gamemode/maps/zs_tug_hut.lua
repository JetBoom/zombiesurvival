hook.Add("InitPostEntityMap", "Adding", function()
	local ent = ents.Create("prop_dynamic_override")
	if ent:IsValid() then
		ent:SetPos(Vector(-890.3486, 71.1159, 140.0313))
		ent:SetAngles(Angle(0, 90, 0))
		ent:SetModel("models/props_lab/blastdoor001a.mdl")
		ent:SetKeyValue("solid", "6")
		ent:Spawn()
	end

	local ent = ents.Create("prop_dynamic_override")
	if ent:IsValid() then
		ent:SetPos(Vector(-1083.4521, -107.9099, 140.0313))
		ent:SetModel("models/props_lab/blastdoor001a.mdl")
		ent:SetKeyValue("solid", "6")
		ent:Spawn()
	end

	for _, ent in pairs(ents.FindByClass("item_healthcharger")) do
			ent:Remove()
		end
	end
end)
