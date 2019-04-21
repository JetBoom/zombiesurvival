INC_SERVER()

SWEP.Primary.Projectile = "projectile_arrow"

function SWEP:EntModify(ent)
end

function SWEP:PhysModify(physobj)
end

function SWEP:ShootBullets(damage, numshots, cone)
	local owner = self:GetOwner()
	self:SendWeaponAnimation()
	owner:DoAttackEvent()

	if self.Recoil > 0 then
		local r = math.Rand(0.8, 1)
		owner:ViewPunch(Angle(r * -self.Recoil, 0, (1 - r) * (math.random(2) == 1 and -1 or 1) * self.Recoil))
	end

	local ssfw, ssup
	if self.SameSpread then
		ssfw, ssup = math.Rand(0, 360), math.Rand(-cone, cone)
	end

	for i = 0,numshots-1 do
		local ent = ents.Create(self.Primary.Projectile)
		if ent:IsValid() then
			ent:SetPos(owner:GetShootPos())
			ent:SetAngles(owner:EyeAngles())
			ent:SetOwner(owner)
			ent.ProjDamage = self.Primary.Damage * (owner.ProjectileDamageMul or 1)
			ent.ProjSource = self
			ent.ShotMarker = i
			ent.Team = owner:Team()

			self:EntModify(ent)
			ent:Spawn()

			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:Wake()

				local angle = owner:GetAimVector():Angle()
				angle:RotateAroundAxis(angle:Forward(), ssfw or math.Rand(0, 360))
				angle:RotateAroundAxis(angle:Up(), ssup or math.Rand(-cone, cone))

				ent.PreVel = angle:Forward() * self.Primary.ProjVelocity * (owner.ProjectileSpeedMul or 1)
				phys:SetVelocityInstantaneous(ent.PreVel)

				self:PhysModify(phys)
			end
		end
	end
end
