include("shared.lua")

SWEP.PrintName = "자동 치료기"
SWEP.Description = "이 자동화된 치료 장비는 의료진의 수고를 덜기 위해 개발되었다.\n공격 1: 설치\n달리기 키(기본값:쉬프트): 에너지 충전 (있을 시) / 회수\n사용 키 (기본값:E): 자동 치료\n생성할려고 하는 위치가 가능한 위치라면 초록색으로 표시된다."
SWEP.DrawCrosshair = false

SWEP.Slot = 4
SWEP.SlotPos = 0

function SWEP:Deploy()
	gamemode.Call("WeaponDeployed", self.Owner, self)

	return true
end

function SWEP:DrawHUD()
	if GetConVarNumber("crosshair") ~= 1 then return end
	self:DrawCrosshairDot()
end

function SWEP:PrimaryAttack()
end

function SWEP:DrawWeaponSelection(...)
	return self:BaseDrawWeaponSelection(...)
end

function SWEP:Think()
end

local Menu
function SWEP:SecondaryAttack()
end
