hook.Add("InitPostEntityMap", "Adding", function()
	local ent = ents.Create("prop_dynamic_override")
	if ent:IsValid() then
		ent:SetPos(Vector(1431.674316, 759.331238, -171.968750))
		ent:SetKeyValue("solid", "6")
		ent:SetModel(Model("models/props_lab/blastdoor001c.mdl"))
		ent:Spawn()
		ent:SetNoDraw(true)
	end

	local ent = ents.Create("prop_dynamic_override")
	if ent:IsValid() then
		ent:SetPos(Vector(1431.674316, 759.331238, -116))
		ent:SetKeyValue("solid", "6")
		ent:SetModel(Model("models/props_lab/blastdoor001c.mdl"))
		ent:Spawn()
		ent:SetNoDraw(true)
	end
end)
