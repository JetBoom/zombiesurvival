INC_CLIENT()

ENT.NextEmit = 0
ENT.Seed = 0

function ENT:Initialize()
	self:SetModelScale(0.2, 0)
	self:DrawShadow(false)

	self.Seed = math.Rand(0, 10)
end

local matGlow = Material("effects/splash2")
local matSplay = Material("particles/smokey")
function ENT:Draw()
	local type = self:GetDTInt(5)
	local c = type == 0 and Color(120, 205, 60, 70) or type == 1 and Color(205, 120, 60, 70) or Color(70, 195, 235, 70)
	self:SetColor(c)
	render.SetBlend(0.7)
	self:DrawModel()
	render.SetBlend(1)

	local pos = self:GetPos()
	local add = math.sin((CurTime() + self.Seed) * 3) * 2

	render.SetMaterial(matSplay)
	render.DrawSprite(pos, 12 - add, 18 + add, c)
	render.SetMaterial(matGlow)
	render.DrawSprite(pos, 18 + add, 18 - add, c)
end

function ENT:OnRemove()
	local pos = self:GetPos()
	local type = self:GetDTInt(5)
	local c = type == 0 and Color(120, 205, 60) or type == 1 and Color(205, 120, 60) or Color(70, 195, 235)

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(24, 32)
	local particle
	for i=1, 12 do
		particle = emitter:Add("particles/smokey", pos)
		particle:SetDieTime(0.4)
		particle:SetColor(c.r, c.g, c.b)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(3)
		particle:SetEndSize(0)
		particle:SetCollide(true)
		particle:SetGravity(Vector(0, 0, -300))
		particle:SetVelocity(VectorRand():GetNormal() * 120)
	end
	for i=0,5 do
		particle = emitter:Add("sprites/light_glow02_add", pos)
		particle:SetVelocity(VectorRand() * 5)
		particle:SetDieTime(0.3)
		particle:SetStartAlpha(25)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.Rand(27, 29))
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(-0.8, 0.8))
		particle:SetRollDelta(math.Rand(-3, 3))
		particle:SetColor(c.r, c.g, c.b)
	end
	emitter:Finish() emitter = nil collectgarbage("step", 64)
end
