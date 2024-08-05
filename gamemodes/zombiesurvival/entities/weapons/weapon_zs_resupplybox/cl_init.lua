include("shared.lua")

SWEP.PrintName = "보급 상자"
SWEP.Description = "생존자들이 현재 들고 있는 무기 또는 도구의 탄환 또는 못 등등을 지급한다. 각 생존자마다 일정 시간에 한 번 사용할 수 있다.\n공격 1: 설치\n공격 2/재장전: 회전\n달리기 키(기본값:쉬프트): 회수\n사용 키(기본값:E):탄약 가져가기/주인 없는 보급 상자 가져가기\n생성할려고 하는 위치가 가능한 위치라면 초록색으로 표시된다."SWEP.DrawCrosshair = false
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
