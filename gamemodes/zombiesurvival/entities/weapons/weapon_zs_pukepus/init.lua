INC_SERVER()

function SWEP:Think()
	local pl = self:GetOwner()

	if self.PukeLeft > 0 and CurTime() >= self.NextPuke then
		self.PukeLeft = self.PukeLeft - 1
		self.NextEmit = CurTime() + 0.1
		pl.LastRangedAttack = CurTime()

		local ent = ents.Create(self.PukeLeft % 6 == 1 and "projectile_ghoulfleshpuke" or "projectile_poisonpuke")
		if ent:IsValid() then
			ent:SetPos(pl:EyePos())
			ent:SetOwner(pl)
			ent:Spawn()

			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				local ang = pl:EyeAngles()
				ang:RotateAroundAxis(ang:Forward(), math.Rand(-6, 6))
				ang:RotateAroundAxis(ang:Up(), math.Rand(-22, 22))
				phys:SetVelocityInstantaneous(ang:Forward() * math.Rand(625, 750))
			end
		end
	end

	self:NextThink(CurTime())
	return true
end
