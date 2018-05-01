AddCSLuaFile("shared.lua")
include("shared.lua")

function CLASS:AltUse(pl)
	pl:StartFeignDeath()
end

--[[local function Bomb(pl, pos, dir)
	if not IsValid(pl) then return end

	dir:RotateAroundAxis(dir:Right(), 30)

	local effectdata = EffectData()
		effectdata:SetOrigin(pos)
		effectdata:SetNormal(dir:Forward())
	util.Effect("explosion_fat", effectdata, true)

	for i=1, 6 do
		local ang = Angle()
		ang:Set(dir)
		ang:RotateAroundAxis(ang:Up(), math.Rand(-30, 30))
		ang:RotateAroundAxis(ang:Right(), math.Rand(-30, 30))

		local heading = ang:Forward()

		local ent = ents.CreateLimited("projectile_poisonflesh")
		if ent:IsValid() then
			ent:SetPos(pos)
			ent:SetOwner(pl)
			ent:Spawn()

			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:Wake()
				phys:SetVelocityInstantaneous(heading * math.Rand(120, 250))
			end
		end
	end
end

function CLASS:OnKilled(pl, attacker, inflictor, suicide, headshot, dmginfo, assister)
	if attacker ~= pl and not suicide then
		local pos = pl:LocalToWorld(pl:OBBCenter())
		local ang = pl:SyncAngles()
		timer.Simple(0, function() Bomb(pl, pos, ang) end)
	end
end]]
