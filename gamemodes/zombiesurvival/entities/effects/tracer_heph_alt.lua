EFFECT.DieTime = 0

function EFFECT:Init(data)
	self.StartPos = data:GetStart()
	self.EndPos = data:GetOrigin()
	self.Dir = self.EndPos - self.StartPos
	self.Entity:SetRenderBoundsWS(self.StartPos, self.EndPos)

	self.DieTime = CurTime() + 0.5

	sound.Play("weapons/fx/rics/ric"..math.random(5)..".wav", self.StartPos, 73, math.random(140, 150))
end

function EFFECT:Think()
	return CurTime() < self.DieTime
end

local beammat = Material("trails/laser")
function EFFECT:Render()
	local texcoord = math.Rand(0, 1)
	local alpha = self.DieTime - CurTime()
	local norm = (self.StartPos - self.EndPos) * alpha
	local nlen = norm:Length()

	render.SetMaterial(beammat)

	for i = 1, 5 do
		render.DrawBeam(self.StartPos, self.EndPos, 4, texcoord, texcoord + nlen / 128, Color(115, 210, 50, 255 * alpha))
	end
	render.DrawBeam(self.StartPos, self.EndPos, 14, texcoord, texcoord + nlen / 128, Color(115, 210, 50, 170 * alpha))
end
