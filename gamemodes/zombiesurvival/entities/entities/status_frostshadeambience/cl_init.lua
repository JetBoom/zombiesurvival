INC_CLIENT()

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.NextEmit = 0

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 90))

	self.AmbientSound = CreateSound(self, "ambient/levels/canals/windmill_wind_loop1.wav")
	self.AmbientSound:PlayEx(0.6, 100)

	self:GetOwner().status_frostshadeambience = self
end

function ENT:OnRemove()
	self.AmbientSound:Stop()
end

local matGlow = Material("sprites/glow04_noz")
local colGlow = Color(255, 255, 255, 150)
function ENT:DrawTranslucent()
	local owner = self:GetOwner()
	if owner.SpawnProtection then return end
	if owner:IsValid() and (owner ~= MySelf or owner:ShouldDrawLocalPlayer()) then
		local pos = owner:LocalToWorld(owner:OBBCenter())
		render.SetMaterial(matGlow)
		render.DrawSprite(pos, math.Rand(64, 72), math.Rand(64, 72), colGlow)

		if self.NextEmit <= CurTime() then
			self.NextEmit = CurTime() + 0.25

			local emitter = ParticleEmitter(pos)
			emitter:SetNearClip(32, 48)

			local particle = emitter:Add("particle/smokestack", pos)
			particle:SetVelocity(owner:GetVelocity() * 0.8)
			particle:SetDieTime(math.Rand(1, 1.35))
			particle:SetStartAlpha(130)
			particle:SetEndAlpha(0)
			particle:SetStartSize(10)
			particle:SetEndSize(math.Rand(25,50))
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-5, 5))
			particle:SetGravity(Vector(0, 0, 90))
			particle:SetCollide(true)
			particle:SetBounce(0.45)
			particle:SetAirResistance(12)
			particle:SetColor(255, 255, 255)

			emitter:Finish() emitter = nil collectgarbage("step", 64)
		end
	end
end
