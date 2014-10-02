EFFECT.LifeTime = 3

function EFFECT:Init(data)
	self:SetRenderBounds(Vector(-64, -64, -64), Vector(64, 64, 64))

	self.Seed = math.Rand(0, 10)

	local pos = data:GetOrigin()
	local amount = math.Round(data:GetMagnitude())

	self.Pos = pos
	local flag = math.Round(data:GetScale()) or 0
	if flag == FM_LOCALKILLOTHERASSIST then
		self.Amount = amount.." (assisted)"
	elseif flag == FM_LOCALASSISTOTHERKILL then
		self.Amount = amount.." (assist)"
	else
		self.Amount = amount
	end
	self.ColID = flag

	self.DeathTime = CurTime() + self.LifeTime
end

function EFFECT:Think()
	self.Pos.z = self.Pos.z + FrameTime() * 32
	return CurTime() < self.DeathTime
end

local cols = {}
cols[0] = Color(190, 190, 220, 255)
cols[1] = Color(255, 255, 10, 255)
cols[2] = Color(255, 10, 10, 255)
local col2 = Color(0, 0, 0, 255)
function EFFECT:Render()
	local delta = math.Clamp(self.DeathTime - CurTime(), 0, self.LifeTime) / self.LifeTime
	local col = cols[self.ColID] or cols[0]
	col.a = delta * 240
	col2.a = col.a
	local ang = EyeAngles()
	local right = ang:Right()
	ang:RotateAroundAxis(ang:Up(), 270)
	ang:RotateAroundAxis(ang:Forward(), 90)
	cam.IgnoreZ(true)
	cam.Start3D2D(self.Pos + math.sin(CurTime() + self.Seed) * 30 * delta * right, ang, (delta * 0.12 + 0.045) / 2)
		draw.SimpleText(self.Amount, "ZS3D2DFont2Big", 0, -21, col, TEXT_ALIGN_CENTER)
	cam.End3D2D()
	cam.IgnoreZ(false)
end
