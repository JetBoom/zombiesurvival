AddCSLuaFile()

SWEP.Base = "weapon_zs_zombie"

SWEP.ViewModel = "models/weapons/c_arms_citizen.mdl"
SWEP.WorldModel	= ""
SWEP.UseHands = true
SWEP.ViewModelFOV = 40

SWEP.MeleeDelay = 0
SWEP.MeleeReach = 16
SWEP.MeleeDamage = 3
SWEP.MeleeForceScale = 0.025
SWEP.MeleeSize = 1 --0.5
SWEP.MeleeDamageType = DMG_SLASH
SWEP.Primary.Delay = 0.32

function SWEP:Think()
	self.BaseClass.Think(self)

	local curtime = CurTime()
	local owner = self:GetOwner()

	if self:GetSwinging() then
		if not owner:KeyDown(IN_ATTACK) and self.SwingStop and self.SwingStop <= curtime then
			self:SetSwinging(false)
			self.SwingStop = nil
		end
	end

	self:NextThink(CurTime())
	return true
end

function SWEP:Swung()
	self.SwingStop = CurTime() + 0.5

	if not self:GetSwinging() then
		self:SetSwinging(true)
	end

	self.AltSwing = not self.AltSwing

	local vm = self:GetOwner():GetViewModel()
	vm:SendViewModelMatchingSequence(vm:LookupSequence(self.AltSwing and "fists_left" or "fists_right"))

	self.BaseClass.Swung(self)
end

function SWEP:Deploy()
	local vm = self:GetOwner():GetViewModel()
	vm:SendViewModelMatchingSequence(vm:LookupSequence("fists_draw"))

	return self.BaseClass.Deploy(self)
end

function SWEP:Reload()
	self:SecondaryAttack()
end

function SWEP:IsMoaning()
	return false
end

function SWEP:PlayAlertSound()
	self:GetOwner():EmitSound("ambient/creatures/teddy.wav", 65, 85)
end

function SWEP:PlayIdleSound()
	self:GetOwner():EmitSound("ambient/creatures/teddy.wav", 65)
end

function SWEP:PlayAttackSound()
end

function SWEP:PlayHitSound()
	self:EmitSound("physics/body/body_medium_impact_hard"..math.random(6)..".wav", 65, math.random(130, 140), nil, CHAN_AUTO)
end

function SWEP:PlayMissSound()
	self:EmitSound("npc/zombie/claw_miss"..math.random(2)..".wav", 65, math.random(140, 150), nil, CHAN_AUTO)
end

function SWEP:SetSwinging(swinging)
	self:SetDTBool(2, swinging)
end

function SWEP:GetSwinging()
	return self:GetDTBool(2)
end
