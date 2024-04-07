EFFECT.LifeTime = 3

function EFFECT:Init(data)
	self:SetRenderBounds(Vector(-64, -64, -64), Vector(64, 64, 64))

	self.Seed = math.Rand(0, 10)

	self.Pos = data:GetOrigin()
	self.Amount = math.Round(data:GetMagnitude(), 2)
	self.Flag = math.Round(data:GetScale()) or 0

	self.DeathTime = CurTime() + self.LifeTime
end

function EFFECT:Think()
	self.Pos.z = self.Pos.z + FrameTime() * 32
	return CurTime() < self.DeathTime
end


local cam_IgnoreZ = cam.IgnoreZ
local cam_Start3D2D = cam.Start3D2D
local cam_End3D2D = cam.End3D2D
local draw_SimpleText = draw.SimpleText
local math_Clamp = math.Clamp
local math_sin = math.sin
local math_floor = math.floor
local EyeAngles = EyeAngles
local tostring = tostring
local TEXT_ALIGN_CENTER = TEXT_ALIGN_CENTER
local TEXT_ALIGN_LEFT = TEXT_ALIGN_LEFT
local TEXT_ALIGN_RIGHT = TEXT_ALIGN_RIGHT

local cols = {}
cols[0] = Color(190, 190, 220, 255)
cols[1] = Color(255, 255, 10, 255)
cols[2] = Color(255, 10, 10, 255)
function EFFECT:Render()
	local delta = math_Clamp(self.DeathTime - CurTime(), 0, self.LifeTime) / self.LifeTime
	local flag = self.Flag
	local col = cols[flag] or cols[0]
	col.a = delta * 240

	local ang = EyeAngles()
	local right = ang:Right()
	ang:RotateAroundAxis(ang:Up(), 270)
	ang:RotateAroundAxis(ang:Forward(), 90)

	cam_IgnoreZ(true)
	cam_Start3D2D(self.Pos + math_sin(CurTime() + self.Seed) * 30 * delta * right, ang, (delta * 0.12 + 0.045) / 2)
		local amount = self.Amount
		local flooramount = math_floor(amount)
		if amount == flooramount then
			if flag == 0 then
				draw_SimpleText(amount, "ZS3D2DFont2Big", 0, 0, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			else
				draw_SimpleText(amount, "ZS3D2DFont2Big", 0, 0, col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
				draw_SimpleText(flag == FM_LOCALKILLOTHERASSIST and " (assisted)" or flag == FM_LOCALASSISTOTHERKILL and " (assist)" or "", "ZS3D2DFont2", 0, 0, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end
		else
			draw_SimpleText(flooramount, "ZS3D2DFont2Big", 0, -21, col, TEXT_ALIGN_RIGHT)
			local righttext
			if flag == 0 then
				righttext = tostring(amount - flooramount):sub(2)
			else
				righttext = tostring(amount - flooramount):sub(2)..(flag == FM_LOCALKILLOTHERASSIST and " (assisted)" or flag == FM_LOCALASSISTOTHERKILL and " (assist)" or "")
			end
			draw_SimpleText(righttext, "ZS3D2DFont2", 2, 8, col, TEXT_ALIGN_LEFT)
		end
	cam_End3D2D()
	cam_IgnoreZ(false)
end
