INC_CLIENT()

ENT.NextEmit = 0

function ENT:Initialize()
	self:DrawShadow(false)

	self.Size = math.Rand(10, 14)
end

local colFlesh = Color(255, 255, 255, 255)
local matFlesh = Material("decals/Yblood1")
function ENT:Draw()
	local size = self.Size

	render.SetMaterial(matFlesh)
	local pos = self:GetPos()
	render.DrawSprite(pos, size, size, colFlesh)

	if CurTime() < self.NextEmit then return end
	self.NextEmit = CurTime() + 0.05

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(36, 44)

	local particle = emitter:Add("decals/Yblood"..math.random(6), pos + VectorRand():GetNormalized() * math.Rand(1, 4))
	particle:SetVelocity(VectorRand():GetNormalized() * math.Rand(1, 4))
	particle:SetDieTime(math.Rand(0.6, 0.9))
	particle:SetStartAlpha(255)
	particle:SetEndAlpha(255)
	particle:SetStartSize(size * math.Rand(0.1, 0.22))
	particle:SetEndSize(0)
	particle:SetRoll(math.Rand(0, 360))
	particle:SetRollDelta(math.Rand(-4, 4))
	particle:SetLighting(true)

	emitter:Finish() emitter = nil collectgarbage("step", 64)
end
