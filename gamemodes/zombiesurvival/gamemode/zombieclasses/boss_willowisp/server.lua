AddCSLuaFile("shared.lua")
include("shared.lua")

function CLASS:OnKilled(pl, attacker, inflictor, suicide, headshot, dmginfo)
	if not suicide then
		pl:GodEnable()
		util.BlastDamageEx(pl:GetActiveWeapon() or NULL, pl, pl:GetPos(), 100, 35, DMG_DISSOLVE)
		pl:GodDisable()

		local effectdata = EffectData()
			effectdata:SetOrigin(pl:GetPos())
			effectdata:SetNormal(Vector(0, 0, 1))
		util.Effect("explosion_wispdeath", effectdata, true, true)
	end

	return true
end
