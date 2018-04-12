ROUNDTIME = 1500

hook.Add("PlayerInitialSpawn", "SendAlteredTime", function(pl)
	pl:SendLua("ROUNDTIME=1500")
end)
