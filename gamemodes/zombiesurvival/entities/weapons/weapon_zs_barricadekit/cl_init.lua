include("shared.lua")

SWEP.PrintName = "'이지스'바리케이드 설치기"
SWEP.Description = "신기술의 발달은 인간들이 바리게이트를 빠르게 생성할 수 있도록 도와주었다.\n'이지스' 바리케이드 설치기는 나무 판자를 즉시 생성해 단단히 고정시킨다.\n공격 1: 설치\n공격 2/재장전: 회전\n달리기 키(기본값:쉬프트): 회수\n생성할려고 하는 위치가 가능한 위치라면 초록색으로 표시된다."
SWEP.DrawCrosshair = false
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false

SWEP.Slot = 4
	SWEP.SlotPos = 0


function SWEP:DrawHUD()
	if GetConVarNumber("crosshair") ~= 1 then return end
	self:DrawCrosshairDot()
end

function SWEP:Deploy()
	self.IdleAnimation = CurTime() + self:SequenceDuration()

	return true
end

function SWEP:GetViewModelPosition(pos, ang)
	return pos, ang
end

function SWEP:DrawWeaponSelection(...)
	return self:BaseDrawWeaponSelection(...)
end

function SWEP:PrimaryAttack()
end

function SWEP:Think()
	if self.Owner:KeyDown(IN_ATTACK2) then
		self:RotateGhost(FrameTime() * 60)
	end
	if self.Owner:KeyDown(IN_RELOAD) then
		self:RotateGhost(FrameTime() * -60)
	end
end

local nextclick = 0
local kityaw = CreateClientConVar("zs_barricadekityaw", 90, false, true)
function SWEP:RotateGhost(amount)
	if nextclick <= RealTime() then
		surface.PlaySound("npc/headcrab_poison/ph_step4.wav")
		nextclick = RealTime() + 0.3
	end
	RunConsoleCommand("zs_barricadekityaw", math.NormalizeAngle(kityaw:GetFloat() + amount))
end
