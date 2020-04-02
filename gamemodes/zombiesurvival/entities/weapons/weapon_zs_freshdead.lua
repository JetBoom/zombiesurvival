AddCSLuaFile()

SWEP.Base = "weapon_zs_zombie"

SWEP.PrintName = ""..translate.Get("class_fresh_dead")

SWEP.MeleeDamage = 20

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
