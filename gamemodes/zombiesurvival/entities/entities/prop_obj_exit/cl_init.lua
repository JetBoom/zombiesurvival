INC_CLIENT()

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:Initialize()
	self:SetRenderBounds(Vector(-128, -128, -128), Vector(128, 128, 200))

	local ent = ClientsideModel("models/props_doors/door01_dynamic.mdl", RENDERGROUP_TRANSLUCENT)
	if ent:IsValid() then
		ent:SetPos(self:LocalToWorld(Vector(0, 0, 52)))
		ent:SetAngles(self:GetAngles())
		ent:DrawShadow(false)
		ent:SetNoDraw(true)
		ent:SetParent(self)
		ent:Spawn()
		self.Door = ent
	end

	ent = ClientsideModel("models/props_debris/wood_board07a.mdl", RENDERGROUP_TRANSLUCENT)
	if ent:IsValid() then
		ent:SetPos(self:LocalToWorld(Vector(0, 0, 49)))
		ent:SetAngles(self:GetAngles())
		ent:DrawShadow(false)
		ent:SetNoDraw(true)
		ent:SetParent(self)
		ent:Spawn()
		self.LeftBoard = ent
	end

	ent = ClientsideModel("models/props_debris/wood_board07a.mdl", RENDERGROUP_TRANSLUCENT)
	if ent:IsValid() then
		ent:SetPos(self:LocalToWorld(Vector(-52, 0, 49)))
		ent:SetAngles(self:GetAngles())
		ent:DrawShadow(false)
		ent:SetNoDraw(true)
		ent:SetParent(self)
		ent:Spawn()
		self.RightBoard = ent
	end

	ent = ClientsideModel("models/props_debris/wood_board07a.mdl", RENDERGROUP_TRANSLUCENT)
	if ent:IsValid() then
		ent:SetPos(self:LocalToWorld(Vector(-24, 0, 109)))
		ent:SetAngles(self:LocalToWorldAngles(Angle(90, 0, 0)))
		ent:DrawShadow(false)
		ent:SetNoDraw(true)
		ent:SetParent(self)
		ent:Spawn()
		ent:SetModelScaleVector(Vector(1, 1, 0.38))
		self.TopBoard = ent
	end

	ent = ClientsideModel("models/props_debris/wood_board07a.mdl", RENDERGROUP_TRANSLUCENT)
	if ent:IsValid() then
		ent:SetPos(self:LocalToWorld(Vector(-24, 0, 48)))
		ent:SetAngles(self:GetAngles())
		ent:DrawShadow(false)
		ent:SetNoDraw(true)
		ent:SetParent(self)
		ent:Spawn()
		ent:SetModelScaleVector(Vector(6, 0.001, 1))
		self.Rift = ent
	end

	hook.Add("RenderScreenspaceEffects", self, self.RenderScreenspaceEffects)
end

local CModWhiteOut = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 1,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

function ENT:RenderScreenspaceEffects()
	local eyepos = EyePos()
	local nearest = self:NearestPoint(eyepos)
	local power = math.Clamp(1 - eyepos:DistToSqr(nearest) / 45000, 0, 1) ^ 2 * self:GetOpenedPercent()

	if power > 0 then
		local size = 1 + power * 2

		CModWhiteOut["$pp_colour_brightness"] = power * 0.25
		if MySelf:GetObserverMode() == OBS_MODE_NONE then
			CModWhiteOut["$pp_colour_brightness"] = CModWhiteOut["$pp_colour_brightness"] / 2
		end
		DrawBloom(1 - power, power * 4, size, size, 1, 1, 1, 1, 1)
		DrawColorModify(CModWhiteOut)

		if render.SupportsPixelShaders_2_0() then
			local eyevec = EyeVector()
			local pos = self:LocalToWorld(self:OBBCenter()) - eyevec * 16
			local distance = eyepos:Distance(pos)
			local dot = (pos - eyepos):GetNormalized():Dot(eyevec) - distance * 0.0005
			if dot > 0 then
				local srcpos = pos:ToScreen()
				DrawSunbeams(0.8, dot * power, 0.1, srcpos.x / w, srcpos.y / h)
			end
		end
	end
end

ENT.NextEmit = 0
local matWhite = Material("models/debug/debugwhite")
function ENT:DrawTranslucent()
	local curtime = CurTime()
	local rise = self:GetRise() ^ 2
	local normal = self:GetUp()
	local openedpercent = self:GetOpenedPercent()

	local dlight = DynamicLight(self:EntIndex())
	if dlight then
		local size = 100 + openedpercent * 200
		size = size * (1 + math.sin(curtime * math.pi) * 0.075)

		dlight.Pos = self:LocalToWorld(Vector(-24, 0, 40))
		dlight.r = 180
		dlight.g = 200
		dlight.b = 255
		dlight.Brightness = 1 + openedpercent * 4
		dlight.Size = size
		dlight.Decay = size * 2
		dlight.DieTime = curtime + 1
	end

	render.EnableClipping(true)
	render.PushCustomClipPlane(normal, normal:Dot(self:GetPos()))

	cam.Start3D(EyePos() + Vector(0, 0, (1 - rise) * 150), EyeAngles())
		self.Door:SetPos(self:LocalToWorld(Vector(0, 0, 52)))
		self.Door:SetAngles(self:LocalToWorldAngles(Angle(0, openedpercent * 80, 0)))
		self.Door:DrawModel()

		self.LeftBoard:DrawModel()
		self.RightBoard:DrawModel()
		self.TopBoard:DrawModel()
	cam.End3D()

	if openedpercent > 0 then
		--[[normal = normal * -1
		render.PushCustomClipPlane(normal, normal:Dot(self.TopBoard:GetPos()))

		normal = self:GetForward()
		render.PushCustomClipPlane(normal, normal:Dot(self.RightBoard:GetPos()))

		normal = normal * -1
		render.PushCustomClipPlane(normal, normal:Dot(self.LeftBoard:GetPos()))]]

		local brightness = openedpercent ^ 0.4
		render.SuppressEngineLighting(true)
		render.SetColorModulation(brightness, brightness, brightness)
		render.ModelMaterialOverride(matWhite)

		self.Rift:DrawModel()

		render.ModelMaterialOverride()
		render.SetColorModulation(1, 1, 1)
		render.SuppressEngineLighting(false)

		--[[render.PopCustomClipPlane()
		render.PopCustomClipPlane()
		render.PopCustomClipPlane()]]
	end

	render.PopCustomClipPlane()
	render.EnableClipping(false)

	if curtime < self.NextEmit or openedpercent == 0 then return end
	self.NextEmit = curtime + 0.01 + (1 - openedpercent) * 0.15

	local dir = self:GetRight() * 2 + VectorRand()
	dir:Normalize()
	local startpos = self:LocalToWorld(Vector(-24, 0, 48))

	local emitter = ParticleEmitter(startpos)
	emitter:SetNearClip(24, 32)

	for i=1, 4 do
		dir = dir * -1

		local particle = emitter:Add("sprites/glow04_noz", startpos + dir * 180)
		particle:SetDieTime(0.5)
		particle:SetVelocity(dir * -360)
		particle:SetStartAlpha(0)
		particle:SetEndAlpha(255 * openedpercent)
		particle:SetStartSize(math.Rand(2, 5) * openedpercent)
		particle:SetEndSize(0)
		if math.random(2) == 2 then
			particle:SetColor(220, 240, 255)
		end
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-5, 5))
	end

	emitter:Finish() emitter = nil collectgarbage("step", 64)
end
