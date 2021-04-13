INC_CLIENT()

SWEP.DrawCrosshair = false

SWEP.Slot = 4
SWEP.SlotPos = 0

function SWEP:DrawHUD()
	if GetConVar("crosshair"):GetInt() ~= 1 then return end
	self:DrawCrosshairDot()
end

function SWEP:PrimaryAttack()
end

function SWEP:DrawWeaponSelection(x, y, w, h, alpha)
	self:BaseDrawWeaponSelection(x, y, w, h, alpha)
end

function SWEP:Think()
	if self:GetOwner():KeyDown(IN_ATTACK2) then
		self:RotateGhost(FrameTime() * 60)
	end
	if self:GetOwner():KeyDown(IN_RELOAD) then
		self:RotateGhost(FrameTime() * -60)
	end
end

function SWEP:Deploy()
	gamemode.Call("WeaponDeployed", self:GetOwner(), self)

	return true
end

local nextclick = 0
function SWEP:RotateGhost(amount)
	if nextclick <= RealTime() then
		surface.PlaySound("npc/headcrab_poison/ph_step4.wav")
		nextclick = RealTime() + 0.3
	end

	RunConsoleCommand("_zs_ghostrotation", math.NormalizeAngle(GetConVar("_zs_ghostrotation"):GetFloat() + amount))
end
