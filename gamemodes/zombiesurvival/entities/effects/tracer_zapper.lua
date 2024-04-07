function EFFECT:Init( data )
	local pos = data:GetStart()

	self.StartPos = pos
	self.EndPos = data:GetOrigin()

	self.Alpha = 255
	self.Life = 0

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(24, 32)

	for i=1, 9 do
		local particle = emitter:Add("effects/blueflare1", pos)
		particle:SetDieTime(0.8)
		particle:SetColor(150,190,255)
		particle:SetStartAlpha(200)
		particle:SetEndAlpha(0)
		particle:SetStartSize(4)
		particle:SetEndSize(0)
		particle:SetVelocity(VectorRand():GetNormal() * 60)
	end

	emitter:Finish() emitter = nil collectgarbage("step", 64)

	self:SetRenderBoundsWS( self.StartPos, self.EndPos )
end

function EFFECT:Think( )
	self.Life = self.Life + FrameTime() * 6
	self.Alpha = 255 * ( 1 - self.Life )
	return ( self.Life < 1 )
end

local beam1mat = Material("trails/electric")
local glowmat = Material("sprites/light_glow02_add")

function EFFECT:Render()
	if ( self.Alpha < 1 ) then return end

	local texcoord = math.Rand( 0, 1 )
	local norm = (self.StartPos - self.EndPos) * self.Life
	self.Length = norm:Length()

	render.SetMaterial( beam1mat )
	for i = 1, 3 do
		render.DrawBeam(self.StartPos, self.EndPos + (VectorRand() * 6), 12, texcoord, texcoord + self.Length / 128, Color( 255, 255, 255, self.Alpha ))
	end

	render.SetMaterial(glowmat)
	render.DrawSprite(self.StartPos, 130, 130, Color(150, 215, 255, self.Alpha))
	render.DrawSprite(self.EndPos, 50, 50, Color(170, 215, 255, self.Alpha))
end
