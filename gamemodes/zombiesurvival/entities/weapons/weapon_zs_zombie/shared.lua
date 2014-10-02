SWEP.ZombieOnly = true
SWEP.IsMelee = true

SWEP.ViewModel = Model("models/Weapons/v_zombiearms.mdl")
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"

SWEP.MeleeDelay = 0.74
SWEP.MeleeReach = 48
SWEP.MeleeSize = 1.5
SWEP.MeleeDamage = 30
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
	local owner = self.Owner
	owner:StopSound("NPC_BaseZombie.Moan1")
	owner:StopSound("NPC_BaseZombie.Moan2")
	owner:StopSound("NPC_BaseZombie.Moan3")
	owner:StopSound("NPC_BaseZombie.Moan4")
end

function SWEP:StartMoaningSound()
	self.Owner:EmitSound("NPC_BaseZombie.Moan"..math.random(4))
end

function SWEP:PlayHitSound()
	self.Owner:EmitSound("npc/zombie/claw_strike"..math.random(3)..".wav")
end

function SWEP:PlayMissSound()
	self.Owner:EmitSound("npc/zombie/claw_miss"..math.random(2)..".wav")
end

function SWEP:PlayAttackSound()
	self.Owner:EmitSound("npc/zombie/zo_attack"..math.random(2)..".wav")
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
	if self:IsMoaning() and self.Owner:Health() < self:GetMoanHealth() then
		self:SetNextSecondaryFire(CurTime() + 1)
		self:StopMoaning()
	end
end

function SWEP:CheckMeleeAttack()
	local swingend = self:GetSwingEndTime()
	if swingend == 0 or CurTime() < swingend then return end
	self:StopSwinging(0)

	if SERVER then
		self:Swung()
	end
end

function SWEP:GetTracesNumPlayers(traces)
	local numplayers = 0

	for _, trace in pairs(traces) do
		local ent = trace.Entity
		if ent and ent:IsValid() and ent:IsPlayer() then
			numplayers = numplayers + 1
		end
	end

	return numplayers
end

function SWEP:GetDamage(numplayers, basedamage)
	basedamage = basedamage or self.MeleeDamage

	if numplayers then
		return basedamage * math.Clamp(1.2 - numplayers * 0.2, 0.5, 1)
	end

	return basedamage
end

function SWEP:Swung()
	local owner = self.Owner

	owner:LagCompensation(true)

	local hit = false
	local traces = owner:PenetratingMeleeTrace(self.MeleeReach, self.MeleeSize, self.PreHit)
	self.PreHit = nil

	local damage = self:GetDamage(self:GetTracesNumPlayers(traces))

	for _, trace in ipairs(traces) do
		if not trace.Hit then continue end

		hit = true

		if trace.HitWorld then
			self:MeleeHitWorld(trace)
		else
			local ent = trace.Entity
			if ent and ent:IsValid() then
				self:MeleeHit(ent, trace, damage)
			end
		end
	end

	if SERVER then
		if hit then
			self:PlayHitSound()
		else
			self:PlayMissSound()
		end
	end

	owner:LagCompensation(false)

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
			phys:ApplyForceOffset(damage * 750 * (forcescale or self.MeleeForceScale) * self.Owner:GetAimVector(), (ent:NearestPoint(self.Owner:EyePos()) + ent:GetPos() * 5) / 6)
		else
			phys:ApplyForceOffset(damage * 750 * (forcescale or self.MeleeForceScale) * trace.Normal, (ent:NearestPoint(trace.StartPos) + ent:GetPos() * 2) / 3)
		end

		ent:SetPhysicsAttacker(self.Owner)
	end
end

function SWEP:MeleeHitPlayer(ent, trace, damage, forcescale)
	ent:ThrowFromPositionSetZ(self.Owner:GetPos(), damage * 2.5 * (forcescale or self.MeleeForceScale))
	ent:MeleeViewPunch(damage)
	local nearest = ent:NearestPoint(trace.StartPos)
	util.Blood(nearest, math.Rand(damage * 0.5, damage * 0.75), (nearest - trace.StartPos):GetNormalized(), math.Rand(damage * 5, damage * 10), true)
end

function SWEP:ApplyMeleeDamage(ent, trace, damage)
	if ent:IsPlayer() then
		ent:TakeSpecialDamage(damage, self.MeleeDamageType, self.Owner, self, trace.HitPos)
	else
		local dmgtype, owner, hitpos = self.MeleeDamageType, self.Owner, trace.HitPos
		timer.Simple(0, function() -- Avoid prediction errors.
			if ent:IsValid() then
				ent:TakeSpecialDamage(damage, dmgtype, owner, self, hitpos)
			end
		end)
	end
end

function SWEP:PrimaryAttack()
	if CurTime() < self:GetNextPrimaryFire() or IsValid(self.Owner.FeignDeath) then return end

	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetNextSecondaryFire(self:GetNextPrimaryFire() + 0.5)

	self:StartSwinging()
end

function SWEP:SecondaryAttack()
	if CLIENT then return end

	if CurTime() < self:GetNextSecondaryFire() then return end
	self:SetNextSecondaryFire(CurTime() + self.AlertDelay)

	self:DoAlert()
end

function SWEP:DoAlert()
	self.Owner:LagCompensation(true)

	local ent = self.Owner:MeleeTrace(4096, 24, self.Owner:GetMeleeFilter()).Entity
	if ent:IsValid() and ent:IsPlayer() then
		self:PlayAlertSound()
	else
		self:PlayIdleSound()
	end

	self.Owner:LagCompensation(false)
end

function SWEP:PlayAlertSound()
	self.Owner:EmitSound("npc/zombie/zombie_alert"..math.random(1, 3)..".wav")
end

function SWEP:PlayIdleSound()
	self.Owner:EmitSound("npc/zombie/zombie_voice_idle"..math.random(1, 14)..".wav")
end

function SWEP:SendAttackAnim()
	if self.SwapAnims then
		self:SendWeaponAnim(ACT_VM_HITCENTER)
	else
		self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	end
	self.SwapAnims = not self.SwapAnims
end

function SWEP:StartSwinging()
	if self.MeleeAnimationDelay then
		self.NextAttackAnim = CurTime() + self.MeleeAnimationDelay
	else
		self:SendAttackAnim()
	end

	local owner = self.Owner
	owner:DoAttackEvent()

	if SERVER then
		self:PlayAttackSound()
	end
	self:StopMoaning()

	if self.FrozenWhileSwinging then
		owner:SetSpeed(1)
	end

	if self.MeleeDelay > 0 then
		self:SetSwingEndTime(CurTime() + self.MeleeDelay)

		local trace = self.Owner:MeleeTrace(self.MeleeReach, self.MeleeSize, player.GetAll())
		if trace.HitNonWorld then
			trace.IsPreHit = true
			self.PreHit = trace
		end

		self.IdleAnimation = CurTime() + self:SequenceDuration()
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
	if self:IsMoaning() or IsValid(self.Owner.Revive) or IsValid(self.Owner.FeignDeath) then return end
	self:SetMoaning(true)

	self:SetMoanHealth(self.Owner:Health())

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
	if IsValid(self.Owner) then
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
