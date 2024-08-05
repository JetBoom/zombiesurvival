AddCSLuaFile()

SWEP.Base = "weapon_zs_zombie"

SWEP.MeleeDelay = 0
SWEP.MeleeReach = 16
SWEP.MeleeDamage = 3
SWEP.MeleeForceScale = 0.025
SWEP.MeleeSize = 0.5
SWEP.MeleeDamageType = DMG_SLASH
SWEP.Primary.Delay = 0.32

function SWEP:Think()
	self.BaseClass.Think(self)

	local curtime = CurTime()
	local owner = self.Owner

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

	self.BaseClass.Swung(self)
end

function SWEP:Reload()
	self:SecondaryAttack()
end

function SWEP:IsMoaning()
	return false
end

function SWEP:PlayAlertSound()
	self.Owner:EmitSound("ambient/creatures/teddy.wav", 65, 85)
end

function SWEP:PlayIdleSound()
	self.Owner:EmitSound("ambient/creatures/teddy.wav", 65)
end

function SWEP:PlayAttackSound()
end

function SWEP:PlayHitSound()
	self.Owner:EmitSound("physics/body/body_medium_impact_hard"..math.random(6)..".wav", 65, math.random(130, 140))
end

function SWEP:PlayMissSound()
	self.Owner:EmitSound("npc/zombie/claw_miss"..math.random(2)..".wav", 65, math.random(140, 150))
end

function SWEP:SetSwinging(swinging)
	self:SetDTBool(2, swinging)
end

function SWEP:GetSwinging()
	return self:GetDTBool(2)
end
