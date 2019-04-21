SWEP.ZombieOnly = true
SWEP.IsMelee = true

SWEP.ViewModel = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 0.4

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.Delay = 0.22
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo	= "none"

SWEP.NoHitRecovery = 0.75
SWEP.HitRecovery = 1

SWEP.AttackTime = 1.875
SWEP.AttackProcessTime = 1.35
--[[SWEP.AttackDamage = 40
SWEP.AttackDamageType = DMG_BLUNT

SWEP.MeleeReach = 64
SWEP.MeleeSize = 64]]

AccessorFuncDT(SWEP, "AttackStartTime", "Float", 0)
AccessorFuncDT(SWEP, "AttackProcessTime", "Float", 1)

SWEP.PoundAttackStart = 0

function SWEP:Initialize()
	self:HideViewAndWorldModel()
end

function SWEP:Think()
	local time = CurTime()
	local owner = self:GetOwner()

	if self:GetAttackProcessTime() > 0 and time >= self:GetAttackProcessTime() then
		self:SetAttackProcessTime(0)

		if SERVER then
			self:ThrowGibs()
		end
	end

	if self:IsAttacking() and time > self:GetAttackEndTime() then
		self:SetAttackStartTime(0)
		self:SetAttackProcessTime(0)
	end

	if self:IsPouncing() then
		local delay = owner:GetMeleeSpeedMul()
		if owner:WaterLevel() >= 2 then
			self:SetPouncing(false)
			self:SetNextPrimaryFire(time + 0.5 * delay)
		elseif owner:OnGround() and owner:IsOnGround() then
			self:SetPouncing(false)
			self:SetNextPrimaryFire(time + 0.6 * delay)

			if SERVER then
				self:PoundAttackProcess()
			end
		end
	end

	self:NextThink(time)
	return true
end

function SWEP:PrimaryAttack()
	local owner = self:GetOwner()
	if self:IsPouncing() or CurTime() < self:GetNextPrimaryFire() or not owner:IsOnGround() or self:IsAttacking() then return end

	self.PoundAttackStart = CurTime()

	local vel = owner:GetAimVector()
	vel.z = math.max(0.45, vel.z)
	vel:Normalize()

	owner:SetGroundEntity(NULL)
	owner:SetVelocity(vel * 250)
	owner:DoAnimationEvent(ACT_RANGE_ATTACK1)

	if SERVER then
		self:EmitAttackSound()
	end

	self.m_ViewAngles = owner:EyeAngles()

	self:SetPouncing(true)
end

function SWEP:SecondaryAttack()
	local owner = self:GetOwner()
	if self:IsAttacking() or self:IsPouncing() or not owner:IsOnGround() then return end

	self:SetAttackStartTime(CurTime())
	self:SetAttackProcessTime(CurTime() + self.AttackProcessTime)

	if SERVER then
		self:EmitAttackSound()
	end
end

function SWEP:Reload()
	if CurTime() < self:GetNextSecondaryFire() then return end
	self:SetNextSecondaryFire(CurTime() + 2)

	if SERVER then
		self:EmitIdleSound()
	end
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

	if self:IsAttacking() then
		mv:SetMaxSpeed(16)
		mv:SetMaxClientSpeed(16)
		return true
	end
end

function SWEP:EmitIdleSound()
	local ent = self:GetOwner():CompensatedMeleeTrace(4096, 24).Entity
	if ent:IsValidPlayer() then
		self:GetOwner():EmitSound("npc/headcrab/idle"..math.random(3)..".wav", 75, 60)
	else
		self:GetOwner():EmitSound("npc/headcrab/alert1.wav", 75, 60)
	end
end

function SWEP:EmitAttackSound()
	self:GetOwner():EmitSound("npc/ichthyosaur/attack_growl"..math.random(3)..".wav")
end

function SWEP:IsAttacking()
	return self:GetAttackStartTime() > 0
end

function SWEP:GetAttackEndTime()
	return self:GetAttackStartTime() + self.AttackTime
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
