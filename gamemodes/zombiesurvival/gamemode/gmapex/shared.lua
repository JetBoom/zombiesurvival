function GMAPEX:Initialize()
	scripted_ents.RegisterFromFile("point_gmapexentity.lua")
end

function scripted_ents.RegisterFromFile(filename)
	local ent = {}
	setfenv(0, _G)
	local oldENT = ENT
	ENT = ent
	include(filename)
	ENT = oldENT
	scripted_ents.Register(ent, filename:sub(1, -5):lower())
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
