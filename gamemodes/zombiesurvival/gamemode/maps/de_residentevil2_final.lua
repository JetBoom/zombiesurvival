hook.Add("InitPostEntityMap", "Adding", function()
	

	for _, class in pairs(GAMEMODE.ZombieClasses) do
		class.Unlocked = true
	end

	hook.Add("PlayerInitialSpawn", "GiveAllClasses", function(pl)
		pl:SendLua("for _,class in pairs(GAMEMODE.ZombieClasses) do class.Unlocked=true end")
	end)

	for _, ent in pairs(ents.FindByClass("prop_physics*")) do
		ent:GetPhysicsObject():EnableMotion(true)
	end
end)
