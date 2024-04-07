INC_CLIENT()

ENT.Pulsed = true

function ENT:Initialize()
	local matrix = Matrix()
	matrix:Scale(Vector(0.6, 0.6, 1.2))
	self:EnableMatrix( "RenderMultiply", matrix )

	self.AmbientSound = CreateSound(self, "ambient/machines/combine_shield_touch_loop1.wav")
	self.AmbientSound:SetSoundLevel(55)

	local cmodel = ClientsideModel("models/props_trainstation/trainstation_ornament002.mdl")
	if cmodel:IsValid() then
		cmodel:SetPos(self:LocalToWorld(Vector(0, 0, -25.6)))
		cmodel:SetAngles(self:LocalToWorldAngles(Angle(0, 0, 0)))
		cmodel:SetSolid(SOLID_NONE)
		cmodel:SetMoveType(MOVETYPE_NONE)
		cmodel:SetColor(Color(190, 255, 255))
		cmodel:SetParent(self)
		cmodel:SetOwner(self)

		matrix = Matrix()
		matrix:Scale(Vector(2, 2, 0.25))
		cmodel:EnableMatrix( "RenderMultiply", matrix )

		cmodel:Spawn()

		self.CModel = cmodel
	end
end

local material = Material("models/shiny")
function ENT:DrawZapper()
	render.ModelMaterialOverride(material)
	render.SetColorModulation(0.5, 0.5, 0.5)
	self:DrawModel()
	render.ModelMaterialOverride()
	render.SetColorModulation(1, 1, 1)
end

function ENT:DrawTranslucent()
	self:DrawZapper()

	local owner = self:GetObjectOwner()
	local ammo = self:GetAmmo()

	if MySelf:IsValid() and MySelf:Team() == TEAM_HUMAN then
		local ang = self:LocalToWorldAngles(Angle(0, 90, 0))
		cam.Start3D2D(self:LocalToWorld(Vector(-10, 0, -19)), ang, 0.05)
			local name = ""
			if owner:IsValid() and owner:IsPlayer() then
				name = owner:ClippedName()
			end
			self:Draw3DHealthBar(math.Clamp(self:GetObjectHealth() / self:GetMaxObjectHealth(), 0, 1), name, 0, 0.8)

			if ammo > 0 then
				draw.SimpleTextBlurry("["..ammo.." / "..self.MaxAmmo.."]", "ZS3D2DFont", 0, 450, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			else
				draw.SimpleTextBlurry(translate.Get("empty"), "ZS3D2DFont", 0, 450, COLOR_RED, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		cam.End3D2D()
	end
end

ENT.NextEmit = 0
function ENT:Think()
	if self:GetObjectOwner():IsValid() and self:GetAmmo() > 1 then
		self.AmbientSound:PlayEx(0.5, 90)

		if CurTime() >= self.NextEmit then
			self.NextEmit = CurTime() + 0.2

			local pos = self:LocalToWorld(Vector(0, 0, 23))
			local emitter = ParticleEmitter(pos)
			emitter:SetNearClip(24, 32)

			for i=1, 2 do
				local particle = emitter:Add("effects/blueflare1", pos)
				particle:SetDieTime(0.3)
				particle:SetColor(190,210,255)
				particle:SetStartAlpha(200)
				particle:SetEndAlpha(0)
				particle:SetStartSize(1)
				particle:SetEndSize(0)
				particle:SetVelocity(VectorRand():GetNormal() * 20)
			end

			local charge = math.Clamp(29 - ((self:GetNextZap() - CurTime())/3)*40, -20, 22)
			local chargepos = self:LocalToWorld(Vector(0, 0, charge))

			for i=1, 6 do
				local particle = emitter:Add("effects/blueflare1", chargepos)
				particle:SetDieTime(0.4)
				particle:SetColor(150,230,215)
				particle:SetStartAlpha(200)
				particle:SetEndAlpha(0)
				particle:SetStartSize(2)
				particle:SetEndSize(0)
				particle:SetVelocity(VectorRand():GetNormal() * 20)
			end

			emitter:Finish() emitter = nil collectgarbage("step", 64)
		end
	else
		self.AmbientSound:Stop()
	end

	self:NextThink(CurTime() + 0.05)
	return true
end

function ENT:OnRemove()
	self.AmbientSound:Stop()

	if self.CModel and self.CModel:IsValid() then
		self.CModel:Remove()
	end
end
