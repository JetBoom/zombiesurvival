if GMAPEX then return end

GMAPEX = {}

if SERVER then
	AddCSLuaFile("config.lua")
	AddCSLuaFile("sh_serialization.lua")
	AddCSLuaFile("client.lua")
end

include("config.lua")
include("sh_serialization.lua")

if SERVER then
	include("server.lua")
end

if CLIENT then
	include("client.lua")
end
