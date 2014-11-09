net.Receive("zs_healother", function(length)
	gamemode.Call("HealedOtherPlayer", net.ReadEntity(), net.ReadUInt(16))
end)

net.Receive("zs_repairobject", function(length)
	gamemode.Call("RepairedObject", net.ReadEntity(), net.ReadUInt(16))
end)

net.Receive("zs_commission", function(length)
	gamemode.Call("ReceivedCommission", net.ReadEntity(), net.ReadEntity(), net.ReadUInt(16))
end)

function GM:ReceivedCommission(crate, buyer, points)
	gamemode.Call("FloatingScore", crate, "floatingscore_com", points)
end

function GM:HealedOtherPlayer(other, points)
	gamemode.Call("FloatingScore", other, "floatingscore_heal", points, nil, true)
end

function GM:RepairedObject(other, points)
	gamemode.Call("FloatingScore", other, "floatingscore", points)
end

local cvarNoFloatingScore = CreateClientConVar("zs_nofloatingscore", 0, true, false)
function GM:FloatingScore(victim, effectname, frags, flags, override_allow)
	if cvarNoFloatingScore:GetBool() then return end

	local isvec = type(victim) == "Vector"

	if not isvec then
		if not victim:IsValid() or victim:IsPlayer() and victim:Team() == MySelf:Team() and not override_allow then
			return
		end
	end

	effectname = effectname or "floatingscore"

	local pos = isvec and victim or victim:NearestPoint(EyePos())

	local effectdata = EffectData()
	effectdata:SetOrigin(pos)
	effectdata:SetScale(flags or 0)
	if effectname == "floatingscore_und" then
		effectdata:SetMagnitude(frags or GAMEMODE.ZombieClasses[victim:GetZombieClass()].Points or 1)
	else
		effectdata:SetMagnitude(frags or 1)
	end
	util.Effect(effectname, effectdata, true, true)
end
