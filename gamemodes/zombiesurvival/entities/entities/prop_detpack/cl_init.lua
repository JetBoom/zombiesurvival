INC_CLIENT()

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize()
	self.CreateTime = CurTime()
end

function ENT:Draw()
	self:DrawModel()
end

local matGlow = Material("sprites/glow04_noz")
local colBlue = Color(100, 100, 255)
function ENT:DrawTranslucent()
	local lightpos = self:GetPos() + self:GetUp() * 9 - self:GetRight() * 2
	local armed = self.CreateTime + self.ArmTime < CurTime()

	if self:GetExplodeTime() == 0 then
		if self:GetOwner():IsValid() and armed then
			render.SetMaterial(matGlow)
			render.DrawSprite(lightpos, 16, 16, COLOR_GREEN)
			render.DrawSprite(lightpos, 4, 4, COLOR_WHITE)
		elseif self:GetOwner():IsValid() then
			local size = (CurTime() * 2.5 % 1) * 8

			render.SetMaterial(matGlow)
			render.DrawSprite(lightpos, size, size, COLOR_YELLOW)
			render.DrawSprite(lightpos, size / 4, size / 4, COLOR_WHITE)
		else
			render.SetMaterial(matGlow)
			render.DrawSprite(lightpos, 16, 16, colBlue)
			render.DrawSprite(lightpos, 4, 4, COLOR_WHITE)
		end
	else
		local size = (CurTime() * 2.5 % 1) * 24
		render.SetMaterial(matGlow)
		render.DrawSprite(lightpos, size, size, COLOR_RED)
		render.DrawSprite(lightpos, size / 4, size / 4, COLOR_WHITE)
	end
end
