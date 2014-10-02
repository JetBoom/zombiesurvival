include("shared.lua")

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

local function DrawSigilHints()
	for _, ent in pairs(ents.FindByClass("prop_obj_sigil")) do
		ent:DrawWorldHint()
	end
end

function ENT:Initialize()
	self:SetRenderBounds(Vector(-128, -128, -128), Vector(128, 128, 200))

	self:SetModelScaleVector(Vector(1, 1, 1) * self.ModelScale)

	self.AmbientSound = CreateSound(self, "ambient/atmosphere/tunnel1.wav")

	hook.Add("PostDrawTranslucentRenderables", "DrawSigilHints", DrawSigilHints)
end

function ENT:Think()
	if EyePos():Distance(self:GetPos()) <= 700 then
		self.AmbientSound:PlayEx(0.33, 75 + (self:GetSigilHealth() / self:GetSigilMaxHealth()) * 25)
	else
		self.AmbientSound:Stop()
	end
end

function ENT:OnRemove()
	self.AmbientSound:Stop()
end

function ENT:DrawWorldHint()
	DrawWorldHint(math.ceil(self:GetSigilHealth()), self:GetPos(), nil, 0.75)
end

ENT.NextEmit = 0
ENT.Rotation = math.random(360)

local matWhite = Material("models/debug/debugwhite")
local matGlow = Material("sprites/light_glow02_add")
local cDraw = Color(255, 255, 255)
local cDrawWhite = Color(255, 255, 255)
function ENT:DrawTranslucent()
	self:RemoveAllDecals()

	local curtime = CurTime()
	local sat = math.abs(math.sin(curtime))
	local colsat = sat * 0.125
	local eyepos = EyePos()
	local eyeangles = EyeAngles()
	local forwardoffset = self:GetForward() * 16
	local rightoffset = self:GetRight() * 16
	local healthperc = self:GetSigilHealth() / self:GetSigilMaxHealth()
	local r, g, b = 0.15 + colsat, 0.4 + colsat, 1
	local radius = 180 + math.cos(sat) * 40
	local whiteradius = 122 + math.sin(sat) * 32
	local up = self:GetUp()
	local spritepos = self:GetPos() + up
	local spritepos2 = self:WorldSpaceCenter()

	local dlight = DynamicLight(self:EntIndex())
	if dlight then
		dlight.Pos = self:GetPos()
		dlight.r = r * 255
		dlight.g = g * 255
		dlight.b = b * 255
		dlight.Brightness = (2 + sat) * healthperc
		dlight.Size = 100 + sat * 50
		dlight.Decay = 400 + sat * 200
		dlight.DieTime = curtime + 1
	end

	r = r * healthperc
	g = g * healthperc
	b = b * healthperc
	render.SuppressEngineLighting(true)
	render.SetColorModulation(r ^ 0.5, g ^ 0.5, b ^ 0.5)
	self:DrawModel()

	render.SetColorModulation(r, g, b)
	
	render.ModelMaterialOverride(matWhite)
	render.SetBlend(0.1 * healthperc)

	self:DrawModel()

	--[[r = r * healthperc
	g = g * healthperc
	b = b * healthperc]]
	render.SetColorModulation(r, g, b)

	self:SetModelScaleVector(Vector(0.1, 0.1, 0.9 * math.max(0.02, healthperc)) * self.ModelScale)
	render.SetBlend(1)
	cam.Start3D(eyepos + forwardoffset + rightoffset, eyeangles)
	self:DrawModel()
	cam.End3D()
	cam.Start3D(eyepos + forwardoffset - rightoffset, eyeangles)
	self:DrawModel()
	cam.End3D()
	cam.Start3D(eyepos - forwardoffset + rightoffset, eyeangles)
	self:DrawModel()
	cam.End3D()
	cam.Start3D(eyepos - forwardoffset - rightoffset, eyeangles)
	self:DrawModel()
	cam.End3D()
	self:SetModelScaleVector(Vector(1, 1, 1) * self.ModelScale)

	render.SetBlend(1)
	render.ModelMaterialOverride()
	render.SuppressEngineLighting(false)
	render.SetColorModulation(1, 1, 1)

	self.Rotation = self.Rotation + FrameTime() * 5
	if self.Rotation >= 360 then
		self.Rotation = self.Rotation - 360
	end

	cDraw.r = r * 255
	cDraw.g = g * 255
	cDraw.b = b * 255
	cDrawWhite.r = healthperc * 255
	cDrawWhite.g = cDrawWhite.r
	cDrawWhite.b = cDrawWhite.r

	render.SetMaterial(matGlow)
	render.DrawQuadEasy(spritepos, up, whiteradius, whiteradius, cDrawWhite, self.Rotation)
	render.DrawQuadEasy(spritepos, up * -1, whiteradius, whiteradius, cDrawWhite, self.Rotation)
	render.DrawQuadEasy(spritepos, up, radius, radius, cDraw, self.Rotation)
	render.DrawQuadEasy(spritepos, up * -1, radius, radius, cDraw, self.Rotation)
	--render.DrawSprite(spritepos2, whiteradius, whiteradius * 2, cDrawWhite)
	render.DrawSprite(spritepos2, radius, radius * 2, cDraw)

	if curtime < self.NextEmit then return end
	self.NextEmit = curtime + 0.05

	local offset = VectorRand()
	offset.z = 0
	offset:Normalize()
	offset = offset * math.Rand(-32, 32)
	offset.z = 1
	local pos = self:LocalToWorld(offset)

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(24, 32)

	local particle = emitter:Add("sprites/glow04_noz", pos)
	particle:SetDieTime(math.Rand(1.5, 4))
	particle:SetVelocity(Vector(0, 0, math.Rand(32, 64)))
	particle:SetStartAlpha(0)
	particle:SetEndAlpha(255)
	particle:SetStartSize(math.Rand(2, 4))
	particle:SetEndSize(0)
	particle:SetRoll(math.Rand(0, 360))
	particle:SetRollDelta(math.Rand(-1, 1))
	particle:SetColor(r * 255, g * 255, b * 255)
	particle:SetCollide(true)

	emitter:Finish()
end
