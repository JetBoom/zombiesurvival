hook.Add("InitPostEntityMap", "Adding", function()
	

	for _, ent in pairs(ents.FindByClass("trigger_teleport")) do
		ent:Remove()
	end

	for _, ent in pairs(ents.FindByClass("func_button")) do
		ent:Remove()
	end

	local ent2 = ents.Create("prop_dynamic_override")
	if ent2:IsValid() then
		ent2:SetPos(Vector(-93.9688, 666.7913, 256.0313))
		ent2:SetKeyValue("solid", "6")
		ent2:SetModel("models/props_lab/blastdoor001c.mdl")
		ent2:Spawn()
	end
end)
