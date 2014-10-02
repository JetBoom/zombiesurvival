include("shared.lua")

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.NextEmit = 0
ENT.GlowSize = 32

function ENT:Initialize()
	self:DrawShadow(false)
end

local matGlow = Material("sprites/glow04_noz")
local matRing = Material("Effects/splashwake3")
function ENT:DrawTranslucent()
	local pl = self:GetOwner()
	if not pl:IsValid() then return end

	local wep = pl:GetActiveWeapon()
	local attackdown = wep:IsValid() and wep.GetAttackDown and wep:GetAttackDown()

	self.GlowSize = math.Approach(self.GlowSize, attackdown and 28 or 16, FrameTime() * 50)
	local basesize = self.GlowSize

	local pos = pl:GetPos()
	local time = CurTime()

	local ringsize = basesize * (0.75 + math.max(0, math.sin(time * 2)) ^ 0.75 * 0.6 + math.sin(time * 4) * 0.05)
	render.SetMaterial(matRing)
	render.DrawSprite(pos, ringsize, ringsize, color_white)

	render.SetMaterial(matGlow)
	render.DrawSprite(pos, basesize, basesize, color_white)
	render.DrawSprite(pos + Vector(math.sin(time * 3) * 4, 0, 0), basesize, basesize, color_white)
	render.DrawSprite(pos + Vector(0, math.cos(time * 3.5) * 4, 0), basesize, basesize, color_white)
	render.DrawSprite(pos + Vector(0, 0, math.sin(time * 4) * 4), basesize, basesize, color_white)

	if time >= self.NextEmit then
		self.NextEmit = time + math.Rand(0.05, 0.25)

		local emitter = ParticleEmitter(pos)
		emitter:SetNearClip(16, 24)

		local particle = emitter:Add("sprites/glow04_noz", pos)
		particle:SetVelocity(VectorRand():GetNormalized() * math.Rand(-64, 64))
		particle:SetDieTime(math.Rand(2, 4))
		particle:SetStartSize(1)
		particle:SetEndSize(0)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(255)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-4, 4))
		particle:SetGravity(Vector(0, 0, -128))
		particle:SetAirResistance(32)
		particle:SetCollide(true)
		particle:SetBounce(0.75)

		emitter:Finish()
	end

	local dlight = DynamicLight(self:EntIndex())
	if dlight then
		dlight.Pos = pos
		dlight.r = 255
		dlight.g = 255
		dlight.b = 255
		dlight.Brightness = 1
		dlight.Size = 150
		dlight.Decay = 300
		dlight.DieTime = CurTime() + 1
	end
end
