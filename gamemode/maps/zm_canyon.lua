-- Plugs up two semi-secrets.

hook.Add("InitPostEntityMap", "Adding", function()
	

	local ent = ents.Create("prop_dynamic_override")
	if ent:IsValid() then
		ent:SetPos(Vector(-169.4831, 177.5246, -746.0686))
		ent:SetAngles(Angle(90, 0, 0))
		ent:SetModel(Model("models/props_lab/blastdoor001c.mdl"))
		ent:SetKeyValue("solid", "6")
		ent:Spawn()
	end

	local ent = ents.Create("prop_dynamic_override")
	if ent:IsValid() then
		ent:SetPos(Vector(-926.7128, -478.6960, -687.9688))
		ent:SetAngles(Angle(0, 90, 0))
		ent:SetModel(Model("models/props_lab/blastdoor001c.mdl"))
		ent:SetKeyValue("solid", "6")
		ent:Spawn()
	end
end)
