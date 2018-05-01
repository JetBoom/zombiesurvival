INC_SERVER()

function SWEP:Reload()
	self.BaseClass.SecondaryAttack(self)
end

local function DoFleshThrow(pl, wep)
	if pl:IsValid() and pl:Alive() and wep:IsValid() then
		--pl:ResetSpeed()
		pl.LastRangedAttack = CurTime()

		local startpos = pl:GetPos()
		startpos.z = pl:GetShootPos().z
		local heading = pl:GetAimVector()

		local ent = ents.Create("projectile_bonemesh")
		if ent:IsValid() then
			ent:SetPos(startpos + heading * 8)
			ent:SetAngles(AngleRand())
			ent:SetOwner(pl)
			ent:Spawn()

			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:SetVelocityInstantaneous(heading * 600)
				phys:AddAngleVelocity(VectorRand() * 45)
			end
		end

		pl:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 72, math.random(70, 80))

		--pl:RawCapLegDamage(CurTime() + 2)
	end
end

local function DoSwing(pl, wep)
	if pl:IsValid() and pl:Alive() and wep:IsValid() then
		pl:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 72, math.random(70, 83))
		if wep.SwapAnims then wep:SendWeaponAnim(ACT_VM_HITCENTER) else wep:SendWeaponAnim(ACT_VM_SECONDARYATTACK) end
		wep.IdleAnimation = CurTime() + wep:SequenceDuration()
		wep.SwapAnims = not wep.SwapAnims
	end
end

function SWEP:SecondaryAttack()
	if CurTime() < self:GetNextPrimaryFire() or CurTime() < self:GetNextSecondaryFire() then return end

	local owner = self:GetOwner()

	self:SetSwingAnimTime(CurTime() + 1)
	self:GetOwner():DoAnimationEvent(ACT_RANGE_ATTACK2)
	self:GetOwner():EmitSound("NPC_PoisonZombie.Throw")
	--self:GetOwner():SetSpeed(1)
	self:SetNextSecondaryFire(CurTime() + 1.1)
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	timer.Simple(0.6, function() DoSwing(owner, self) end)
	timer.Simple(0.75, function() DoFleshThrow(owner, self) end)
end
