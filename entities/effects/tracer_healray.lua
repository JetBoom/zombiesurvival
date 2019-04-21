function EFFECT:Init( data )
	self.Position = data:GetStart()
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()

	self.StartPos = self:GetTracerShootPos( self.Position, self.WeaponEnt, self.Attachment )
	self.EndPos = data:GetOrigin()

	self.Life = 0

	self:SetRenderBoundsWS( self.StartPos, self.EndPos )
end

function EFFECT:Think( )
	self.Life = self.Life + FrameTime() * 3 -- Effect should dissipate before the next one.
	self.StartPos = self:GetTracerShootPos( self.Position, self.WeaponEnt, self.Attachment )

	return (self.Life < 1)
end

local beammat = Material("trails/physbeam")
local glowmat = Material("sprites/light_glow02_add")
function EFFECT:Render()
	local texcoord = math.Rand(0, 1)

	local norm = (self.StartPos - self.EndPos) * self.Life
	local nlen = norm:Length()

	local alpha = (1 - self.Life) * 0.2

	render.SetMaterial(beammat)

	local vec = Vector(math.cos(CurTime() * 0.5) * 8, math.sin(CurTime() * 0.5) * 10, 0)
	local cubicone = CosineInterpolation(self.StartPos - vec * 1, self.EndPos, 0.2)
	local cubictwo = CosineInterpolation(cubicone, self.EndPos - vec * 1, 0.4)

	local cubiconenorm = (cubicone - cubictwo)

	local emitter = ParticleEmitter(self.StartPos)
	emitter:SetNearClip(24, 32)

	for i=1, 2 do
		local type = math.random(2) == 1

		local particle = emitter:Add("effects/blueflare1", (type and cubicone or cubictwo) + norm * math.Rand(-1, 0))
		particle:SetDieTime(0.1)
		particle:SetColor(150,255,130)
		particle:SetStartAlpha(alpha * 255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(16)
		particle:SetEndSize(0)
		particle:SetVelocity((type and cubiconenorm or norm) * -12 + VectorRand() * 6)
		particle:SetGravity((type and cubiconenorm or norm) * (type and 30 or 21))
	end

	emitter:Finish() emitter = nil collectgarbage("step", 64)

	for i = 0, 4 do
		render.DrawBeam(self.StartPos, cubicone, 6, texcoord, texcoord + nlen / 128, Color(150, 255, 130, 255 * alpha))
		render.DrawBeam(cubicone, cubictwo, 6, texcoord, texcoord + nlen / 128, Color(150, 255, 130, 255 * alpha))
		render.DrawBeam(cubictwo, self.EndPos, 6, texcoord, texcoord + nlen / 128, Color(150, 255, 130, 255 * alpha))
	end
	render.DrawBeam(self.StartPos, cubicone, 27, texcoord, texcoord + nlen / 128, Color(190, 255, 190, 170 * alpha))
	render.DrawBeam(cubicone, cubictwo, 27, texcoord, texcoord + nlen / 128, Color(190, 255, 190, 170 * alpha))
	render.DrawBeam(cubictwo, self.EndPos, 27, texcoord, texcoord + nlen / 128, Color(190, 255, 190, 170 * alpha))

	render.SetMaterial(glowmat)
	render.DrawSprite(self.StartPos, 30, 30, Color(190, 255, 190, 148 * alpha))
	render.DrawSprite(self.EndPos, 30, 30, Color(190, 255, 190, 148 * alpha))
end
