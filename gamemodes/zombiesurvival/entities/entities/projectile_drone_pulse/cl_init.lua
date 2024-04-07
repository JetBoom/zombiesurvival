INC_CLIENT()

local matGlow = Material("effects/splashwake1")
local matGlow2 = Material("sprites/glow04_noz")
local vector_origin = vector_origin

function ENT:Draw()
	if self:GetVelocity() ~= vector_origin then
		render.SetMaterial(matGlow)
		render.DrawSprite(self:GetPos(), 6, 7, Color(55, 100, 255, 100))
		render.SetMaterial(matGlow2)
		render.DrawSprite(self:GetPos(), 8, 8, Color(255, 255, 255, 255))
	end
end

function ENT:OnRemove()
	local pos = self:GetPos()

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(24, 32)
	local particle
	for i=0, 19 do
		particle = emitter:Add(matGlow, pos)
		particle:SetVelocity(VectorRand() * 25)
		particle:SetDieTime(0.5)
		particle:SetStartAlpha(125)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.Rand(3, 4))
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(-0.8, 0.8))
		particle:SetRollDelta(math.Rand(-3, 3))
		particle:SetColor(100, 125, 255)
	end
	emitter:Finish() emitter = nil collectgarbage("step", 64)
end
