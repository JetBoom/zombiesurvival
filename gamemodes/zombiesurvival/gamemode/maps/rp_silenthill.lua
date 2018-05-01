hook.Add("InitPostEntityMap", "Adding", function()
	for _, ent in pairs(ents.FindByClass("trigger_teleport")) do ent:Remove() end

	local buttons = ents.FindByClass("func_button")
	for i=4, 9 do
		buttons[i]:Remove()
	end
	for i=11, 27 do
		buttons[i]:Remove()
	end
end)
