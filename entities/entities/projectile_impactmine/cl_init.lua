INC_CLIENT()

ENT.RenderGroup = RENDERGROUP_BOTH
ENT.LastPos = Vector(0, 0, 0)
ENT.NextTrace = 0

function ENT:Initialize()
	self:SetRenderBounds(Vector(-self.Range, -self.Range, -self.Range), Vector(self.Range, self.Range, self.Range))
end

function ENT:Draw()
	self:DrawModel()
end

local matBeam = Material("effects/laser1")
local matGlow = Material("sprites/glow04_noz")
local colBeam = Color(80, 80, 255, 255)
local colAlt = Color(80, 255, 120, 255)
local COLOR_WHITE = color_white
local trace = {mask = MASK_SHOT}
function ENT:DrawTranslucent()
	if not self:IsActive() then return end

	local alt = self:GetDTBool(0)
	local beamcol = alt and colAlt or colBeam

	local pos = self:GetStartPos()
	if CurTime() >= self.NextTrace then
		self.NextTrace = CurTime() + 0.15

		local forward = self:GetForward()
		trace.start = pos
		trace.endpos = pos + forward * (alt and 64 or self.Range)
		trace.filter = self:GetCachedScanFilter()

		self.LastPos = util.TraceLine(trace).HitPos
	end

	local hitpos = self.LastPos
	render.SetMaterial(matBeam)
	render.DrawBeam(pos, hitpos, 0.33, 0, 1, COLOR_WHITE)
	render.DrawBeam(pos, hitpos, 1.3, 0, 1, beamcol)
	render.SetMaterial(matGlow)
	render.DrawSprite(pos, 2, 2, COLOR_WHITE)
	render.DrawSprite(pos, 8, 8, beamcol)
	render.DrawSprite(hitpos, 1, 1, COLOR_WHITE)
	render.DrawSprite(hitpos, 4, 4, beamcol)
end
