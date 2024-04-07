INC_CLIENT()

ENT.NextEmit = 0

local matTrail = Material("cable/rope")
local matGlow = Material("sprites/light_glow02_add")
function ENT:Draw()
	if self:GetParent() ~= NULL then
		self:SetLocalPos(Vector(0, 0, -30))
	end
	self:DrawModel()
	if self:GetParent() ~= NULL then
		self:SetLocalPos(Vector(0, 0, 0))
	end

	local pos = self:GetPos()
	--pos.z = pos.z

	render.SetMaterial(matTrail)
	render.DrawBeam(pos, self:GetPuller():WorldSpaceCenter(), 3, 4, 0, Color(75, 0, 0, 255))

	render.SetMaterial(matGlow)
	render.DrawSprite(pos, 35, 35, Color(125, 10, 10, 120))

	if CurTime() >= self.NextEmit and self:GetVelocity():LengthSqr() >= 256 then
		self.NextEmit = CurTime() + 0.06

		local emitter = ParticleEmitter(self:GetPos())
		emitter:SetNearClip(16, 24)

		for i = 1, 3 do
			local particle = emitter:Add("!sprite_bloodspray"..math.random(8), self:GetPos())
			particle:SetVelocity(VectorRand():GetNormalized() * math.Rand(12, 22))
			particle:SetDieTime(2)
			particle:SetStartAlpha(230)
			particle:SetEndAlpha(0)
			particle:SetStartSize(5)
			particle:SetEndSize(0)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-25, 25))
			particle:SetGravity(Vector(0, 0, -100))
			particle:SetColor(150, 0, 0)
		end

		emitter:Finish() emitter = nil collectgarbage("step", 64)
	end
end

function ENT:Initialize()
	self.AmbientSound = CreateSound(self, "npc/strider/strider_skewer1.wav")
	self.Created = CurTime()
end

function ENT:Think()
	self.AmbientSound:PlayEx(1, 50 + math.min(1, CurTime() - self.Created) * 30)

	self:NextThink(CurTime())
	return true
end
