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
	self.Life = self.Life + FrameTime() * 10 -- Effect should dissipate before the next one.
	self.StartPos = self:GetTracerShootPos( self.Position, self.WeaponEnt, self.Attachment )

	return (self.Life < 1)
end

local beammat = Material("trails/laser")
local glowmat = Material("sprites/light_glow02_add")
function EFFECT:Render()
	local texcoord = math.Rand( 0, 1 )

	local norm = (self.StartPos - self.EndPos) * self.Life
	local nlen = norm:Length()
	local inv = 1 - self.Life

	render.SetMaterial(beammat)
	for i = 0, 5 do
		render.DrawBeam(self.StartPos, self.EndPos, (12 + i * 1) * inv, texcoord, texcoord + nlen / 128, Color(110, 185, 230, 180 * inv))
	end

	render.SetMaterial(glowmat)
	render.DrawSprite(self.StartPos, 15 * inv, 15 * inv, Color(100, 185, 232))
	render.DrawSprite(self.EndPos, 40 * inv, 40 * inv, Color(100, 185, 232))
end
