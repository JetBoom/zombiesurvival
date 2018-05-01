hook.Add("SetupProps", "RemoveBoomstick", function()
	for _, ent in pairs(ents.FindByClass("prop_weapon")) do
		if ent:GetWeaponType() == "weapon_zs_boomstick" then
			ent:Remove()
		end
	end
end)
