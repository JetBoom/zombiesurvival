INC_CLIENT()

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.GlowMax = 48
ENT.GlowMin = 26

ENT.GlowSize = ENT.GlowMin
ENT.NextEmit = 0

function ENT:Initialize()
	self:DrawShadow(false)

	self.AmbientSound = CreateSound(self, "^thrusters/hover02.wav")
end

function ENT:Think()
	local owner = self:GetOwner()
	if owner:IsValid() then
		self.AmbientSound:PlayEx(0.7, 20 + 15 * math.min(1, owner:GetVelocity():Length() / 200))
	end
end

function ENT:OnRemove()
	self.AmbientSound:Stop()
end

local matGlow = Material("sprites/light_glow02_add")
local matWhite = Material("models/debug/debugwhite")
function ENT:DrawTranslucent()
	local pl = self:GetOwner()
	if not pl:IsValid() or pl == MySelf and not pl:ShouldDrawLocalPlayer() then return end

	local pos = pl:GetPos()

	local spawnprotection = pl.SpawnProtection

	render.ModelMaterialOverride(matWhite)
	render.SuppressEngineLighting(true)
	if spawnprotection then
		render.SetBlend(0.02 + (CurTime() + pl:EntIndex() * 0.2) % 0.05)
		render.SetColorModulation(0, 0.3, 0)
	end
	self:DrawModel()
	if spawnprotection then
		render.SetColorModulation(1, 1, 1)
		render.SetBlend(1)
	end
	render.SuppressEngineLighting(false)
	render.ModelMaterialOverride(nil)

	local col = spawnprotection and Color(0, 0.3 * 255, 0) or Color(255, 255, 255)

	render.SetMaterial(matGlow)
	render.DrawSprite(pos, 64, 64, col)

	if CurTime() >= self.NextEmit then
		self.NextEmit = CurTime() + 0.075

		local emitter = ParticleEmitter(pos)
		emitter:SetNearClip(12, 16)

		local base_ang = (self:GetVelocity() * -1):Angle()
		local ang = Angle()
		for i=1, 6 do
			ang:Set(base_ang)
			ang:RotateAroundAxis(ang:Right(), math.Rand(-30, 30))
			ang:RotateAroundAxis(ang:Up(), math.Rand(-30, 30))

			local particle = emitter:Add("sprites/glow04_noz", pos)
			particle:SetDieTime(2)
			particle:SetVelocity(ang:Forward() * math.Rand(32, 64))
			particle:SetAirResistance(24)
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)
			particle:SetStartSize(math.Rand(2, 4))
			particle:SetEndSize(0)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-3, 3))
			particle:SetColor(col.r,col.g,col.b)
		end

		emitter:Finish() emitter = nil collectgarbage("step", 64)
	end

	local dlight = DynamicLight(self:EntIndex())
	if dlight then
		dlight.Pos = pos
		dlight.r = 255
		dlight.g = 255
		dlight.b = 255
		dlight.Brightness = 1
		dlight.Size = 150
		dlight.Decay = 300
		dlight.DieTime = CurTime() + 1
	end
end
