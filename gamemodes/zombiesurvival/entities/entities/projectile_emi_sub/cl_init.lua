INC_CLIENT()

ENT.NextEmit = 0

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

local matGlow = Material("sprites/light_glow02_add")

function ENT:Initialize()
	self:DrawShadow(false)
end

local matWhite = Material("models/debug/debugwhite")
function ENT:Draw()
	render.ModelMaterialOverride(matWhite)
	render.SuppressEngineLighting(true)
	self:DrawModel()
	render.SuppressEngineLighting(false)
	render.ModelMaterialOverride(nil)

	local pos = self:GetPos()

	render.SetMaterial(matGlow)
	render.DrawSprite(pos, 32, 32)

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(24, 32)
	local particle

	for i=0, 1 do
		particle = emitter:Add(matGlow, pos)
		particle:SetVelocity(VectorRand() * 5)
		particle:SetDieTime(0.2)
		particle:SetStartAlpha(175)
		particle:SetEndAlpha(0)
		particle:SetStartSize(5)
		particle:SetEndSize(0)
		particle:SetRollDelta(math.Rand(-10, 10))
		particle:SetColor(110, 110, 110)
	end

	emitter:Finish() emitter = nil collectgarbage("step", 64)
end

function ENT:Think()
end
function ENT:OnRemove()
	local pos = self:GetPos()

	sound.Play("weapons/physcannon/energy_sing_explosion2.wav", pos, 65, math.Rand(245, 250))

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(24, 32)
	local particle

	for i=0,4 do
		particle = emitter:Add(matGlow, pos)
		particle:SetVelocity(VectorRand() * 5)
		particle:SetDieTime(0.4)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.Rand(34, 36))
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(-0.8, 0.8))
		particle:SetRollDelta(math.Rand(-3, 3))
		particle:SetColor(255, 255, 255)
	end

	emitter:Finish() emitter = nil collectgarbage("step", 64)
end
