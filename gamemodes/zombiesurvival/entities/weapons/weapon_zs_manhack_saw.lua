AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "톱날 맨핵"
	SWEP.Description = "맨핵에 톱날을 달아 더욱 강력해진 맨핵이다. 단 조종하기가 약간 힘들다."
end

SWEP.Base = "weapon_zs_manhack"

SWEP.DeployClass = "prop_manhack_saw"
SWEP.ControlWeapon = "weapon_zs_manhackcontrol_saw"

SWEP.Primary.Ammo = "manhack_saw"
