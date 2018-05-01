SWEP.Base = "weapon_zs_zombie"

SWEP.PrintName = "Flesh Creeper"

SWEP.MeleeDelay = 0.5
SWEP.MeleeReach = 52
SWEP.MeleeDamage = 15
SWEP.MeleeForceScale = 1.25
SWEP.MeleeSize = 4.5 --3
SWEP.MeleeDamageType = DMG_SLASH
SWEP.Primary.Delay = 0.75

SWEP.Secondary.Automatic = false

AccessorFuncDT(SWEP, "RightClickStart", "Float", 2)
AccessorFuncDT(SWEP, "AttackAnimTime", "Float", 3)
AccessorFuncDT(SWEP, "Pouncing", "Boolean", 1)

function SWEP:Think()
	self.BaseClass.Think(self)

	if self:GetHoldingRightClick() and not self:GetOwner():KeyDown(IN_ATTACK2) then
		self:SetRightClickStart(0)

		if self.BuildSoundPlaying then
			self.BuildSoundPlaying = false
			self.BuildSound:ChangeVolume(0, 0.5)
		end
	elseif self:IsBuilding() then
		if not self.BuildSoundPlaying then
			self.BuildSoundPlaying = true
			self.BuildSound:ChangeVolume(0.45, 0.5)
		end

		if SERVER then
			self:BuildingThink()
		end
	end

	if self:IsPouncing() then
		self.FlySound:PlayEx(0.5, 60)

		local owner = self:GetOwner()
		local delay = owner:GetMeleeSpeedMul()
		local time = CurTime()

		if owner:WaterLevel() >= 2 then
			self:SetPouncing(false)
			self:SetNextPrimaryFire(time + 0.8 * delay)
		elseif owner:OnGround() and owner:IsOnGround() then
			self:SetPouncing(false)
			self:SetNextPrimaryFire(time + 0.9 * delay)

			if IsFirstTimePredicted() then
				owner:EmitSound("npc/antlion/land1.wav", 65, 140, 0.65)
			end
		end
	else
		self.FlySound:Stop()
	end

	self:NextThink(CurTime())
	return true
end

function SWEP:Move(mv)
	if self:IsPouncing() then
		if CurTime() < self.PoundAttackStart + 0.1 then
			local vel = mv:GetVelocity()
			vel.z = 350
			self:GetOwner():SetGroundEntity(NULL)
			mv:SetVelocity(vel)
		end

		mv:SetMaxSpeed(mv:GetMaxSpeed() * 5)
		mv:SetMaxClientSpeed(mv:GetMaxClientSpeed() * 5)
		return true
	end
end

function SWEP:ApplyMeleeDamage(ent, trace, damage)
	if ent.ZombieConstruction then
		damage = damage * 3
	end

	self.BaseClass.ApplyMeleeDamage(self, ent, trace, damage)
end

function SWEP:Initialize()
	self.BaseClass.Initialize(self)

	self.BuildSound = CreateSound(self, "npc/antlion/charge_loop1.wav")
	self.BuildSound:PlayEx(0, 100)

	self.FlySound = CreateSound(self, "npc/antlion/fly1.wav")
end

function SWEP:OnRemove()
	self.BaseClass.OnRemove(self)

	self.BuildSound:Stop()
	self.FlySound:Stop()
end

function SWEP:PrimaryAttack()
	if self:GetHoldingRightClick() or not self:GetOwner():OnGround() then return end

	self.BaseClass.PrimaryAttack(self)

	if self:IsSwinging() then
		self:SetAttackAnimTime(CurTime() + self.Primary.Delay)
	end
end

function SWEP:SecondaryAttack()
	if self:IsSwinging() or self:IsInAttackAnim() or not self:GetOwner():OnGround() then return end

	self:SetRightClickStart(CurTime())
end

function SWEP:GetHoldingRightClick()
	return self:GetRightClickStart() > 0
end

function SWEP:IsBuilding()
	return self:GetHoldingRightClick() and (CurTime() - self:GetRightClickStart()) >= 1
end

function SWEP:Reload()
	local owner = self:GetOwner()
	if self:IsPouncing() or CurTime() < self:GetNextPrimaryFire() or not owner:IsOnGround() or self:IsSwinging() or self:GetHoldingRightClick() then return end

	self.PoundAttackStart = CurTime()

	local vel = owner:GetAimVector()
	vel.z = math.max(0.55, vel.z)
	vel:Normalize()

	owner:SetGroundEntity(NULL)
	owner:SetVelocity(vel * 350)

	self.m_ViewAngles = owner:EyeAngles()

	self:SetPouncing(true)
end

function SWEP:IsMoaning()
	return false
end

function SWEP:PlayAlertSound()
	self:GetOwner():EmitSound("npc/barnacle/barnacle_pull"..math.random(4)..".wav", 70)
end

function SWEP:PlayIdleSound()
	self:GetOwner():EmitSound("npc/barnacle/barnacle_pull"..math.random(4)..".wav", 70, 85)
end

function SWEP:PlayAttackSound()
end

function SWEP:PlayHitSound()
	self:EmitSound("physics/body/body_medium_impact_hard"..math.random(6)..".wav", 70, math.random(110, 120), nil, CHAN_AUTO)
end

function SWEP:PlayMissSound()
	self:EmitSound("npc/zombie/claw_miss"..math.random(2)..".wav", 70, math.random(90, 100), nil, CHAN_AUTO)
end

function SWEP:IsInAttackAnim()
	return self:GetAttackAnimTime() > 0 and CurTime() < self:GetAttackAnimTime()
end

function SWEP:SetPouncing(pouncing)
	if not pouncing then
		self.m_ViewAngles = nil
	end

	self:SetDTBool(1, pouncing)
end

function SWEP:IsPouncing()
	return self:GetDTBool(1)
end
SWEP.GetPouncing = SWEP.IsPouncing
