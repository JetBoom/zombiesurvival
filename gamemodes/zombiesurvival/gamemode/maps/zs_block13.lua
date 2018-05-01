hook.Add("InitPostEntityMap", "Adding", function()
	local ent = ents.Create("prop_dynamic_override")
	if ent:IsValid() then
		ent:SetPos(Vector(-320.409821, -502.737671, 139.487274))
		ent:SetAngles(Angle(0, 90, 0))
		ent:SetKeyValue("solid", "6")
		ent:SetModel("models/props_lab/blastdoor001c.mdl")
		ent:Spawn()
		ent:SetNoDraw(true)
	end
end)
