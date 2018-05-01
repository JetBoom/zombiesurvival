SWEP.Base = "weapon_zs_zombie"

SWEP.MeleeReach = 52
SWEP.MeleeDelay = 0.36
SWEP.MeleeSize = 4.5
SWEP.MeleeDamage = 24
SWEP.SlowDownScale = 3
SWEP.MeleeDamageType = DMG_SLASH
SWEP.MeleeAnimationDelay = 0.05

SWEP.Primary.Delay = 0.8

SWEP.ViewModel = Model("models/weapons/v_pza.mdl")
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"

AccessorFuncDT(SWEP, "HookTime", "Float", 1)

function SWEP:SecondaryAttack()
	if CurTime() < self:GetNextPrimaryFire() or CurTime() < self:GetNextSecondaryFire() then return end

	self:SetNextSecondaryFire(CurTime() + 3.25)
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	self:SetSwingAnimTime(CurTime() + 0.7)

	self:GetOwner():DoReloadEvent()

	self:EmitSound("npc/headcrab_poison/ph_poisonbite3.wav", 75, 46)

	self:SetHookTime(CurTime() + 0.9)
end

function SWEP:Think()
	if self:GetHookTime() > 0 and CurTime() >= self:GetHookTime() then
		self:SetHookTime(0)

		self:EmitSound("physics/flesh/flesh_squishy_impact_hard"..math.random(2, 4)..".wav", 72, math.random(70, 83))
		self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)

		if SERVER then
			self:ThrowHook()
		end
	end

	return self.BaseClass.Think(self)
end

function SWEP:Reload()
	self.BaseClass.SecondaryAttack(self)
end

function SWEP:CheckMoaning()
end

function SWEP:StopMoaningSound()
end

function SWEP:StartMoaningSound()
end

function SWEP:PlayHitSound()
	self:EmitSound("npc/zombie/claw_strike"..math.random(3)..".wav", 75, 80, nil, CHAN_AUTO)
end

function SWEP:PlayMissSound()
	self:EmitSound("npc/zombie/claw_miss"..math.random(2)..".wav", 75, 80, nil, CHAN_AUTO)
end

function SWEP:PlayAttackSound()
end

function SWEP:PlayAlertSound()
	self:GetOwner():EmitSound("npc/antlion_guard/angry"..math.random(3)..".wav", 75, 140)
end
SWEP.PlayIdleSound = SWEP.PlayAlertSound

function SWEP:SetSwingAnimTime(time)
	self:SetDTFloat(3, time)
end

function SWEP:GetSwingAnimTime()
	return self:GetDTFloat(3)
end

function SWEP:StartSwinging()
	self.BaseClass.StartSwinging(self)
	self:SetSwingAnimTime(CurTime() + 1)
end
