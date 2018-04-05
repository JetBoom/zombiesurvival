include("shared.lua")

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Draw()
	self:DrawModel()
end

local matGlow = Material("sprites/glow04_noz")
local colBlue = Color(100, 100, 255)
function ENT:DrawTranslucent()
	local lightpos = self:GetPos() + self:GetUp() * 8 - self:GetRight() * 2

	if self:GetExplodeTime() == 0 then
		if self:GetOwner():IsValid() then
			render.SetMaterial(matGlow)
			render.DrawSprite(lightpos, 16, 16, COLOR_GREEN)
			render.DrawSprite(lightpos, 4, 4, COLOR_DARKGREEN)
		else
			render.SetMaterial(matGlow)
			render.DrawSprite(lightpos, 16, 16, colBlue)
			render.DrawSprite(lightpos, 4, 4, COLOR_WHITE)
		end
	else
		local size = (CurTime() * 2.5 % 1) * 24
		render.SetMaterial(matGlow)
		render.DrawSprite(lightpos, size, size, COLOR_RED)
		render.DrawSprite(lightpos, size / 4, size / 4, COLOR_DARKRED)
	end
end
