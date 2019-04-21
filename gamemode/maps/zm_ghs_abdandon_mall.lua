hook.Add("InitPostEntityMap", "Adding", function()
	

	local ent2 = ents.Create("prop_dynamic_override")
	if ent2:IsValid() then
		ent2:SetPos(Vector(707, 1355, 16))
		ent2:SetKeyValue("solid", SOLID_VPHYSICS)
		ent2:SetModel(Model("models/props_lab/blastdoor001b.mdl"))
		ent2:SetColor(Color(0, 0, 0, 0))
		ent2:Spawn()
	end

	for _, ent in pairs(ents.FindByClass("trigger_teleport")) do ent:Remove() end
end)
