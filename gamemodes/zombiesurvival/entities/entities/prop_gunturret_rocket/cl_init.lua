INC_CLIENT()

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	local ent, matrix = ClientsideModel("models/weapons/w_rocket_launcher.mdl")
	if ent:IsValid() then
		ent:SetParent(self)
		ent:SetOwner(self)
		ent:SetLocalPos(vector_origin)
		ent:SetLocalAngles(angle_zero)
		ent:SetMaterial("phoenix_storms/torpedo")
		ent:SetColor(Color(150, 150, 150))

		matrix = Matrix()
		matrix:Scale(Vector(0.9, 2, 2))
		ent:EnableMatrix("RenderMultiply", matrix)

		ent:Spawn()
		self.GunAttachment = ent
	end

	ent = ClientsideModel("models/props_trainstation/trainstation_ornament002.mdl")
	if ent:IsValid() then
		ent:SetParent(self)
		ent:SetOwner(self)
		ent:SetLocalPos(vector_origin)
		ent:SetLocalAngles(angle_zero)
		ent:SetMaterial("phoenix_storms/torpedo")
		ent:SetColor(Color(100, 100, 100))

		matrix = Matrix()
		matrix:Scale(Vector(0.65, 0.65, 1.5))
		ent:EnableMatrix("RenderMultiply", matrix)

		ent:Spawn()
		self.GunBase = ent
	end

	ent = ClientsideModel("models/props_wasteland/buoy01.mdl")
	if ent:IsValid() then
		ent:SetParent(self)
		ent:SetOwner(self)
		ent:SetLocalPos(vector_origin)
		ent:SetLocalAngles(angle_zero)
		ent:SetMaterial("phoenix_storms/torpedo")
		ent:SetColor(Color(100, 100, 100))

		matrix = Matrix()
		matrix:Scale(Vector(0.25, 0.15, 0.7))
		ent:EnableMatrix("RenderMultiply", matrix)

		ent:Spawn()
		self.GunBase2 = ent
	end
end

function ENT:DrawTranslucent()
	local nodrawattachs = self:TransAlphaToMe() < 0.4

	local atch = self.GunAttachment
	if atch and atch:IsValid() then
		local ang = self:GetGunAngles()
		ang:RotateAroundAxis(ang:Up(), 180)

		atch:SetPos(self:ShootPos() + ang:Forward() * -8 + ang:Right() * 1 + ang:Up() * -5)
		atch:SetAngles(ang)

		atch:SetNoDraw(nodrawattachs or self:GetObjectOwner() == MySelf and self:GetManualControl())
	end

	atch = self.GunBase
	if atch and atch:IsValid() then
		local ang = self:GetAngles()
		ang:RotateAroundAxis(ang:Up(), 180)

		atch:SetPos(self:GetPos())
		atch:SetAngles(ang)

		atch:SetNoDraw(nodrawattachs or self:GetObjectOwner() == MySelf and self:GetManualControl())
	end

	atch = self.GunBase2
	if atch and atch:IsValid() then
		atch:SetNoDraw(nodrawattachs or self:GetObjectOwner() == MySelf and self:GetManualControl())
	end

	self.BaseClass.DrawTranslucent(self)
end

function ENT:OnRemove()
	if self.GunAttachment and self.GunAttachment:IsValid() then
		self.GunAttachment:Remove()
	end

	if self.GunBase and self.GunBase:IsValid() then
		self.GunBase:Remove()
	end

	if self.GunBase2 and self.GunBase2:IsValid() then
		self.GunBase2:Remove()
	end

	self.ScanningSound:Stop()
	self.ShootingSound:Stop()
end
