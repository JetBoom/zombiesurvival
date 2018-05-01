AddCSLuaFile("shared.lua")
include("shared.lua")

function CLASS:OnKilled(pl, attacker, inflictor, suicide, headshot, dmginfo)
	local pos = pl:WorldSpaceCenter()

	for i=1, 20 do
		local ent = ents.CreateLimited("prop_playergib")
		if ent:IsValid() then
			ent:SetPos(pos + VectorRand() * 12)
			ent:SetAngles(VectorRand():Angle())
			ent:SetGibType(math.random(3, #GAMEMODE.HumanGibs))
			ent:Spawn()

			local phys = ent:GetPhysicsObject()
			if phys and phys:IsValid() then
				phys:ApplyForceOffset(VectorRand():GetNormalized() * math.Rand(8000, 13000), pos)
			end
		end
	end

	local effectdata = EffectData()
		effectdata:SetOrigin(pos)
		effectdata:SetNormal(pl:GetUp())
		effectdata:SetEntity(pl)
	util.Effect("death_doomcrab", effectdata, nil, true)

	return true
end
