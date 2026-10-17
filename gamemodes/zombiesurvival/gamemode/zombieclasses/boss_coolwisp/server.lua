AddCSLuaFile("shared.lua")
include("shared.lua")

function CLASS:OnKilled(pl, attacker, inflictor, suicide, headshot, dmginfo)
	if not suicide then
		local pos = pl:GetPos()
		local wep = pl:GetActiveWeapon() or NULL

		pl:GodEnable()

		local hits = util.BlastDamageExAlloc(wep, pl, pos, 100, 35, DMG_DROWN)
		for ent in pairs(hits) do
			if ent ~= pl and ent:IsValidLivingPlayer()
				and gamemode.Call("PlayerShouldTakeDamage", ent, pl) then
				ent:GiveStatus("frost", 8)
				ent:AddLegDamage(24)
				ent:AddArmDamage(24)
			end
		end

		pl:GodDisable()

		local effectdata = EffectData()
			effectdata:SetOrigin(pos)
			effectdata:SetNormal(Vector(0, 0, 1))
		util.Effect("hit_ice", effectdata, true, true)
	end

	return true
end
