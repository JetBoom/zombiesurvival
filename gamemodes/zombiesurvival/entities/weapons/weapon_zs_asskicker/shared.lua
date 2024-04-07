SWEP.PrintName = "Giant Zombie Kung Fu"

SWEP.Base = "weapon_zs_zombie"

SWEP.MeleeDelay = 0.32
SWEP.MeleeReach = 70
SWEP.MeleeSize = 16
SWEP.MeleeDamage = 35

SWEP.DelayWhenDeployed = true

--[[function SWEP:Move(mv)
	if self:IsSwinging() then
		mv:SetMaxSpeed(50)
		mv:SetMaxClientSpeed(50)
	end
end]]

function SWEP:PrimaryAttack(fromsecondary)
	local n = self:GetNextPrimaryAttack()

	local owner = self:GetOwner()
	if owner:IsOnGround() or owner:WaterLevel() >= 2 or owner:GetMoveType() ~= MOVETYPE_WALK then
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
	self:EmitSound("npc/zombie/zombie_pound_door.wav", 77, 65, nil, CHAN_AUTO)
end

function SWEP:PlayAttackSound()
	self:EmitSound("npc/zombie/foot_slide"..math.random(3)..".wav", 77, 65, nil, CHAN_AUTO)
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
