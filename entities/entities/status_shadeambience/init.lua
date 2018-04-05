AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

ENT.NextFlashlightCheck = 0

function ENT:Initialize()
	self:DrawShadow(false)
end

function ENT:Think()
	local owner = self:GetOwner()
	if not (owner:Alive() and owner:Team() == TEAM_UNDEAD and owner:GetZombieClassTable().Name == "Shade") then
		self:Remove()
	elseif CurTime() >= self.NextFlashlightCheck then
		self.NextFlashlightCheck = CurTime() + 0.33

		local totaldamage = 0
		for _, pl in pairs(team.GetPlayers(TEAM_HUMAN)) do
			if pl:Alive() and pl:FlashlightIsOn() then
				local eyepos = pl:GetShootPos()
				local nearest = owner:NearestPoint(eyepos)
				local dist = eyepos:Distance(nearest)
				if dist <= 300 and LightVisible(eyepos, nearest, owner, pl) then
					local dot = (nearest - eyepos):GetNormalized():Dot(pl:GetAimVector())
					if dot >= 0.85 then
						local damage = (1 - dist / 300) * dot * 7
						totaldamage = totaldamage + damage

						SHADEFLASHLIGHTDAMAGE = true
						owner:TakeDamage(damage, pl, self)
						SHADEFLASHLIGHTDAMAGE = false
					end
				end
			end
		end

		for _, ent in pairs(ents.FindByClass("prop_spotlamp")) do
			local eyepos = ent:GetSpotLightPos()
			local nearest = owner:NearestPoint(eyepos)
			local dist = eyepos:Distance(nearest)
			if dist <= 500 and LightVisible(eyepos, nearest, owner, ent) then
				local dot = (nearest - eyepos):GetNormalized():Dot(ent:GetSpotLightAngles():Forward())
				if dot >= 0.85 then
					local damage = (1 - dist / 500) * dot * 8
					totaldamage = totaldamage + damage

					SHADEFLASHLIGHTDAMAGE = true
					owner:TakeDamage(damage, ent, self)
					SHADEFLASHLIGHTDAMAGE = false
				end
			end
		end

		if totaldamage > 0 then
			self:SetLastDamaged(CurTime())
		end

		if self:GetLastDamage() ~= totaldamage then
			self:SetLastDamage(totaldamage)
		end
	end
end
