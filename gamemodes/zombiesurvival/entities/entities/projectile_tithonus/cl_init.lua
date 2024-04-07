INC_CLIENT()

local matGlow = Material("effects/splashwake1")
local matGlow2 = Material("sprites/light_glow02_add")
local matWhite = Material("models/debug/debugwhite")
local vector_origin = vector_origin

ENT.SmokeTimer = 0

function ENT:Draw()
	render.ModelMaterialOverride(matWhite)
	render.SetColorModulation(0.1, 0.9, 0.3)
	render.SuppressEngineLighting(true)
	self:DrawModel()
	render.SuppressEngineLighting(false)
	render.SetColorModulation(1, 1, 1)
	render.ModelMaterialOverride(nil)

	local pos = self:GetPos()

	if self:GetVelocity() ~= vector_origin then
		render.SetMaterial(matGlow)
		render.DrawSprite(pos, 7, 7, Color(30, 155, 70))

		render.SetMaterial(matGlow2)
		render.DrawSprite(pos, 29, 6, Color(90, 255, 130))
		render.DrawSprite(pos, 3, 23, Color(90, 255, 130))

		local emitter = ParticleEmitter(pos)
		emitter:SetNearClip(24, 32)
		local particle
		for i=0, 1 do
			particle = emitter:Add(matGlow2, pos)
			particle:SetVelocity(VectorRand() * 5)
			particle:SetDieTime(0.05)
			particle:SetStartAlpha(175)
			particle:SetEndAlpha(0)
			particle:SetStartSize(5)
			particle:SetEndSize(0)
			particle:SetRollDelta(math.Rand(-10, 10))
			particle:SetColor(50, 255, 110)
		end
		emitter:Finish() emitter = nil collectgarbage("step", 64)
	end
end

function ENT:Initialize()
end

function ENT:Think()
end
