INC_CLIENT()

ENT.NextEmit = 0
ENT.VScreen = Vector(0, -2, 45)
ENT.ScanPitch = 100
ENT.ScanSound = "npc/turret_wall/turret_loop1.wav"

function ENT:Initialize()
	self.BeamColor = Color(0, 255, 0, 255)

	self.ScanningSound = CreateSound(self, self.ScanSound)
	self.ShootingSound = CreateSound(self, "npc/combine_gunship/gunship_weapon_fire_loop6.wav")

	local size = self.SearchDistance + 32
	local nsize = -size
	self:SetRenderBounds(Vector(nsize, nsize, nsize * 0.25), Vector(size, size, size * 0.25))

	hook.Add("CreateMove", self, self.CreateMove)
	hook.Add("ShouldDrawLocalPlayer", self, self.ShouldDrawLocalPlayer)
	hook.Add("CalcView", self, self.CalcView)
end

function ENT:Think()
	if self:GetObjectOwner():IsValid() and self:GetAmmo() > 0 and self:GetMaterial() == "" then
		self.ScanningSound:PlayEx(0.55, self.ScanPitch + math.sin(CurTime()))
		if self.PlayLoopingShootSound and (self:IsFiring() or self:GetTarget():IsValid()) then
			self.ShootingSound:PlayEx(1, 100 + math.cos(CurTime()))
		else
			self.ShootingSound:Stop()
		end
	else
		self.ScanningSound:Stop()
		self.ShootingSound:Stop()
	end
end

function ENT:OnRemove()
	self.ScanningSound:Stop()
	self.ShootingSound:Stop()
end

function ENT:SetObjectHealth(health)
	self:SetDTFloat(3, health)
end

local TEXT_ALIGN_CENTER = TEXT_ALIGN_CENTER
local draw_SimpleText = draw.SimpleText
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawRect = surface.DrawRect
local cam_Start3D2D = cam.Start3D2D
local cam_End3D2D = cam.End3D2D
local smokegravity = Vector(0, 0, 200)
local aScreen = Angle(0, 270, 60)
function ENT:Draw()
	self:CalculatePoseAngles()
	self:SetPoseParameter("aim_yaw", self.PoseYaw)
	self:SetPoseParameter("aim_pitch", self.PosePitch)

	local owner = self:GetObjectOwner()

	if owner == MySelf and self:GetManualControl() then return end

	local alpha = self:TransAlphaToMe()

	render.SetBlend(alpha)
	self:DrawModel()
	render.SetBlend(1)

	local healthpercent = self:GetObjectHealth() / self:GetMaxObjectHealth()

	if healthpercent <= 0.5 and CurTime() >= self.NextEmit then
		self.NextEmit = CurTime() + 0.05

		local pos = self:DefaultPos()
		local sat = healthpercent * 360

		local emitter = ParticleEmitter(pos)
		emitter:SetNearClip(24, 32)

		local particle = emitter:Add("particles/smokey", pos)
		particle:SetStartAlpha(180)
		particle:SetEndAlpha(0)
		particle:SetStartSize(0)
		particle:SetEndSize(math.Rand(8, 32))
		particle:SetColor(sat, sat, sat)
		particle:SetVelocity(VectorRand():GetNormalized() * math.Rand(8, 64))
		particle:SetGravity(smokegravity)
		particle:SetDieTime(math.Rand(0.8, 1.6))
		particle:SetAirResistance(150)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-4, 4))
		particle:SetCollide(true)
		particle:SetBounce(0.2)

		emitter:Finish() emitter = nil collectgarbage("step", 64)
	end

	if not MySelf:IsValid() or MySelf:Team() ~= TEAM_HUMAN then return end

	local ammo = self:GetAmmo()
	local flash = math.sin(CurTime() * 15) > 0
	local wid, hei = 128, 92
	local x = wid / 2

	cam_Start3D2D(self:LocalToWorld(self.VScreen), self:LocalToWorldAngles(aScreen), 0.075)

		surface_SetDrawColor(0, 0, 0, 160)
		surface_DrawRect(0, 0, wid, hei)

		surface_SetDrawColor(200, 200, 200, 160)
		surface_DrawRect(0, 0, 8, 16)
		surface_DrawRect(wid - 8, 0, 8, 16)
		surface_DrawRect(8, 0, wid - 16, 8)

		surface_DrawRect(0, hei - 16, 8, 16)
		surface_DrawRect(wid - 8, hei - 16, 8, 16)
		surface_DrawRect(8, hei - 8, wid - 16, 8)

		if owner:IsValid() and owner:IsPlayer() then
			draw_SimpleText(owner:ClippedName(), "DefaultFont", x, 10, owner == MySelf and COLOR_LBLUE or COLOR_WHITE, TEXT_ALIGN_CENTER)
		end
		draw_SimpleText(translate.Format("integrity_x", math.ceil(healthpercent * 100)), "DefaultFontBold", x, 25, COLOR_WHITE, TEXT_ALIGN_CENTER)

		if flash and self:GetManualControl() then
			draw_SimpleText(translate.Get("manual_control"), "DefaultFont", x, 40, COLOR_YELLOW, TEXT_ALIGN_CENTER)
		end

		if ammo > 0 then
			draw_SimpleText("["..ammo.." / "..self.MaxAmmo.."]", "DefaultFontBold", x, 55, COLOR_WHITE, TEXT_ALIGN_CENTER)
		elseif flash then
			draw_SimpleText(translate.Get("empty"), "DefaultFontBold", x, 55, COLOR_RED, TEXT_ALIGN_CENTER)
		end

		draw_SimpleText("CH. "..self:GetChannel().." / "..GAMEMODE.MaxChannels["turret"], "DefaultFontSmall", x, 70, COLOR_WHITE, TEXT_ALIGN_CENTER)

	cam_End3D2D()
end

local matBeam = Material("trails/laser")
local matGlow = Material("sprites/glow04_noz")
function ENT:DrawTranslucent()
	if self:GetMaterial() ~= "" then return end

	local lightpos = self:LightPos()

	local ang = self:GetGunAngles()
	local alpha = self:TransAlphaToMe()

	local colBeam = self.BeamColor

	local owner = self:GetObjectOwner()
	local hasowner = owner:IsValid()
	local hasammo = self:GetAmmo() > 0
	local manualcontrol = self:GetManualControl()

	local tr = util.TraceLine({start = lightpos, endpos = lightpos + ang:Forward() * (manualcontrol and 4096 or self.SearchDistance * (hasowner and owner.TurretRangeMul or 1)), mask = MASK_SHOT, filter = self:GetCachedScanFilter()})

	if not hasowner then
		local rate = FrameTime() * 512
		colBeam.r = math.Approach(colBeam.r, 0, rate)
		colBeam.g = math.Approach(colBeam.g, 0, rate)
		colBeam.b = math.Approach(colBeam.b, 255, rate)
	elseif not hasammo or not manualcontrol and self:GetTarget():IsValid() then
		local rate = FrameTime() * 512
		colBeam.r = math.Approach(colBeam.r, 255, rate)
		colBeam.g = math.Approach(colBeam.g, 0, rate)
		colBeam.b = math.Approach(colBeam.b, 0, rate)
	elseif manualcontrol then
		local rate = FrameTime() * 512
		colBeam.r = math.Approach(colBeam.r, 255, rate)
		colBeam.g = math.Approach(colBeam.g, 255, rate)
		colBeam.b = math.Approach(colBeam.b, 0, rate)
	else
		local rate = FrameTime() * 200
		colBeam.r = math.Approach(colBeam.r, 0, rate)
		colBeam.g = math.Approach(colBeam.g, 255, rate)
		colBeam.b = math.Approach(colBeam.b, 0, rate)
	end

	if hasowner and hasammo then
		render.SetMaterial(matBeam)
		if alpha > 0.5 then
			render.DrawBeam(lightpos, tr.HitPos, 1 * self.ModelScale, 0, 1, COLOR_WHITE)
		end
		render.DrawBeam(lightpos, tr.HitPos, 4 * self.ModelScale, 0, 1, colBeam)
		render.SetMaterial(matGlow)
		if alpha > 0.5 then
			render.DrawSprite(lightpos, 4 * self.ModelScale, 4 * self.ModelScale, COLOR_WHITE)
		end
		render.DrawSprite(lightpos, 16 * self.ModelScale, 16 * self.ModelScale, colBeam)
		render.DrawSprite(tr.HitPos, 2, 2, COLOR_WHITE)
		render.DrawSprite(tr.HitPos, 8, 8, colBeam)
	else
		render.SetMaterial(matGlow)
		render.DrawSprite(lightpos, 4 * self.ModelScale, 4 * self.ModelScale, COLOR_WHITE)
		render.DrawSprite(lightpos, 16 * self.ModelScale, 16 * self.ModelScale, colBeam)
	end
end

function ENT:SetTarget(ent)
	if ent:IsValid() then
		self:SetTargetReceived(CurTime())
	else
		self:SetTargetLost(CurTime())
	end

	self:SetDTEntity(0, ent)
end

function ENT:SetObjectOwner(ent)
	self:SetDTEntity(1, ent)
end

function ENT:CreateMove(cmd)
	if self:GetObjectOwner() ~= MySelf then return end

	if not self:GetManualControl() then return end

	local buttons = cmd:GetButtons()

	cmd:ClearMovement()

	if bit.band(buttons, IN_JUMP) ~= 0 then
		buttons = buttons - IN_JUMP
		buttons = buttons + IN_BULLRUSH
	end

	if bit.band(buttons, IN_DUCK) ~= 0 then
		buttons = buttons - IN_DUCK
		buttons = buttons + IN_GRENADE1
	end

	cmd:SetButtons(buttons)
end

function ENT:ShouldDrawLocalPlayer(pl)
	if self:GetObjectOwner() ~= MySelf then return end

	if self:GetManualControl() then
		return true
	end
end

local trace_cam = {mask = MASK_VISIBLE, mins = Vector(-4, -4, -4), maxs = Vector(4, 4, 4)}
function ENT:CalcView(pl, origin, angles, fov, znear, zfar)
	if self:GetObjectOwner() ~= pl or not self:GetManualControl() then return end

	local filter = player.GetAll()
	filter[#filter + 1] = self
	trace_cam.start = self:ShootPos()
	trace_cam.endpos = trace_cam.start
	trace_cam.filter = filter
	local tr = util.TraceHull(trace_cam)

	return {origin = tr.HitPos + tr.HitNormal * 3, angles = angles}
end
