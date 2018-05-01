INC_SERVER()

SWEP.Primary.Projectile = "projectile_asmd"
SWEP.Primary.ProjVelocity = 400

function SWEP:ShootSecondary(damage, numshots, cone)
	local owner = self:GetOwner()
	self:SendWeaponAnimation()
	owner:DoAttackEvent()

	for i = 0,numshots-1 do
		local ent = ents.Create(self.Primary.Projectile)
		if ent:IsValid() then
			ent:SetPos(owner:GetShootPos())
			ent:SetAngles(owner:EyeAngles())
			ent:SetOwner(owner)
			ent.ProjDamage = damage * (owner.ProjectileDamageMul or 1)
			ent.ProjSource = self
			ent.Team = owner:Team()

			ent:Spawn()

			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:Wake()

				local angle = owner:GetAimVector():Angle()
				angle:RotateAroundAxis(angle:Forward(), math.Rand(0, 360))
				angle:RotateAroundAxis(angle:Up(), math.Rand(-cone, cone))
				phys:SetVelocityInstantaneous(angle:Forward() * self.Primary.ProjVelocity * (owner.ProjectileSpeedMul or 1))
			end
		end
	end
end
