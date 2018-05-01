INC_CLIENT()

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.NextEmit = 0

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 90))

	self.AmbientSound = CreateSound(self, "npc/zombie_poison/pz_breathe_loop1.wav")
	self.AmbientSound:PlayEx(0.67, 100)
end

function ENT:OnRemove()
	self.AmbientSound:Stop()
end

function ENT:Think()
	self.AmbientSound:PlayEx(0.67, 100 + RealTime() % 1)
end

local matGlow = Material("sprites/glow04_noz")
local colGlow = Color(0, 255, 0, 255)
function ENT:DrawTranslucent()
	local owner = self:GetOwner()
	if owner:IsValid() and (owner ~= MySelf or owner:ShouldDrawLocalPlayer()) then
		local pos = owner:LocalToWorld(owner:OBBCenter())
		render.SetMaterial(matGlow)
		render.DrawSprite(pos, math.Rand(64, 72), math.Rand(64, 72), colGlow)

		if self.NextEmit <= CurTime() then
			self.NextEmit = CurTime() + 0.15

			local emitter = ParticleEmitter(pos)
			emitter:SetNearClip(32, 48)

			local particle = emitter:Add("particle/smokestack", pos)
			particle:SetVelocity(owner:GetVelocity() * 0.8)
			particle:SetDieTime(math.Rand(1, 1.35))
			particle:SetStartAlpha(220)
			particle:SetEndAlpha(0)
			particle:SetStartSize(math.Rand(30, 44))
			particle:SetEndSize(20)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-3, 3))
			particle:SetGravity(Vector(0, 0, 125))
			particle:SetCollide(true)
			particle:SetBounce(0.45)
			particle:SetAirResistance(12)
			particle:SetColor(0, 200, 0)

			emitter:Finish() emitter = nil collectgarbage("step", 64)
		end
	end
end
