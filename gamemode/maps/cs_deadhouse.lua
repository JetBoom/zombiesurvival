hook.Add("InitPostEntityMap", "Adding", function()
	local ent = ents.Create("prop_dynamic_override")
	if ent:IsValid() then
		ent:SetPos(Vector(-905, 99, 128))
		ent:SetAngles(Angle(0,90,90))
		ent:SetKeyValue("solid", "6")
		ent:SetModel(Model("models/props_junk/sawblade001a.mdl"))
		ent:Spawn()
	end
end)
