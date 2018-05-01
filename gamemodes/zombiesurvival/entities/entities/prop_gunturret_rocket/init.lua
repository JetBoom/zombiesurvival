INC_SERVER()

ENT.LastHitPeriod = 4

function ENT:FireTurret(src, dir)
	if self:GetNextFire() <= CurTime() then
		local curammo = self:GetAmmo()
		local owner = self:GetObjectOwner()
		local twinvolley = self:GetManualControl() and owner:IsSkillActive(SKILL_TWINVOLLEY)
		if curammo > (twinvolley and 1 or 0) then
			self:SetNextFire(CurTime() + self.FireDelay * (twinvolley and 1.5 or 1))
			self:SetAmmo(curammo - (twinvolley and 2 or 1))

			if self:GetAmmo() == 0 then
				owner:SendDeployableOutOfAmmoMessage(self)
			end

			self:PlayShootSound()

			local angle = dir:Angle()
			for i = 1, self.NumShots * (twinvolley and 2 or 1) do
				local ent = ents.Create("projectile_rocket")
				if ent:IsValid() then
					ent:SetPos(src)
					ent:SetAngles(angle)
					ent:SetOwner(owner)
					ent.ProjDamage = self.Damage * (owner.ProjectileDamageMul or 1)
					ent.ProjSource = self
					ent.ProjTaper = 0.95

					ent.Team = owner:Team()
					ent:Spawn()

					local phys = ent:GetPhysicsObject()
					if phys:IsValid() then
						phys:Wake()

						angle:RotateAroundAxis(angle:Forward(), math.Rand(0, 360))
						angle:RotateAroundAxis(angle:Up(), math.Rand(-self.Spread, self.Spread))
						phys:SetVelocityInstantaneous(angle:Forward() * 900 * (owner.ProjectileSpeedMul or 1))
					end
				end
			end
		else
			self:SetNextFire(CurTime() + 2)
			self:EmitSound("npc/turret_floor/die.wav")
		end
	end
end
