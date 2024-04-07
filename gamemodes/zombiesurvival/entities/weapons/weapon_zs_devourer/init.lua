INC_SERVER()

function SWEP:Reload()
	self.BaseClass.SecondaryAttack(self)
end

function SWEP:ThrowHook()
	local owner = self:GetOwner()

	owner.LastRangedAttack = CurTime()

	local ent = ents.Create("projectile_devourer")
	if ent:IsValid() then
		local ang = owner:EyeAngles()
		ang:RotateAroundAxis(ang:Up(), 90)

		ent:SetPos(owner:GetShootPos())
		ent:SetAngles(ang)
		ent:SetOwner(owner)
		ent:Spawn()

		local phys = ent:GetPhysicsObject()
		if phys:IsValid() then
			phys:SetVelocityInstantaneous(owner:GetAimVector() * 2150)
		end
	end
end
