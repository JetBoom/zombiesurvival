hook.Add("InitPostEntityMap", "Adding", function()
	local doors = ents.FindByClass("func_door_rotating")
	if doors[4] then
		doors[4]:SetKeyValue("damagefilter", "invul")
	end
	if doors[5] then
		doors[5]:SetKeyValue("damagefilter", "invul")
	end
end)
