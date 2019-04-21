hook.Add("InitPostEntityMap", "Adding", function()
	local ent = ents.Create("logic_classunlock")
	if ent:IsValid() then
		ent:Spawn()
		ent:Fire("lockclass", "all", 0)
		ent:Fire("defaultclass", "classic zombie", 0)
	end
end)
