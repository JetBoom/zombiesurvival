-- This allows communication to the noxapi. Mostly for checking if people are supporters.
-- Supporters don't get any gameplay advantages.
-- A supporter is someone who has gold or diamond member on noxiousnet.
-- Ripping this out or modifying it is silly. Also, I do not need to go on your server to see if you are doing so.

include("shared.lua")

if SERVER then
	AddCSLuaFile("noxapi.lua")
	AddCSLuaFile("shared.lua")
	AddCSLuaFile("client.lua")

	include("server.lua")
end

if CLIENT then
	include("client.lua")
end
