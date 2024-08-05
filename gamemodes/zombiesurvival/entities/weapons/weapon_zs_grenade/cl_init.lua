include("shared.lua")

SWEP.PrintName = "수류탄"
SWEP.Description = "흔히 볼 수 있는 파쇄 수류탄.\n전략적으로 이용하면 다수의 좀비들을 흔적도 없이 쓸어버릴 수 있다."

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
