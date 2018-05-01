EFFECT.LifeTime = 7

EFFECT.NextEmit = 0

function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local normal = data:GetNormal() * -1

	pos = pos + normal

	self.Pos = pos
	self.Normal = normal
	self.DieTime = CurTime() + self.LifeTime

	sound.Play("weapons/physcannon/energy_sing_explosion2.wav", pos, 75, math.Rand(25, 35))

	util.ScreenShake(pos, 5, 5, 1, 300)

	local dlight = DynamicLight(0)
	if dlight then
		dlight.Pos = pos
		dlight.r = 255
		dlight.g = 255
		dlight.b = 255
		dlight.Brightness = 8
		dlight.Size = 500
		dlight.Decay = 2000
		dlight.DieTime = CurTime() + self.LifeTime
	end

	if MySelf:IsValid() then
		local eyepos = MySelf:EyePos()
		local dist = eyepos:Distance(pos)
		if dist < 400 and WorldVisible(eyepos, pos) then
			local power = 1 - dist / 800

			local dir = pos - eyepos
			dir:Normalize()
			power = power - (1 - math.max(0, EyeVector():Dot(dir))) / 3

			if MySelf:Team() ~= TEAM_HUMAN then
				power = power / 3
			end

			if not TrueVisible(eyepos, pos) then
				power = power * 0.66
			end

			if MySelf:Team() ~= TEAM_UNDEAD then
				power = math.max(power, 0.4)
			end

			if power > 0.5 then
				MySelf:SetDSP(36)
			end

			local visionaltermul = MySelf.VisionAlterDurationMul or 1
			util.WhiteOut(power * 8 * visionaltermul, 2 * visionaltermul)
		end
	end
end

function EFFECT:Think()
	return CurTime() < self.DieTime
end

local matRefract = Material("refract_ring")
local matGlow = Material("sprites/glow04_noz")
local colGlow = Color(255, 255, 255)
function EFFECT:Render()
	local pos = self.Pos
	local delta = (self.DieTime - CurTime()) / self.LifeTime
	local basesize = 64
	basesize = basesize + basesize ^ (1.5 - delta)

	if CurTime() >= self.NextEmit then
		self.NextEmit = CurTime() + 0.05

		local emitter = ParticleEmitter(pos)
		emitter:SetNearClip(24, 32)

		local heading = VectorRand()
		heading:Normalize()

		local particle = emitter:Add("effects/spark", pos + heading * 8)
		particle:SetVelocity(420 * heading)
		particle:SetDieTime(math.Rand(0.5, 0.85))
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(255)
		particle:SetStartSize(math.Rand(3, 4))
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-10, 10))
		particle:SetAirResistance(250)

		emitter:Finish() emitter = nil collectgarbage("step", 64)
	end

	matRefract:SetFloat("$refractamount", (0.75 + math.abs(math.sin(CurTime() * 5)) * math.pi * 0.25) * delta)
	render.SetMaterial(matRefract)
	render.UpdateRefractTexture()
	render.DrawSprite(pos, basesize, basesize)
	render.DrawQuadEasy(pos, self.Normal, basesize, basesize, color_white, 0)
	render.DrawQuadEasy(pos, self.Normal, basesize, basesize, color_white, 0)

	basesize = basesize * 1.25

	colGlow.a = delta * 255
	render.SetMaterial(matGlow)
	render.DrawSprite(pos, basesize, basesize, colGlow)
	render.DrawQuadEasy(pos, self.Normal, basesize, basesize, colGlow, 0)
	render.DrawQuadEasy(pos, self.Normal, basesize, basesize, colGlow, 0)
end
