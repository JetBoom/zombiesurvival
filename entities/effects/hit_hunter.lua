EFFECT.LifeTime = 0.375
EFFECT.Size = 128

function EFFECT:Init(data)
	self.DieTime = CurTime() + self.LifeTime

	local normal = data:GetNormal()
	local pos = data:GetOrigin()

	pos = pos + normal * 2
	self.Pos = pos
	self.Normal = normal

	sound.Play("physics/metal/metal_sheet_impact_bullet"..math.random(2)..".wav", pos, 80, math.Rand(85, 95))
end

function EFFECT:Think()
	return CurTime() < self.DieTime
end

local matRefraction	= Material("refract_ring")
local matGlow = Material("effects/rollerglow")
local colGlow = Color(255, 30, 255)
function EFFECT:Render()
	local delta = math.Clamp((self.DieTime - CurTime()) / self.LifeTime, 0, 1)
	local rdelta = 1 - delta
	local size = rdelta ^ 0.5 * self.Size
	colGlow.a = delta * 220
	colGlow.r = delta * 255
	colGlow.b = colGlow.r - 255

	render.SetMaterial(matGlow)
	render.DrawQuadEasy(self.Pos, self.Normal, size, size, colGlow, 0)
	render.DrawQuadEasy(self.Pos, self.Normal * -1, size, size, colGlow, 0)
	render.DrawSprite(self.Pos, size, size, colGlow)
	matRefraction:SetFloat("$refractamount", math.sin(delta * 2 * math.pi) * 0.2)
	render.SetMaterial(matRefraction)
	render.UpdateRefractTexture()
	render.DrawQuadEasy(self.Pos, self.Normal, size, size, color_white, 0)
	render.DrawQuadEasy(self.Pos, self.Normal * -1, size, size, color_white, 0)
	render.DrawSprite(self.Pos, size, size, color_white)
end
