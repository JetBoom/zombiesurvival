INC_CLIENT()

ENT.Pulsed = true

function ENT:Initialize()
	self:SetModelScale(0.5, 0)

	self.AmbientSound = CreateSound(self, "npc/scanner/combat_scan_loop4.wav")
	self.AmbientSound:SetSoundLevel(55)

	local cmodel = ClientsideModel("models/props_wasteland/buoy01.mdl")
	if cmodel:IsValid() then
		cmodel:SetPos(self:LocalToWorld(Vector(0, 0, -11)))
		cmodel:SetAngles(self:LocalToWorldAngles(Angle(0, 0, 0)))
		cmodel:SetSolid(SOLID_NONE)
		cmodel:SetMoveType(MOVETYPE_NONE)
		cmodel:SetColor(Color(255, 150, 150))
		cmodel:SetParent(self)
		cmodel:SetOwner(self)

		local matrix = Matrix()
		matrix:Scale(Vector(0.6, 0.6, 0.02))
		cmodel:EnableMatrix( "RenderMultiply", matrix )

		cmodel:Spawn()

		self.CModel = cmodel
	end
end

function ENT:DrawTranslucent()
	self:DrawModel()

	local owner = self:GetObjectOwner()
	local ammo = self:GetAmmo()

	if MySelf:IsValid() and MySelf:Team() == TEAM_HUMAN then
		local ang = self:LocalToWorldAngles(Angle(0, 90, 0))
		cam.Start3D2D(self:LocalToWorld(Vector(-11, 0, -10)), ang, 0.04)
			local name = ""
			if owner:IsValid() and owner:IsPlayer() then
				name = owner:ClippedName()
			end
			self:Draw3DHealthBar(math.Clamp(self:GetObjectHealth() / self:GetMaxObjectHealth(), 0, 1), name, 0, 0.65)

			if ammo > 0 then
				draw.SimpleTextBlurry("["..ammo.." / "..self.MaxAmmo.."]", "ZS3D2DFont", 0, 550, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			else
				draw.SimpleTextBlurry(translate.Get("empty"), "ZS3D2DFont", 0, 550, COLOR_RED, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		cam.End3D2D()
	end
end

function ENT:Think()
	if self:GetObjectOwner():IsValid() and self:GetAmmo() > 0 then
		self.AmbientSound:PlayEx(0.5, 100)
	else
		self.AmbientSound:Stop()
	end

	if MySelf:IsValid() then
		if self.Pulsed then
			if CurTime() < self:GetNextRepairPulse() then
				self.Pulsed = false
			end
		elseif CurTime() >= self:GetNextRepairPulse() then
			self.Pulsed = true

			if self:GetAmmo() > 0 then
				self:EmitSound("npc/scanner/scanner_scan2.wav", 70, 50)

				local pos = self:LocalToWorld(Vector(0, 0, 30))
				local emitter = ParticleEmitter(pos)
				emitter:SetNearClip(24, 32)

				for i=1, 45 do
					local dir = VectorRand():GetNormalized()
					local particle = emitter:Add("sprites/glow04_noz", pos)
					particle:SetDieTime(0.7)
					particle:SetColor(225,150,255)
					particle:SetStartAlpha(40)
					particle:SetEndAlpha(0)
					particle:SetStartSize(5)
					particle:SetEndSize(15)
					particle:SetCollide(true)
					particle:SetBounce(0)
					particle:SetGravity(dir * -210)
					particle:SetVelocity(dir * 205)
				end

				for i=1, 10 do
					local dir = VectorRand():GetNormalized()
					local particle = emitter:Add("sprites/glow04_noz", pos)
					particle:SetDieTime(math.Rand(1.8, 2.5))
					particle:SetColor(145,155,255)
					particle:SetStartAlpha(255)
					particle:SetEndAlpha(0)
					particle:SetStartSize(15)
					particle:SetEndSize(0)
					particle:SetGravity(dir * -6)
					particle:SetVelocity(dir * 5)
				end

				emitter:Finish() emitter = nil collectgarbage("step", 64)
			end
		end
	end

	self:NextThink(CurTime() + 0.1)
	return true
end

function ENT:OnRemove()
	self.AmbientSound:Stop()

	if self.CModel and self.CModel:IsValid() then
		self.CModel:Remove()
	end
end
