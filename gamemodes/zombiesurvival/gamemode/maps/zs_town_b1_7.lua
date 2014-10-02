hook.Add("InitPostEntityMap", "Adding", function()
	for _, ent in pairs(ents.FindInSphere(Vector(1736.2645, -1860.0313, -525.5502), 32)) do
		if ent:GetClass() == "func_door_rotating" then ent:Remove() end
	end

	for _, ent in pairs(ents.FindByClass("func_movelinear")) do
		ent:Remove()
	end

	local ent2 = ents.Create("prop_dynamic_override")
	if ent2:IsValid() then
		ent2:SetPos(Vector(1120.2247, -2566.5984, -263.9688))
		ent2:SetAngles(Angle(0, 90, 0))
		ent2:SetKeyValue("solid", "6")
		ent2:SetModel(Model("models/props_lab/blastdoor001c.mdl"))
		ent2:Spawn()
	end
end)
