function EFFECT:Init( data )
	self.Position = data:GetStart()
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()

	self.StartPos = self:GetTracerShootPos( self.Position, self.WeaponEnt, self.Attachment )
	self.EndPos = data:GetOrigin()

	self.Alpha = 255
	self.Life = 0

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
	for i = 1, 2 do
		render.DrawBeam(self.StartPos + (VectorRand() * 2), self.EndPos + (VectorRand() * 3), 4, texcoord, texcoord + self.Length / 128, Color( 50, 255, 135, self.Alpha ))
	end

	render.SetMaterial(glowmat)
	render.DrawSprite(self.StartPos, 20, 20, Color(50, 245, 235, self.Alpha))
	render.DrawSprite(self.EndPos, 15, 15, Color(50, 245, 235, self.Alpha))
end
