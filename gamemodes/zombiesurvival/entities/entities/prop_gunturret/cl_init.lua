include("shared.lua")

ENT.NextEmit = 0

function ENT:Initialize()
	self.BeamColor = Color(0, 255, 0, 255)

	self.ScanningSound = CreateSound(self, "npc/turret_wall/turret_loop1.wav")
	self.ShootingSound = CreateSound(self, "npc/combine_gunship/gunship_weapon_fire_loop6.wav")

	local size = self.SearchDistance + 32
	local nsize = -size
	self:SetRenderBounds(Vector(nsize, nsize, nsize * 0.25), Vector(size, size, size * 0.25))
end

function ENT:Think()
	if self:GetObjectOwner():IsValid() and self:GetAmmo() > 0 and self:GetMaterial() == "" then
		self.ScanningSound:PlayEx(0.55, 100 + math.sin(CurTime()))
		if self:IsFiring() or self:GetTarget():IsValid() then
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

local smokegravity = Vector(0, 0, 200)
local aScreen = Angle(0, 270, 60)
local vScreen = Vector(0, -2, 45)
function ENT:Draw()
	self:CalculatePoseAngles()
	self:SetPoseParameter("aim_yaw", self.PoseYaw)
	self:SetPoseParameter("aim_pitch", self.PosePitch)

	self:DrawModel()

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

		emitter:Finish()
	end

	local owner = self:GetObjectOwner()
	local ammo = self:GetAmmo()
	local flash = math.sin(CurTime() * 15) > 0

	local wid, hei = 128, 92
	cam.Start3D2D(self:LocalToWorld(vScreen), self:LocalToWorldAngles(aScreen), 0.075)

		surface.SetDrawColor(0, 0, 0, 160)
		surface.DrawRect(0, 0, wid, hei)

		surface.SetDrawColor(200, 200, 200, 160)
		surface.DrawRect(0, 0, 8, 16)
		surface.DrawRect(wid - 8, 0, 8, 16)
		surface.DrawRect(8, 0, wid - 16, 8)

		surface.DrawRect(0, hei - 16, 8, 16)
		surface.DrawRect(wid - 8, hei - 16, 8, 16)
		surface.DrawRect(8, hei - 8, wid - 16, 8)

		if owner:IsValid() and owner:IsPlayer() then
			draw.SimpleText(owner:ClippedName(), "DefaultFont", wid * 0.5, 10, owner == MySelf and COLOR_BLUE or COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
		end
		draw.SimpleText(translate.Format("integrity_x", math.ceil(healthpercent * 100)), "DefaultFontBold", wid * 0.5, hei * 0.5, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		if flash and self:GetManualControl() then
			draw.SimpleText(translate.Get("manual_control"), "DefaultFont", wid * 0.5, hei * 0.325, COLOR_YELLOW, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
		if ammo > 0 then
			draw.SimpleText("["..ammo.." / "..self.MaxAmmo.."]", "DefaultFontBold", wid * 0.5, hei - 10, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		elseif flash then
			draw.SimpleText(translate.Get("empty"), "DefaultFontBold", wid * 0.5, hei - 10, COLOR_RED, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end

	cam.End3D2D()
end

local matBeam = Material("effects/laser1")
local matGlow = Material("sprites/glow04_noz")
function ENT:DrawTranslucent()
	if self:GetMaterial() ~= "" then return end

	local lightpos = self:LightPos()

	local ang = self:GetGunAngles()

	local colBeam = self.BeamColor

	local hasowner = self:GetObjectOwner():IsValid()
	local hasammo = self:GetAmmo() > 0
	local manualcontrol = self:GetManualControl()

	local tr = util.TraceLine({start = lightpos, endpos = lightpos + ang:Forward() * (manualcontrol and 4096 or self.SearchDistance), mask = MASK_SHOT, filter = self:GetCachedScanFilter()})

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
		render.DrawBeam(lightpos, tr.HitPos, 1, 0, 1, COLOR_WHITE)
		render.DrawBeam(lightpos, tr.HitPos, 4, 0, 1, colBeam)
		render.SetMaterial(matGlow)
		render.DrawSprite(lightpos, 4, 4, COLOR_WHITE)
		render.DrawSprite(lightpos, 16, 16, colBeam)
		render.DrawSprite(tr.HitPos, 2, 2, COLOR_WHITE)
		render.DrawSprite(tr.HitPos, 8, 8, colBeam)
	else
		render.SetMaterial(matGlow)
		render.DrawSprite(lightpos, 4, 4, COLOR_WHITE)
		render.DrawSprite(lightpos, 16, 16, colBeam)
	end
end
