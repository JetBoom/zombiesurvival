INC_CLIENT()

ENT.NextEmit = 0

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetCustomCollisionCheck(true)
	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)

	self.AmbientSound = CreateSound(self, "ambient/energy/force_field_loop1.wav")
end

function ENT:Think()
	self.AmbientSound:PlayEx(0.2, math.max(60, 230 - EyePos():Distance(self:GetPos()) * 0.12))
end

function ENT:OnRemove()
	self.AmbientSound:Stop()
end

local matGlow = Material("sprites/light_glow02_add")
local matWhite = Material("models/debug/debugwhite")
function ENT:Draw()
	render.ModelMaterialOverride(matWhite)
	render.SetColorModulation(0.8, 0.8, 0.8)
	render.SuppressEngineLighting(true)
	self:DrawModel()
	render.SuppressEngineLighting(false)
	render.ModelMaterialOverride(nil)

	local pos = self:GetPos()

	render.SetMaterial(matGlow)
	render.DrawSprite(pos, 34, 34)

	render.SetColorModulation(1, 1, 1)

	if CurTime() < self.NextEmit then return end
	self.NextEmit = CurTime() + 0.075

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(12, 16)

	local base_ang = (self:GetVelocity() * -1):Angle()
	local ang = Angle()
	for i=1, 2 do
		ang:Set(base_ang)
		ang:RotateAroundAxis(ang:Right(), math.Rand(-30, 30))
		ang:RotateAroundAxis(ang:Up(), math.Rand(-30, 30))

		local particle = emitter:Add("sprites/glow04_noz", pos)
		particle:SetDieTime(2)
		particle:SetVelocity(ang:Forward() * math.Rand(12, 14))
		particle:SetColor(210, 210, 210)
		particle:SetAirResistance(24)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.Rand(2, 4))
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-3, 3))
	end

	emitter:Finish() emitter = nil collectgarbage("step", 64)
end
