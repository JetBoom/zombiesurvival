-- Removes stupid ammo crates in the only room anyone would ever want to hold out in.
-- Unlocks doors of secret rooms.

hook.Add("InitPostEntityMap", "Adding", function()
	

	for _, ent in pairs(ents.FindByClass("item_ammo_crate")) do
		ent:Remove()
	end

	for _, ent in pairs(ents.FindByModel("models/props_c17/door01_left.mdl")) do
		ent:Fire("unlock", "", 0)
	end

	local ent = ents.Create("info_player_zombie")
	if ent:IsValid() then
		ent:SetPos(Vector(-1641, -61, 7))
		ent:Spawn()
	end
end)
