INC_CLIENT()

ENT.NextTickSound = 0
ENT.LastTickSound = 0

function ENT:Initialize()
	self.DieTime = CurTime() + self.LifeTime
end

function ENT:Think()
	local curtime = CurTime()

	if curtime >= self.NextTickSound then
		local delta = self.DieTime - curtime

		self.NextTickSound = curtime + math.max(0.15, delta * 0.25)
		self.LastTickSound = curtime
		self:EmitSound("npc/roller/mine/rmine_blip1.wav", 75, math.Clamp((1 - delta / self.LifeTime) * 220, 150, 220))
	end
end

local matGlow = Material("sprites/glow04_noz")
function ENT:DrawTranslucent()
	self:DrawModel()

	if math.abs(self.LastTickSound - CurTime()) >= 0.05 then return end

	render.SetMaterial(matGlow)
	render.DrawSprite(self:LocalToWorld(Vector(0, 0, 4)), 12, 12, COLOR_CYAN)
end
