INC_CLIENT()

local matGlow = Material("effects/splashwake1")
local matGlow2 = Material("sprites/glow04_noz")
local vector_origin = vector_origin

function ENT:Draw()
	local pos = self:GetPos()

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(24, 32)
	local particle
	for i=0, 1 do
		particle = emitter:Add(matGlow2, pos)
		particle:SetVelocity(VectorRand() * 45)
		particle:SetDieTime(0.15)
		particle:SetStartAlpha(75)
		particle:SetEndAlpha(0)
		particle:SetStartSize(10)
		particle:SetEndSize(0)
		particle:SetRollDelta(math.Rand(-10, 10))
		particle:SetColor(192, 255, 130)
	end
	emitter:Finish() emitter = nil collectgarbage("step", 64)

	if self:GetVelocity() ~= vector_origin then
		render.SetMaterial(matGlow)
		render.DrawSprite(pos, 15, 15, Color(100, 170, 70, 100))
		render.SetMaterial(matGlow2)
		render.DrawSprite(pos, 35, 35, Color(155, 255, 100, 100))
		render.DrawSprite(pos, 25, 25, Color(255, 255, 255, 255))
	end
end
