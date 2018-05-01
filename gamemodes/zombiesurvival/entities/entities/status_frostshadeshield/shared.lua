ENT.Base = "status_shadeshield"

function ENT:SetObjectHealth(health)
	self:SetDTFloat(1, health)
	if health <= 0 and not self.Destroyed then
		self.Destroyed = true

		if SERVER then
			local effectdata = EffectData()
				effectdata:SetOrigin(self:WorldSpaceCenter())
				effectdata:SetNormal(self:GetUp())
			util.Effect("hit_ice", effectdata)

			local owner = self:GetOwner()
			local pos = self:LocalToWorld(self:OBBCenter())
			for _, ent in pairs(util.BlastAlloc(self, owner, pos, 128)) do
				if ent:IsValidLivingPlayer() and gamemode.Call("PlayerShouldTakeDamage", ent, owner) and ent ~= owner then
					ent:GiveStatus("frost", 7)
					ent:AddLegDamageExt(18, owner, self, SLOWTYPE_COLD)
				end
			end

			owner:GodEnable()
			util.BlastDamageEx(self, owner, pos, 128, 30, DMG_GENERIC)
			owner:GodDisable()
			util.ScreenShake(self:GetPos(), 15, 5, 1.5, 800)
			self:EmitSound("physics/glass/glass_largesheet_break"..math.random(1, 3)..".wav", 85)
		end
	end
end
