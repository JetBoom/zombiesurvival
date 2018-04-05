-- Removes invulnerable rotating doors that seem to be so popular in CS:S

hook.Add("InitPostEntityMap", "Adding", function()
	

	for _, door in pairs(ents.FindByClass("func_door_rotating")) do
		door:Fire("open", "", 0)
		door:Fire("kill", "", 1)
	end

	local ent = ents.Create("zombiegasses")
	if ent:IsValid() then
		ent:SetPos(Vector(1915, 414, -3170))
		ent:Spawn()
	end
	
	local ent = ents.Create("info_player_terrorist")
	if ent:IsValid() then
		ent:SetPos(Vector(1972, 422, -3179))
		ent:Spawn()
	end
end)
