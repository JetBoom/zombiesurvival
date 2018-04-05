AddCSLuaFile()

SWEP.Base = "weapon_zs_manhackcontrol"

if CLIENT then
	SWEP.PrintName = translate.Get("wn_manhacksawcontroll")
	SWEP.Description = translate.Get("wn_manhacksawcontrolldes")
end

SWEP.EntityClass = "prop_manhack_saw"
