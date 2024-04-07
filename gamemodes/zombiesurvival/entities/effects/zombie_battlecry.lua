function EFFECT:Init(effectdata)
	local pos = effectdata:GetOrigin()
	local normal = effectdata:GetNormal()

	local emitter = ParticleEmitter(pos, true)
	emitter:SetNearClip(24, 32)
	local emitter2 = ParticleEmitter(pos)
	emitter2:SetNearClip(24, 32)


	for i=1,3 do
		local particle = emitter:Add("effects/select_ring", pos)
		particle:SetDieTime(0.1 + i * 0.1)
		particle:SetColor(255,35,0)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(0)
		particle:SetEndSize(220)
		particle:SetAngles(normal:Angle())
		particle = emitter:Add("effects/select_ring", pos)
		particle:SetDieTime(0.2 + i * 0.1)
		particle:SetColor(255,35,0)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(0)
		particle:SetEndSize(290)
		particle:SetAngles(normal:Angle())
	end
	for i=1,100 do
		local particle = emitter2:Add("effects/splash2", pos)
		particle:SetDieTime(0.4)
		particle:SetColor(255,35,0)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(4)
		particle:SetEndSize(4)
		particle:SetStartLength(30)
		particle:SetEndLength(30)
		particle:SetVelocity(VectorRand():GetNormal() * math.random(450,600))
	end

	emitter:Finish() emitter = nil collectgarbage("step", 64)
	emitter2:Finish() emitter2 = nil collectgarbage("step", 64)

end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end

