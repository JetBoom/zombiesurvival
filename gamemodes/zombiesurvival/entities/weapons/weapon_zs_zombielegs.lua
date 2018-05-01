AddCSLuaFile()

SWEP.PrintName = "Zombie Kung Fu"

SWEP.Base = "weapon_zs_zombie"

SWEP.MeleeDelay = 0.32
SWEP.MeleeReach = 40
SWEP.MeleeDamage = 17

SWEP.DelayWhenDeployed = true

--[[function SWEP:Move(mv)
	if self:IsSwinging() then
		mv:SetMaxSpeed(0)
		mv:SetMaxClientSpeed(0)
	end
end]]

function SWEP:PrimaryAttack(fromsecondary)
	local n = self:GetNextPrimaryAttack()

	if self:GetOwner():IsOnGround() or self:GetOwner():WaterLevel() >= 2 or self:GetOwner():GetMoveType() ~= MOVETYPE_WALK then
		self.BaseClass.PrimaryAttack(self)
	end

	if not fromsecondary and n ~= self:GetNextPrimaryAttack() then
		self:SetDTBool(3, false)
	end
end

function SWEP:SecondaryAttack()
	local n = self:GetNextPrimaryAttack()
	self:PrimaryAttack(true)
	if n ~= self:GetNextPrimaryAttack() then
		self:SetDTBool(3, true)
	end
end

function SWEP:PlayHitSound()
	self:EmitSound("npc/zombie/zombie_pound_door.wav", nil, nil, nil, CHAN_AUTO)
end

function SWEP:PlayAttackSound()
	self:EmitSound("npc/zombie/foot_slide"..math.random(3)..".wav", nil, nil, nil, CHAN_AUTO)
end

function SWEP:Reload()
end

function SWEP:StartMoaning()
end

function SWEP:StopMoaning()
end

function SWEP:IsMoaning()
	return false
end
