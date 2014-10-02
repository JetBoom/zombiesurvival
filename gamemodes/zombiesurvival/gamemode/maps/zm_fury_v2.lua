hook.Add("InitPostEntityMap", "Adding", function()
	

	local ent = ents.Create("prop_dynamic_override")
	if ent:IsValid() then
		ent:SetPos(Vector(-48.8903, 1088.3591, -407.9688))
		ent:SetKeyValue("solid", 6)
		ent:SetModel("models/props_lab/blastdoor001a.mdl")
		ent:Spawn()
	end
end)
