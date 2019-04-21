AddCSLuaFile("shared.lua")
include("shared.lua")

function CLASS:CanPlayerSuicide(pl)
	local wep = pl:GetActiveWeapon()
	if wep:IsValid() and wep.GetCharge and wep:GetCharge() > 0 then return false end
end

local function DoExplode(pl, pos, magnitude, dmginfo)
	local inflictor = pl:GetActiveWeapon()
	if not inflictor:IsValid() then inflictor = pl end

	local effectdata = EffectData()
		effectdata:SetOrigin(pos)
		effectdata:SetMagnitude(magnitude)
	util.Effect("explosion_chem", effectdata, true)

	util.PoisonBlastDamage(inflictor, pl, pos, 38 + magnitude * 46, magnitude * 39, true, true)

	pl:CheckRedeem()
end

function CLASS:OnKilled(pl, attacker, inflictor, suicide, headshot, dmginfo, assister)
	local magnitude = 1
	local wep = pl:GetActiveWeapon()
	if wep:IsValid() and wep.GetCharge then magnitude = wep:GetCharge() end

	if suicide and magnitude < 1 then return end
	magnitude = 0.25 + magnitude * 0.75

	local pos = pl:WorldSpaceCenter()

	timer.Simple(0, function() DoExplode(pl, pos, magnitude, dmginfo) end)

	return true
end

function CLASS:OnSpawned(pl)
	pl:CreateAmbience("bursterambience")
end
