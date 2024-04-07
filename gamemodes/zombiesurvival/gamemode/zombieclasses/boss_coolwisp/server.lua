AddCSLuaFile("shared.lua")
include("shared.lua")

function CLASS:OnKilled(pl, attacker, inflictor, suicide, headshot, dmginfo)
	if not suicide then
		pl:GodEnable()
		util.BlastDamageEx(pl:GetActiveWeapon() or NULL, pl, pl:GetPos(), 100, 35, DMG_DROWN)
		pl:GodDisable()
		for _, ent in pairs(util.BlastAlloc(pl:GetActiveWeapon() or NULL, pl, pl:GetPos(), 100)) do
			if ent:IsValidLivingPlayer() and gamemode.Call("PlayerShouldTakeDamage", ent, pl) and ent ~= pl then
				ent:GiveStatus("frost", 8)
				ent:AddLegDamage(24)
				ent:AddArmDamage(24)
			end
		end

		local effectdata = EffectData()
			effectdata:SetOrigin(pl:GetPos())
			effectdata:SetNormal(Vector(0, 0, 1))
		util.Effect("hit_ice", effectdata, true, true)
	end

	return true
end
