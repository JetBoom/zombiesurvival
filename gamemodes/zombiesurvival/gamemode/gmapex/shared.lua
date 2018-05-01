function GMAPEX:Initialize()
	scripted_ents.RegisterFromFile("point_lentmanentity.lua")
end

function scripted_ents.RegisterFromFile(filename)
	ENT = {}
	include(filename)
	scripted_ents.Register(filename:sub(1, -5):lower(), filename)
end

function AccessorFuncDT(tab, membername, type, id)
	local emeta = FindMetaTable("Entity")
	local setter = emeta["SetDT"..type]
	local getter = emeta["GetDT"..type]

	tab["Set"..membername] = function(me, val)
		setter(me, id, val)
	end

	tab["Get"..membername] = function(me)
		return getter(me, id)
	end
end

hook.Add("Initialize", "gmapex", function() GMAPEX:Initialize() end)
