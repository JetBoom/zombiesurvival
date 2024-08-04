include("shared.lua")

SWEP.PrintName = "상점 상자"
SWEP.Description = "이 상자가 없다면 그 누구도 살아남을 수 없다.\n대재앙 이전 부흥하던 인터넷 쇼핑몰의 기술을 이용해 무기, 탄약, 도구 등을 빠르게 공급한다.\n설치한 사람은 모든 플레이어의 구매가격에서 7%를 이익으로 가져간다.\n공격 1: 설치\n공격 2/재장전: 회전\n달리기 키(기본값:쉬프트): 회수\n사용 키(기본값:E):주인 없는 상자 가져가기\n생성할려고 하는 위치가 가능한 위치라면 초록색으로 표시된다."
SWEP.DrawCrosshair = false

SWEP.Slot = 4
SWEP.SlotPos = 0

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
	if self.Owner:KeyDown(IN_ATTACK2) then
		self:RotateGhost(FrameTime() * 60)
	end
	if self.Owner:KeyDown(IN_RELOAD) then
		self:RotateGhost(FrameTime() * -60)
	end
end

function SWEP:Deploy()
	gamemode.Call("WeaponDeployed", self.Owner, self)

	return true
end

local nextclick = 0
function SWEP:RotateGhost(amount)
	if nextclick <= RealTime() then
		surface.PlaySound("npc/headcrab_poison/ph_step4.wav")
		nextclick = RealTime() + 0.3
	end

	RunConsoleCommand("_zs_ghostrotation", math.NormalizeAngle(GetConVarNumber("_zs_ghostrotation") + amount))
end
