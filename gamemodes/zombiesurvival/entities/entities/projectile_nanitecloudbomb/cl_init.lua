INC_CLIENT()

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.NextEmit = 0

local matGlow = Material("sprites/light_glow02_add")
function ENT:DrawTranslucent()
	render.SetColorModulation(0.7, 0.2, 0.4)
	self:DrawModel()
	render.SetColorModulation(1, 1, 1)

	render.SetMaterial(matGlow)
	render.DrawSprite(self:GetPos(), 64, 64, COLOR_CYAN)

	if CurTime() >= self.NextEmit then
		local pos = self:GetPos()
		local emitter = ParticleEmitter(pos)
		emitter:SetNearClip(24, 32)

		for i=1, 10 do
			local dir = VectorRand():GetNormalized()
			local particle = emitter:Add("sprites/glow04_noz", pos)
			particle:SetDieTime(math.Rand(1.3, 2.1))
			particle:SetColor(145,155,255)
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)
			particle:SetStartSize(15)
			particle:SetEndSize(0)
			particle:SetGravity(dir * -6)
			particle:SetVelocity(dir * 5)
		end

		emitter:Finish() emitter = nil collectgarbage("step", 64)

		self.NextEmit = CurTime() + 0.09
	end
end
