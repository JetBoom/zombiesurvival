AddCSLuaFile()

SWEP.Base = "weapon_zs_zombie"

SWEP.PrintName = "Infected Citizen"

SWEP.MeleeDamage = 26

function SWEP:Reload()
	self:SecondaryAttack()
end

function SWEP:StartMoaning()
end

function SWEP:StopMoaning()
end

function SWEP:IsMoaning()
	return false
end
