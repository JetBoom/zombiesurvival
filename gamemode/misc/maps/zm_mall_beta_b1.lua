hook.Add("InitPostEntityMap", "Adding", function()
	local ent = ents.Create("prop_dynamic_override")
	if ent:IsValid() then
		ent:SetPos(Vector(-1028.6432, -3061.5071, 812.0313))
		ent:SetModel("models/props_lab/blastdoor001a.mdl")
		ent:SetKeyValue("solid", "6")
		ent:Spawn()
	end

	ent = ents.Create("prop_dynamic_override")
	if ent:IsValid() then
		ent:SetPos(Vector(-1028.39, -3062.3708, 918.0627))
		ent:SetModel("models/props_lab/blastdoor001a.mdl")
		ent:SetKeyValue("solid", "6")
		ent:Spawn()
	end

	for _, ent in pairs(ents.FindByClass("prop_physics*")) do
		if ent:GetModel() == "models/props_wasteland/kitchen_shelf001a.mdl"then
			ent:Remove()
		end
	end
end)
