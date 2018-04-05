AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = translate.Get("wn_manhacksaw")
	SWEP.Description = translate.Get("wn_manhacksawdes")
end

SWEP.Base = "weapon_zs_manhack"

SWEP.DeployClass = "prop_manhack_saw"
SWEP.ControlWeapon = "weapon_zs_manhackcontrol_saw"

SWEP.Primary.Ammo = "manhack_saw"
