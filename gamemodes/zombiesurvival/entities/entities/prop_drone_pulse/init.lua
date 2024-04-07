INC_SERVER()

ENT.Projectile = "projectile_drone_pulse"

function ENT:FireTurret(src, dir)
	if self:GetNextFire() <= CurTime() then
		local curammo = self:GetAmmo()
		if curammo > 0 then
			self:SetNextFire(CurTime() + 0.36)
			self:SetAmmo(curammo - 2)

			self:PlayShootSound()

			local owner = self:GetObjectOwner()
			local angle = dir:Angle()

			local ent = ents.Create(self.Projectile)
			if ent:IsValid() then
				ent:SetAngles(angle)
				ent:SetOwner(owner)
				ent:SetPos(src + angle:Forward() * 5)
				ent.ProjDamage = 22 * (owner.ProjectileDamageMul or 1)
				ent.ProjSource = self

				ent.Team = owner:Team()
				ent:Spawn()

				local phys = ent:GetPhysicsObject()
				if phys:IsValid() then
					phys:Wake()

					phys:SetVelocityInstantaneous(angle:Forward() * 470 * (owner.ProjectileSpeedMul or 1))
				end
			end
		else
			self:SetNextFire(CurTime() + 2)
			self:EmitSound("npc/turret_floor/die.wav")
		end
	end
end

function ENT:PlayShootSound()
	self:EmitSound("weapons/zs_rail/rail.wav", 70, math.random(238, 243), 0.86, CHAN_AUTO)
end
