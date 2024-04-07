-- This profile gets rid of exploitable doors and opens the area portals they control.
-- It also creates zombie spawns in the graveyard and human spawns in the front yard.

hook.Add("InitPostEntityMap", "Adding", function()
	

	local ent = ents.Create("prop_dynamic_override")
	if ent:IsValid() then
		ent:SetPos(Vector(258, 130, 248))
		ent:SetModel(Model("models/props_lab/blastdoor001c.mdl"))
		ent:SetKeyValue("solid", "6")
		ent:Spawn()
	end

	for _, spawn in pairs(ents.FindByClass("info_player*")) do
		spawn:Fire("kill", "", 0)
	end

	for _, door in pairs(ents.FindByClass("func_door_rotating")) do
		door:Fire("open", "", 0)
		door:Fire("kill", "", 1)
	end

	timer.Simple(2, function()
		team.SetSpawnPoint(TEAM_UNDEAD, ents.FindByClass("info_player_undead"))
		team.SetSpawnPoint(TEAM_HUMAN, ents.FindByClass("info_player_human"))
	end)
end)
