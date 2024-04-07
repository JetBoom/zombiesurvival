EFFECT.LifeTime = 0.25

function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local ent = data:GetEntity()

	self.DieTime = RealTime() + self.LifeTime

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(16, 24)
	for i=1, 16 do
		local heading = VectorRand()
		heading:Normalize()

		particle = emitter:Add("sprites/light_glow02_add", pos + heading * 8)
		particle:SetDieTime(math.Rand(0.75, 1.5))
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(255)
		particle:SetStartSize(8)
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-14, 14))
		particle:SetColor(0, 120, 255)
		particle:SetVelocity(heading * math.Rand(128, 256))
		particle:SetAirResistance(256)
	end
	emitter:Finish() emitter = nil collectgarbage("step", 64)

	if ent == MySelf then
		MySelf:EmitSound("ambient/machines/teleport1.wav", 75, 110, 0.8)
		util.WhiteOut(1)
	end
end

function EFFECT:Think()
	return RealTime() < self.DieTime
end

local matGlow = Material("sprites/glow04_noz")
local colGlow = Color(0, 120, 255)
function EFFECT:Render()
	local pos = self.Entity:GetPos()
	local delta = math.Clamp((self.DieTime - RealTime()) / self.LifeTime, 0, 1)

	colGlow.a = delta * 255

	local size = 128 - delta * 92

	render.SetMaterial(matGlow)
	render.DrawQuadEasy(pos, Vector(0, 0, -1), size, size, colGlow)
	render.DrawQuadEasy(pos, Vector(0, 0, 1), size, size, colGlow)
	render.DrawQuadEasy(pos, Vector(0, -1, 0), size, size, colGlow)
	render.DrawQuadEasy(pos, Vector(0, 1, 0), size, size, colGlow)
	render.DrawQuadEasy(pos, Vector(-1, 0, 0), size, size, colGlow)
	render.DrawQuadEasy(pos, Vector(1, 0, 0), size, size, colGlow)
	render.DrawSprite(pos, size, size, colGlow)
end
