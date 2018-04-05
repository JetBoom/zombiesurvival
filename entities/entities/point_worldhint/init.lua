AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
end

function ENT:AcceptInput(name, activator, caller, args)
	if name == "setviewer" then
		self:SetKeyValue("viewer", args)
		return true
	elseif name == "sethint" then
		self:SetKeyValue("hint", args)
		return true
	elseif name == "setrange" then
		self:SetKeyValue("range", args)
		return true
	end
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	if key == "viewer" then
		self:SetViewable(tonumber(value) or 0)
	elseif key == "hint" then
		self:SetHint(value)
	elseif key == "range" then
		self:SetRange(tonumber(value) or 0)
	end
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end
