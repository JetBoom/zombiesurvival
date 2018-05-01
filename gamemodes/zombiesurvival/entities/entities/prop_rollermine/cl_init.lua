INC_CLIENT()

function ENT:Initialize()
	self:SetRenderBounds(Vector(-72, -72, -72), Vector(72, 72, 72))

	self:CreateAmbientSounds()
	self:CreateSubModel()

	self.PixVis = util.GetPixelVisibleHandle()

	hook.Add("CreateMove", self, self.CreateMove)
	hook.Add("ShouldDrawLocalPlayer", self, self.ShouldDrawLocalPlayer)
	hook.Add("CalcView", self, self.CalcView)
end

function ENT:CreateSubModel()
end

function ENT:CreateAmbientSounds()
	self.AmbientSound = CreateSound(self, "npc/roller/mine/rmine_moveslow_loop1.wav")
	self.AmbientSound2 = CreateSound(self, "npc/roller/mine/rmine_seek_loop2.wav")
end

function ENT:PlayAmbientSounds()
	if self:GetVelocity():Length() < 50 then
		self.AmbientSound:Stop()
		self.AmbientSound2:PlayEx(0.7, 100 + math.sin(CurTime()))
	else
		self.AmbientSound:PlayEx(0.8, math.min(70 + self:GetVelocity():Length() * 0.4, 140))
		self.AmbientSound2:Stop()
	end
end

ENT.NextEmit = 0
local smokegravity = Vector(0, 0, 64)
function ENT:Think()
	self:PlayAmbientSounds()

	local perc = math.Clamp(self:GetObjectHealth() / self:GetMaxObjectHealth(), 0, 255)
	if perc < 0.5 and CurTime() >= self.NextEmit then
		self.NextEmit = CurTime() + 0.05 + perc * math.Rand(0.05, 0.25)

		local pos = self:GetPos()
		local sat = perc * 90

		local emitter = ParticleEmitter(pos)
		emitter:SetNearClip(16, 24)

		local particle = emitter:Add("particles/smokey", pos)
		particle:SetStartAlpha(180)
		particle:SetEndAlpha(0)
		particle:SetStartSize(0)
		particle:SetEndSize(math.Rand(8, 20))
		particle:SetVelocity(self:GetVelocity() * 0.7 + VectorRand():GetNormalized() * math.Rand(4, 24))
		particle:SetGravity(smokegravity)
		particle:SetDieTime(math.Rand(0.8, 1.6))
		particle:SetAirResistance(150)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-2, 2))
		particle:SetCollide(true)
		particle:SetBounce(0.2)
		particle:SetColor(sat, sat, sat)

		emitter:Finish() emitter = nil collectgarbage("step", 64)
	end
end

function ENT:OnRemove()
	self.AmbientSound:Stop()
	self.AmbientSound2:Stop()
	self:RemoveSubModel()
end

function ENT:RemoveSubModel()
end

function ENT:SetObjectHealth(health)
	self:SetDTFloat(0, health)
end

function ENT:DrawSubModel()
end

local colLight = Color(255, 0, 0)
local colWhite = Color(255, 255, 255)
local matLight = Material("sprites/light_ignorez")
function ENT:DrawTranslucent()
	self:DrawModel()

	self:DrawSubModel()

	local lp = MySelf
	local owner = self:GetObjectOwner()

	if lp:IsValid() and lp:Team() == TEAM_HUMAN and owner:IsValid() and owner:IsPlayer() then
		local ang = EyeAngles()
		ang.pitch = 0

		ang:RotateAroundAxis(ang:Up(), 270)
		ang:RotateAroundAxis(ang:Forward(), 90)

		cam.Start3D2D(self:GetPos() + Vector(0, 0, 20), ang, 0.03)
			local name = ""
			if owner:IsValid() and owner:IsPlayer() then
				name = owner:ClippedName()
			end
			self:Draw3DHealthBar(math.Clamp(self:GetObjectHealth() / self:GetMaxObjectHealth(), 0, 1), name, 150, 0.85, -150)
		cam.End3D2D()
	end
end

function ENT:CreateMove(cmd)
	if self:GetObjectOwner() ~= MySelf then return end

	if not self:BeingControlled() then return end

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

	if self:BeingControlled() then
		if MySelf == pl and not MySelf.TargetIDFilter then
			MySelf.TargetIDFilter = self
		end

		return true
	elseif MySelf == pl and MySelf.TargetIDFilter then
		MySelf.TargetIDFilter = nil
	end
end

local trace_cam = {mask = MASK_VISIBLE, mins = Vector(-4, -4, -4), maxs = Vector(4, 4, 4)}
function ENT:CalcView(pl, origin, angles, fov, znear, zfar)
	if self:GetObjectOwner() ~= pl or not self:BeingControlled() then return end

	local filter = player.GetAll()
	filter[#filter + 1] = self
	trace_cam.start = self:GetPos()
	trace_cam.endpos = trace_cam.start + angles:Forward() * -48
	trace_cam.filter = filter
	local tr = util.TraceHull(trace_cam)

	return {origin = tr.HitPos + tr.HitNormal * 3}
end
