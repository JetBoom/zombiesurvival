-- This profile gets rid of exploitable doors.

hook.Add("InitPostEntityMap", "MapProfile", function()
	for _, door in pairs(ents.FindByClass("func_door_rotating")) do
		door:Fire("open", "", 0)
		door:Fire("kill", "", 0.5)
	end
end)
