hook.Add("InitPostEntityMap", "Adding", function()
	

	local ent = ents.Create("prop_dynamic_override")
	if ent:IsValid() then
		ent:SetModel("models/props_vehicles/car005b_physics.mdl")
		ent:SetPos(Vector(1121, 862, 80))
		ent:SetAngles(Angle(0, 180, 0))
		ent:SetKeyValue("solid", SOLID_VPHYSICS)
		ent:Spawn()
	end

	for _, ent in pairs(ents.FindByClass("func_door_rotating")) do
		ent:Fire("open", "", 0)
		ent:Fire("kill", "", 0.5)
	end
end)
