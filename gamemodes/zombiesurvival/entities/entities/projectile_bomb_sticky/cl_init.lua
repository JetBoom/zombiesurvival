INC_CLIENT()

ENT.NextEmit = 0

function ENT:Initialize()
	self:SetModelScale(0.2, 0)
	self:SetMaterial("models/props_combine/masterinterface01c")
	self:DrawShadow(false)
end

local matGlow = Material("sprites/glow04_noz")
function ENT:Draw()
	local alt = self:GetDTBool(0)
	local charge = self:GetCharge()
	local c = Color(alt and 100 or 255 * charge, alt and 205 or 0 * charge, alt and 205 or 0 * charge)
	self:SetColor(c)
	self:DrawModel()

	local pos = self:GetPos()
	local size = math.abs((self:GetCharge() == 1 and 1 or 0) * 34 * math.sin(CurTime() * 12))

	render.SetMaterial(matGlow)
	render.DrawSprite(pos, size, size, c)
end
