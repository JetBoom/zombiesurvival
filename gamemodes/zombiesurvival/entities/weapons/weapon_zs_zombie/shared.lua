SWEP.ZombieOnly = true
SWEP.IsMelee = true

SWEP.PrintName = "Zombie"

SWEP.ViewModel = Model("models/Weapons/v_zombiearms.mdl")
SWEP.WorldModel = ""

SWEP.MeleeDelay = 0.74
SWEP.MeleeReach = 48
SWEP.MeleeSize = 4.5 --1.5
SWEP.MeleeDamage = 35
SWEP.MeleeForceScale = 1
SWEP.MeleeDamageType = DMG_SLASH

SWEP.AlertDelay = 2.5

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 1.2

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

function SWEP:StopMoaningSound()
	local owner = self:GetOwner()
	owner:StopSound("NPC_BaseZombie.Moan1")
	owner:StopSound("NPC_BaseZombie.Moan2")
	owner:StopSound("NPC_BaseZombie.Moan3")
	owner:StopSound("NPC_BaseZombie.Moan4")
end

function SWEP:StartMoaningSound()
	self:GetOwner():EmitSound("NPC_BaseZombie.Moan"..math.random(4))
end

function SWEP:PlayHitSound()
	self:EmitSound("npc/zombie/claw_strike"..math.random(3)..".wav", nil, nil, nil, CHAN_AUTO)
end

function SWEP:PlayMissSound()
	self:EmitSound("npc/zombie/claw_miss"..math.random(2)..".wav", nil, nil, nil, CHAN_AUTO)
end

function SWEP:PlayAttackSound()
	self:EmitSound("npc/zombie/zo_attack"..math.random(2)..".wav")
end

function SWEP:Initialize()
	self:HideWorldModel()
end

function SWEP:CheckIdleAnimation()
	if self.IdleAnimation and self.IdleAnimation <= CurTime() then
		self.IdleAnimation = nil
		self:SendWeaponAnim(ACT_VM_IDLE)
	end
end

function SWEP:CheckAttackAnimation()
	if self.NextAttackAnim and self.NextAttackAnim <= CurTime() then
		self.NextAttackAnim = nil
		self:SendAttackAnim()
	end
end

function SWEP:CheckMoaning()
	if self:IsMoaning() and self:GetOwner():Health() < self:GetMoanHealth() then
		self:SetNextSecondaryFire(CurTime() + 1)
		self:StopMoaning()
	end
end

function SWEP:CheckMeleeAttack()
	local swingend = self:GetSwingEndTime()
	if swingend == 0 or CurTime() < swingend then return end
	self:StopSwinging(0)

	self:Swung()
end

function SWEP:GetTracesNumPlayers(traces)
	local numplayers = 0

	local ent
	for _, trace in pairs(traces) do
		ent = trace.Entity
		if ent and ent:IsValidPlayer() then
			numplayers = numplayers + 1
		end
	end

	return numplayers
end

function SWEP:GetDamage(numplayers, basedamage)
	basedamage = basedamage or self.MeleeDamage

	if numplayers then
		return basedamage * math.Clamp(1.1 - numplayers * 0.1, 0.666, 1)
	end

	return basedamage
end

function SWEP:Swung()
	if not IsFirstTimePredicted() then return end

	local owner = self:GetOwner()

	local hit = false
	local traces = owner:CompensatedZombieMeleeTrace(self.MeleeReach, self.MeleeSize)
	local prehit = self.PreHit
	if prehit then
		local ins = true
		for _, tr in pairs(traces) do
			if tr.HitNonWorld then
				ins = false
				break
			end
		end
		if ins then
			local eyepos = owner:EyePos()
			if prehit.Entity:IsValid() and prehit.Entity:NearestPoint(eyepos):DistToSqr(eyepos) <= self.MeleeReach * self.MeleeReach then
				table.insert(traces, prehit)
			end
		end
		self.PreHit = nil
	end

	local damage = self:GetDamage(self:GetTracesNumPlayers(traces))
	local effectdata = EffectData()
	local ent

	for _, trace in ipairs(traces) do
		if not trace.Hit then continue end

		ent = trace.Entity

		hit = true

		if trace.HitWorld then
			self:MeleeHitWorld(trace)
		elseif ent and ent:IsValid() then
			self:MeleeHit(ent, trace, damage)
		end

		--if IsFirstTimePredicted() then
			effectdata:SetOrigin(trace.HitPos)
			effectdata:SetStart(trace.StartPos)
			effectdata:SetNormal(trace.HitNormal)
			util.Effect("RagdollImpact", effectdata)
			if not trace.HitSky then
				effectdata:SetSurfaceProp(trace.SurfaceProps)
				effectdata:SetDamageType(self.MeleeDamageType) --effectdata:SetDamageType(DMG_BULLET)
				effectdata:SetHitBox(trace.HitBox)
				effectdata:SetEntity(ent)
				util.Effect("Impact", effectdata)
			end
		--end
	end

	--if IsFirstTimePredicted() then
		if hit then
			self:PlayHitSound()
		else
			self:PlayMissSound()
		end
	--end

	if self.FrozenWhileSwinging then
		owner:ResetSpeed()
	end
end

function SWEP:Think()
	self:CheckIdleAnimation()
	self:CheckAttackAnimation()
	self:CheckMoaning()
	self:CheckMeleeAttack()
end

function SWEP:MeleeHitWorld(trace)
end

function SWEP:MeleeHit(ent, trace, damage, forcescale)
	if ent:IsPlayer() then
		self:MeleeHitPlayer(ent, trace, damage, forcescale)
	else
		self:MeleeHitEntity(ent, trace, damage, forcescale)
	end

	self:ApplyMeleeDamage(ent, trace, damage)
end

function SWEP:MeleeHitEntity(ent, trace, damage, forcescale)
	local phys = ent:GetPhysicsObject()
	if phys:IsValid() and phys:IsMoveable() then
		if trace.IsPreHit then
			phys:ApplyForceOffset(damage * 750 * (forcescale or self.MeleeForceScale) * self:GetOwner():GetAimVector(), (ent:NearestPoint(self:GetOwner():EyePos()) + ent:GetPos() * 5) / 6)
		else
			phys:ApplyForceOffset(damage * 750 * (forcescale or self.MeleeForceScale) * trace.Normal, (ent:NearestPoint(trace.StartPos) + ent:GetPos() * 2) / 3)
		end

		ent:SetPhysicsAttacker(self:GetOwner())
	end
end

function SWEP:MeleeHitPlayer(ent, trace, damage, forcescale)
	ent:ThrowFromPositionSetZ(self:GetOwner():GetPos(), damage * 2.5 * (forcescale or self.MeleeForceScale))
	ent:MeleeViewPunch(damage)
	local nearest = ent:NearestPoint(trace.StartPos)
	util.Blood(nearest, math.Rand(damage * 0.5, damage * 0.75), (nearest - trace.StartPos):GetNormalized(), math.Rand(damage * 5, damage * 10), true)
end

function SWEP:ApplyMeleeDamage(hitent, tr, damage)
	if not IsFirstTimePredicted() then return end

	local owner = self:GetOwner()

	local dmginfo = DamageInfo()
	dmginfo:SetDamagePosition(tr.HitPos)
	dmginfo:SetAttacker(owner)
	dmginfo:SetInflictor(self)
	dmginfo:SetDamageType(self.MeleeDamageType)
	dmginfo:SetDamage(damage)
	dmginfo:SetDamageForce(math.min(damage, 50) * 50 * owner:GetAimVector())

	local vel
	if hitent:IsPlayer() then
		if SERVER then
			hitent:SetLastHitGroup(tr.HitGroup)
			if tr.HitGroup == HITGROUP_HEAD then
				hitent:SetWasHitInHead()
			end

			if hitent:WouldDieFrom(damage, tr.HitPos) then
				dmginfo:SetDamageForce(math.min(damage, 50) * 400 * owner:GetAimVector())
			end
		end

		vel = hitent:GetVelocity()
	end

	hitent:DispatchTraceAttack(dmginfo, tr, owner:GetAimVector())

	-- No knockback vs. players
	if vel then
		hitent:SetLocalVelocity(vel)
	end

	--[[if hitent:IsPlayer() then
		local vel = hitent:GetVelocity()
		hitent:TakeSpecialDamage(damage, self.MeleeDamageType, self:GetOwner(), self, tr.HitPos)
		hitent:SetLocalVelocity(vel)
	else
		local dmgtype, owner, hitpos = self.MeleeDamageType, self:GetOwner(), tr.HitPos
		timer.Simple(0, function() -- Avoid prediction errors.
			if hitent:IsValid() and self:IsValid() and owner:IsValid() then
				hitent:TakeSpecialDamage(damage, dmgtype, owner, self, hitpos)
			end
		end)
	end]]
end

function SWEP:PrimaryAttack()
	if CurTime() < self:GetNextPrimaryFire() or IsValid(self:GetOwner().FeignDeath) then return end

	local owner = self:GetOwner()
	local armdelay = owner:GetMeleeSpeedMul()

	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay * armdelay)
	self:SetNextSecondaryFire(self:GetNextPrimaryFire() + 0.5)

	self:StartSwinging()
end

function SWEP:SecondaryAttack()
	if CurTime() < self:GetNextSecondaryFire() then return end
	self:SetNextSecondaryFire(CurTime() + self.AlertDelay)

	self:DoAlert()
end

function SWEP:DoAlert()
	self:GetOwner():DoReloadEvent()

	if SERVER then
		local ent = self:GetOwner():CompensatedMeleeTrace(4096, 24).Entity
		if ent:IsValidPlayer() then
			self:PlayAlertSound()
		else
			self:PlayIdleSound()
		end
	end
end

function SWEP:PlayAlertSound()
	self:GetOwner():EmitSound("npc/zombie/zombie_alert"..math.random(3)..".wav")
end

function SWEP:PlayIdleSound()
	self:GetOwner():EmitSound("npc/zombie/zombie_voice_idle"..math.random(14)..".wav")
end

function SWEP:SendAttackAnim()
	local owner = self:GetOwner()
	local armdelay = self.MeleeAnimationMul

	if self.SwapAnims then
		self:SendWeaponAnim(ACT_VM_HITCENTER)
	else
		self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	end
	self.SwapAnims = not self.SwapAnims
	if self.SwingAnimSpeed then
		owner:GetViewModel():SetPlaybackRate(self.SwingAnimSpeed * armdelay)
	else
		owner:GetViewModel():SetPlaybackRate(1 * armdelay)
	end
end

function SWEP:DoSwingEvent()
	self:GetOwner():DoZombieEvent()
end

function SWEP:StartSwinging()
	if not IsFirstTimePredicted() then return end

	local owner = self:GetOwner()
	local armdelay = owner:GetMeleeSpeedMul()

	self.MeleeAnimationMul = 1 / armdelay
	if self.MeleeAnimationDelay then
		self.NextAttackAnim = CurTime() + self.MeleeAnimationDelay * armdelay
	else
		self:SendAttackAnim()
	end

	self:DoSwingEvent()

	self:PlayAttackSound()

	self:StopMoaning()

	if self.FrozenWhileSwinging then
		self:GetOwner():SetSpeed(1)
	end

	if self.MeleeDelay > 0 then
		self:SetSwingEndTime(CurTime() + self.MeleeDelay * armdelay)

		local trace = owner:CompensatedMeleeTrace(self.MeleeReach, self.MeleeSize)
		if trace.HitNonWorld and not trace.Entity:IsPlayer() then
			trace.IsPreHit = true
			self.PreHit = trace
		end

		self.IdleAnimation = CurTime() + (self:SequenceDuration() + (self.MeleeAnimationDelay or 0)) * armdelay
	else
		self:Swung()
	end
end

function SWEP:StopSwinging()
	self:SetSwingEndTime(0)
end

function SWEP:KnockedDown(status, exists)
	self:StopSwinging()
end

function SWEP:StopMoaning()
	if not self:IsMoaning() then return end
	self:SetMoaning(false)

	self:StopMoaningSound()
end

function SWEP:StartMoaning()
	if self:IsMoaning() or IsValid(self:GetOwner().Revive) or IsValid(self:GetOwner().FeignDeath) then return end
	self:SetMoaning(true)

	self:SetMoanHealth(self:GetOwner():Health())

	self:StartMoaningSound()
end

function SWEP:Deploy()
	self.IdleAnimation = CurTime() + self:SequenceDuration()

	if self.DelayWhenDeployed and self.Primary.Delay > 0 then
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		self:SetNextSecondaryFire(self:GetNextPrimaryFire() + 0.5)
	end

	return true
end

function SWEP:OnRemove()
	if IsValid(self:GetOwner()) then
		self:StopMoaning()
	end
end
SWEP.Holster = SWEP.OnRemove

function SWEP:SetMoaning(moaning)
	self:SetDTBool(0, moaning)
end

function SWEP:GetMoaning()
	return self:GetDTBool(0)
end
SWEP.IsMoaning = SWEP.GetMoaning

function SWEP:SetMoanHealth(health)
	self:SetDTInt(0, health)
end

function SWEP:GetMoanHealth()
	return self:GetDTInt(0)
end

function SWEP:SetSwingEndTime(time)
	self:SetDTFloat(0, time)
end

function SWEP:GetSwingEndTime()
	return self:GetDTFloat(0)
end

function SWEP:IsSwinging()
	return self:GetSwingEndTime() > 0
end
SWEP.IsAttacking = SWEP.IsSwinging
