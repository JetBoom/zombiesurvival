include("shared.lua")

ENT.NextEmit = 0

function ENT:Initialize()
	self:SetModelScale(2.5, 0)
	self:SetMaterial("models/flesh")
end

function ENT:Draw()
	self:DrawModel()

	if CurTime() >= self.NextEmit and self:GetVelocity():Length() >= 16 then
		self.NextEmit = CurTime() + 0.05

		local emitter = ParticleEmitter(self:GetPos())
		emitter:SetNearClip(16, 24)

		local particle = emitter:Add("noxctf/sprite_bloodspray"..math.random(8), self:GetPos())
		particle:SetVelocity(VectorRand():GetNormalized() * math.Rand(8, 16))
		particle:SetDieTime(1)
		particle:SetStartAlpha(230)
		particle:SetEndAlpha(230)
		particle:SetStartSize(10)
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-25, 25))
		particle:SetColor(255, 0, 0)
		particle:SetLighting(true)

		emitter:Finish()
	end
end
