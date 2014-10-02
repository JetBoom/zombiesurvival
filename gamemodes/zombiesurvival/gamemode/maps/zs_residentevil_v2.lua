hook.Add("InitPostEntityMap", "Adding", function()
	

	for _, ent in pairs(ents.FindByClass("prop_physics*")) do ent:GetPhysicsObject():EnableMotion(true) end
end)
