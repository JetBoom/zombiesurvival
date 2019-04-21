DEFINE_BASECLASS("weapon_zs_zombie")

SWEP.PrintName = "Poison Zombie"

SWEP.MeleeReach = 48
SWEP.MeleeDelay = 0.9
SWEP.MeleeSize = 4.5
SWEP.MeleeDamage = 40
SWEP.MeleeDamageType = DMG_SLASH
SWEP.MeleeAnimationDelay = 0.35

SWEP.Primary.Delay = 1.6
SWEP.Secondary.Delay = 4

SWEP.PoisonThrowDelay = 1
SWEP.PoisonThrowSpeed = 380

SWEP.ViewModel = Model("models/weapons/v_pza.mdl")
SWEP.WorldModel = ""

function SWEP:Think()
	BaseClass.Think(self)

	local time = CurTime()

	if self.NextThrowAnim and time >= self.NextThrowAnim and IsFirstTimePredicted() then
		self.NextThrowAnim = nil

		self:EmitSound(string.format("physics/body/body_medium_break%d.wav", math.random(2, 4)), 72, math.random(70, 83))
		self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
		self.IdleAnimation = time + self:SequenceDuration()
	end

	if self.NextThrow then
		if time >= self.NextThrow and IsFirstTimePredicted() then
			self.NextThrow = nil

			local owner = self:GetOwner()

			owner.LastRangedAttack = CurTime()

			owner:ResetSpeed()
			owner:RawCapLegDamage(CurTime() + 1.5)

			self:EmitSound(string.format("physics/body/body_medium_break%d.wav", math.random(2, 4)), 72, math.random(70, 80))

			if SERVER then
				self:DoThrow()
			end
		end

		self:NextThink(time)
		return true
	end
end

function SWEP:PrimaryAttack()
	if not self.NextThrow then
		BaseClass.PrimaryAttack(self)
	end
end

function SWEP:SecondaryAttack()
	if not IsFirstTimePredicted() then return end

	local time = CurTime()
	if time < self:GetNextPrimaryFire() or time < self:GetNextSecondaryFire() then return end

	local owner = self:GetOwner()

	owner:DoAnimationEvent(ACT_RANGE_ATTACK2)
	owner:SetSpeed(60)

	self:EmitSound("NPC_PoisonZombie.Throw")

	self:SetNextSecondaryFire(time + self.Secondary.Delay)
	self:SetNextPrimaryFire(time + self.Primary.Delay)

	self.NextThrow = time + self.PoisonThrowDelay
	self.NextThrowAnim = self.NextThrow - 0.4
end

function SWEP:Reload()
	if not self.NextThrow then
		BaseClass.SecondaryAttack(self)
	end
end

function SWEP:CheckMoaning()
end

function SWEP:StopMoaningSound()
end

function SWEP:StartMoaningSound()
end

function SWEP:PlayHitSound()
	self:EmitSound("npc/zombie/claw_strike"..math.random(1, 3)..".wav", 75, 80, nil, CHAN_AUTO)
end

function SWEP:PlayMissSound()
	self:EmitSound("npc/zombie/claw_miss"..math.random(1, 2)..".wav", 75, 80, nil, CHAN_AUTO)
end

function SWEP:PlayAttackSound()
	self:EmitSound("NPC_PoisonZombie.ThrowWarn")
end

function SWEP:PlayAlertSound()
	self:GetOwner():EmitSound("NPC_PoisonZombie.Alert")
end
SWEP.PlayIdleSound = SWEP.PlayAlertSound
