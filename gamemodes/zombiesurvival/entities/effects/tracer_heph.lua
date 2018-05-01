function EFFECT:Init( data )
	self.Position = data:GetStart()
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()

	self.StartPos = self:GetTracerShootPos(self.Position, self.WeaponEnt, self.Attachment)
	self.EndPos = data:GetOrigin()

	self.Life = 0

	self:SetRenderBoundsWS( self.StartPos, self.EndPos )
end

function EFFECT:Think( )
	self.Life = self.Life + FrameTime() * 5 -- Effect should dissipate before the next one.

	return self.Life < 1
end

local beammat = Material("trails/laser")
local beam1mat = Material("trails/electric")
local glowmat = Material("sprites/light_glow02_add")
function EFFECT:Render()
	local texcoord = math.Rand(0, 1)

	local norm = (self.StartPos - self.EndPos) * self.Life
	local nlen = norm:Length()

	local alpha = 1 - self.Life

	render.SetMaterial(beammat)

	for i = 1, 5 do
		render.DrawBeam(self.StartPos, self.EndPos, 4, texcoord, texcoord + nlen / 128, Color(255, 160, 50, 255 * alpha))
	end
	render.DrawBeam(self.StartPos, self.EndPos, 14, texcoord, texcoord + nlen / 128, Color(255, 160, 50, 170 * alpha))

	render.SetMaterial(beam1mat)
	for i = 1, 3 do
		render.DrawBeam(self.StartPos + (VectorRand() * 6), self.EndPos + (VectorRand() * 6), 12, texcoord, texcoord + nlen / 128, Color(255, 160, 50, 170 * alpha))
	end

	render.SetMaterial(glowmat)
	render.DrawSprite(self.StartPos, 30, 30, Color(245, 140, 70, 158 * alpha))
	render.DrawSprite(self.EndPos, 30, 30, Color(245, 140, 70, 158 * alpha))
end
