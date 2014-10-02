AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Fast Zombie Kung Fu"
end

SWEP.Base = "weapon_zs_zombie"

SWEP.Primary.Delay = 1

SWEP.MeleeDelay = 0.25
SWEP.MeleeReach = 38
SWEP.MeleeDamage = 13

SWEP.DelayWhenDeployed = true

function SWEP:Move(mv)
	if self:IsSwinging() then
		mv:SetMaxSpeed(0)
		mv:SetMaxClientSpeed(0)
	end
end

function SWEP:PrimaryAttack(fromsecondary)
	local n = self:GetNextPrimaryAttack()

	if self.Owner:IsOnGround() or self.Owner:WaterLevel() >= 2 or self.Owner:GetMoveType() ~= MOVETYPE_WALK then
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
	self.Owner:EmitSound("npc/zombie/zombie_pound_door.wav")
end

function SWEP:PlayAttackSound()
	self.Owner:EmitSound("npc/zombie/foot_slide"..math.random(3)..".wav")
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
