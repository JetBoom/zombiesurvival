EFFECT.DieTime = 0

function EFFECT:Init(data)
	self.StartPos = data:GetStart()
	self.EndPos = data:GetOrigin()
	self.Dir = self.EndPos - self.StartPos
	self.Entity:SetRenderBoundsWS(self.StartPos, self.EndPos)

	self.DieTime = CurTime() + 0.1

	sound.Play("weapons/fx/rics/ric"..math.random(5)..".wav", self.StartPos, 73, math.random(100, 110))
end

function EFFECT:Think()
	return CurTime() < self.DieTime
end

local matBeam = Material("effects/spark")
function EFFECT:Render()
	local fDelta = (self.DieTime - CurTime()) / 0.1
	fDelta = math.Clamp(fDelta, 0, 1)
	local sinWave = math.sin(fDelta * math.pi)

	render.SetMaterial(matBeam)
	render.DrawBeam(self.EndPos - self.Dir * (fDelta - sinWave * 0.3), self.EndPos - self.Dir * (fDelta + sinWave * 0.3), 2 + sinWave * 8, 1, 0, color_white)
end
