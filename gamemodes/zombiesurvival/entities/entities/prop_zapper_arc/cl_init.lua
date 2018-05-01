INC_CLIENT()

local arcscolor = Color(150, 150, 150)
function ENT:Initialize()
	local matrix = Matrix()
	matrix:Scale(Vector(0.85, 0.85, 1.2))
	self:EnableMatrix( "RenderMultiply", matrix )

	self.AmbientSound = CreateSound(self, "ambient/machines/combine_shield_touch_loop1.wav")
	self.AmbientSound:SetSoundLevel(65)

	local cmodel = ClientsideModel("models/props_trainstation/trainstation_ornament002.mdl")
	if cmodel:IsValid() then
		cmodel:SetPos(self:LocalToWorld(Vector(0, 0, -25.6)))
		cmodel:SetAngles(self:LocalToWorldAngles(Angle(0, 0, 0)))
		cmodel:SetSolid(SOLID_NONE)
		cmodel:SetMoveType(MOVETYPE_NONE)
		cmodel:SetColor(Color(195, 195, 145))
		cmodel:SetParent(self)
		cmodel:SetOwner(self)

		matrix = Matrix()
		matrix:Scale(Vector(2, 2, 0.25))
		cmodel:EnableMatrix( "RenderMultiply", matrix )

		cmodel:Spawn()

		self.CModel = cmodel
	end

	cmodel = ClientsideModel("models/props_c17/utilityconnecter005.mdl")
	if cmodel:IsValid() then
		cmodel:SetPos(self:LocalToWorld(Vector(0, -2, 25.6)))
		cmodel:SetAngles(self:LocalToWorldAngles(Angle(0, 0, -70)))
		cmodel:SetSolid(SOLID_NONE)
		cmodel:SetMoveType(MOVETYPE_NONE)
		cmodel:SetColor(arcscolor)
		cmodel:SetMaterial("models/shiny")
		cmodel:SetParent(self)
		cmodel:SetOwner(self)

		matrix = Matrix()
		matrix:Scale(Vector(2, 1.25, 0.25))
		cmodel:EnableMatrix( "RenderMultiply", matrix )

		cmodel:Spawn()

		self.ArcOne = cmodel
	end

	cmodel = ClientsideModel("models/props_c17/utilityconnecter005.mdl")
	if cmodel:IsValid() then
		cmodel:SetPos(self:LocalToWorld(Vector(0, 2, 25.6)))
		cmodel:SetAngles(self:LocalToWorldAngles(Angle(0, 0, 70)))
		cmodel:SetSolid(SOLID_NONE)
		cmodel:SetMoveType(MOVETYPE_NONE)
		cmodel:SetColor(arcscolor)
		cmodel:SetMaterial("models/shiny")
		cmodel:SetParent(self)
		cmodel:SetOwner(self)

		matrix = Matrix()
		matrix:Scale(Vector(2, 1.25, 0.25))
		cmodel:EnableMatrix( "RenderMultiply", matrix )

		cmodel:Spawn()

		self.ArcTwo = cmodel
	end
end

local material = Material("models/shiny")
local matBeam = Material("trails/electric")
function ENT:DrawZapper()
	render.ModelMaterialOverride(material)
	render.SetColorModulation(0.4, 0.4, 0.4)
	self:DrawModel()
	render.ModelMaterialOverride()
	render.SetColorModulation(1, 1, 1)

	if self:GetObjectOwner():IsValid() and self:GetAmmo() > 1 then
		local charge = math.Clamp(29 - ((self:GetNextZap() - CurTime())/4.5)*49, -20, 34)
		local spread = ((20 +charge)/34)*3

		local pos1 = self:LocalToWorld(Vector(0, spread, 21.5 + charge/2.5)) + VectorRand()/1.5
		local pos2 = self:LocalToWorld(Vector(0, -spread, 21.5 + charge/2.5)) + VectorRand()/1.5

		-- pos1.z = pos1.z + charge/2.5
		-- pos2.z = pos2.z + charge/2.5

		render.SetMaterial(matBeam)
		render.DrawBeam(pos1, pos2, 1, 0, 1, COLOR_CYAN)
	end
end

function ENT:Think()
	if self:GetObjectOwner():IsValid() and self:GetAmmo() > 2 then
		local charge = math.Clamp(29 - ((self:GetNextZap() - CurTime())/4.5)*49, -20, 25)

		self.AmbientSound:PlayEx(0.6, 65 + charge/1.5)

		if CurTime() >= self.NextEmit then
			self.NextEmit = CurTime() + 0.2

			local pos = self:LocalToWorld(Vector(0, 0, 25))
			local emitter = ParticleEmitter(pos)
			emitter:SetNearClip(24, 32)

			for i=1, 2 do
				local particle = emitter:Add("effects/blueflare1", pos)
				particle:SetDieTime(0.3)
				particle:SetColor(110,130,245)
				particle:SetStartAlpha(200)
				particle:SetEndAlpha(0)
				particle:SetStartSize(1)
				particle:SetEndSize(0)
				particle:SetVelocity(VectorRand():GetNormal() * 20)
			end

			local chargepos = self:LocalToWorld(Vector(0, 0, charge))

			for i=1, 6 do
				local particle = emitter:Add("effects/blueflare1", chargepos)
				particle:SetDieTime(0.4)
				particle:SetColor(110,130,245)
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

	if self.ArcOne and self.ArcOne:IsValid() then
		self.ArcOne:Remove()
	end

	if self.ArcTwo and self.ArcTwo:IsValid() then
		self.ArcTwo:Remove()
	end
end
