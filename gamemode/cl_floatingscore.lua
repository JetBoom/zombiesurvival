function GM:ReceivedCommission(crate, buyer, points)
	gamemode.Call("FloatingScore", crate, "floatingscore_com", points)
end

function GM:HealedOtherPlayer(other, health)
	gamemode.Call("FloatingScore", other, "floatingscore_heal", health, nil, true)
end

function GM:RepairedObject(other, health)
	gamemode.Call("FloatingScore", other, "floatingscore_rep", health, nil, true)
end

local cvarNoFloatingScore = CreateClientConVar("zs_nofloatingscore", 0, true, false)
function GM:FloatingScore(victim, effectname, frags, flags, override_allow)
	if cvarNoFloatingScore:GetBool() then return end

	local isvec = type(victim) == "Vector"

	if not isvec and (not victim:IsValid() or victim:IsPlayer() and victim:Team() == MySelf:Team() and not override_allow) then
		return
	end

	effectname = effectname or "floatingscore"

	local pos = isvec and victim or victim:NearestPoint(EyePos())

	local effectdata = EffectData()
	effectdata:SetOrigin(pos)
	effectdata:SetScale(flags or 0)
	if effectname == "floatingscore_und" then
		effectdata:SetMagnitude(math.Round(frags or GAMEMODE.ZombieClasses[victim:GetZombieClass()].Points or 1, 2))
	else
		effectdata:SetMagnitude(math.Round(frags or 1, 2))
	end
	util.Effect(effectname, effectdata, true, true)
end
