-- Blocks off some secrets and long hallways. Removes excess vending machines sitting everywhere.

hook.Add("InitPostEntityMap", "Adding", function()
	local ent = ents.Create("prop_dynamic_override")
	if ent:IsValid() then
		ent:SetPos(Vector(1144.9447, -4209.1284, 39.0313))
		ent:SetModel(Model("models/props_lab/blastdoor001c.mdl"))
		ent:SetKeyValue("solid", "6")
		ent:Spawn()
	end

	local ent = ents.Create("prop_dynamic_override")
	if ent:IsValid() then
		ent:SetPos(Vector(2445.5959, -3636.7520, 13.0313))
		ent:SetModel(Model("models/props_lab/blastdoor001c.mdl"))
		ent:SetKeyValue("solid", "6")
		ent:Spawn()
	end

	local ent = ents.Create("prop_dynamic_override")
	if ent:IsValid() then
		ent:SetPos(Vector(3250.6699, -4818.5039, 22.0313))
		ent:SetAngles(Angle(0, 90, 0))
		ent:SetModel(Model("models/props_lab/blastdoor001c.mdl"))
		ent:SetKeyValue("solid", "6")
		ent:Spawn()
	end

	local ent = ents.Create("prop_dynamic_override")
	if ent:IsValid() then
		ent:SetPos(Vector(3310.6541, -2534.7319, 19.0865))
		ent:SetAngles(Angle(0, 90, 0))
		ent:SetModel(Model("models/props_lab/blastdoor001c.mdl"))
		ent:SetKeyValue("solid", "6")
		ent:Spawn()
	end

	for _, ent in pairs(ents.FindByModel("models/props/cs_office/vending_machine.mdl")) do ent:Remove() end
end)
