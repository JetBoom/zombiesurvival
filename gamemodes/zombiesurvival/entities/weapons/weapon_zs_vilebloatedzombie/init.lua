INC_SERVER()

function SWEP:Think()
	self.BaseClass.Think(self)

	local pl = self:GetOwner()

	if self.PukeLeft > 0 and CurTime() >= self.NextPuke then
		self.PukeLeft = self.PukeLeft - 1
		self.NextPuke = CurTime() + 0.1
		pl.LastRangedAttack = CurTime()

		local ent = ents.Create("projectile_poisonflesh")
		if ent:IsValid() then
			ent:SetPos(pl:EyePos())
			ent:SetOwner(pl)
			ent:Spawn()

			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				local ang = pl:EyeAngles()
				ang:RotateAroundAxis(ang:Forward(), math.Rand(-10, 10))
				ang:RotateAroundAxis(ang:Up(), math.Rand(-10, 10))
				phys:SetVelocityInstantaneous(ang:Forward() * 400)
			end
		end
	end

	self:NextThink(CurTime())
	return true
end
