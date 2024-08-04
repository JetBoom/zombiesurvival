include("shared.lua")

SWEP.PrintName = "수류탄"
SWEP.Description = "단순한 고폭 수류탄이다.\n전략적으로 이용하면 좀비 다수를 터트릴 수 있다."

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
