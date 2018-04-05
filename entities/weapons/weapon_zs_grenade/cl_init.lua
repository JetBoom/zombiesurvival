include("shared.lua")

SWEP.PrintName = translate.Get("ars_grenade")
SWEP.Description = translate.Get("grenade_desk")

SWEP.ViewModelFOV = 60

SWEP.Slot = 4
SWEP.SlotPos = 0

--[[function SWEP:GetViewModelPosition(pos, ang)
	if self:GetPrimaryAmmoCount() <= 0 then
		return pos + ang:Forward() * -256, ang
	end

	return pos, ang
end]]

function SWEP:DrawWeaponSelection(...)
	return self:BaseDrawWeaponSelection(...)
end
