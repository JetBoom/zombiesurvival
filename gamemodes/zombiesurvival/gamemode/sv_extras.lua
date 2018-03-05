util.AddNetworkString("SMAddSpray")
util.AddNetworkString("SMClearDecals")
util.AddNetworkString("SMSpray")

CreateConVar("spraymon_nodelay", 1, FCVAR_SERVER_CAN_EXECUTE, "no delay for 0:nobody | 1:admins | 2:superadmins")
CreateConVar("spraymon_nooverspraying", 0, FCVAR_REPLICATED, "anti over spraying: 0 | 1")

hook.Add("PlayerSpray", "SMSendSpray", function(ply)
	local trace = ply:GetEyeTrace()
	net.Start("SMAddSpray")
		net.WriteEntity(ply)
		net.WriteFloat(trace.HitNormal.x)
		net.WriteFloat(trace.HitNormal.y)
		net.WriteFloat(trace.HitNormal.z)
		net.WriteFloat(trace.HitPos.x)
		net.WriteFloat(trace.HitPos.y)
		net.WriteFloat(trace.HitPos.z)
	net.Broadcast()
end)

local plymeta = FindMetaTable("Player")
local old = plymeta.ConCommand
plymeta.ConCommand = function(self, cmd, ...)
	if string.find(cmd, "r_cleardecals") then
		net.Start("SMClearDecals")
		net.Send(self)
	end
	return old(self, cmd, ...)
end

net.Receive("SMSpray", function(_, ply)
	if GetConVarNumber("spraymon_nodelay") > 0 and (GetConVarNumber("spraymon_nodelay") > 1 and ply:IsUserGroup("owner")) then
		ply:AllowImmediateDecalPainting()
	end
end)