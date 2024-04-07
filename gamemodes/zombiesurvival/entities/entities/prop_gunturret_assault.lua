AddCSLuaFile()

ENT.Base = "prop_gunturret"

ENT.SWEP = "weapon_zs_gunturret_assault"

ENT.AmmoType = "ar2"
ENT.FireDelay = 0.17
ENT.NumShots = 1
ENT.Damage = 21
ENT.PlayLoopingShootSound = false
ENT.Spread = 2
ENT.MaxAmmo = 500
ENT.MaxHealth = 225

if CLIENT then

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	local ent = ClientsideModel("models/weapons/w_rif_aug.mdl")
	if ent:IsValid() then
		ent:SetParent(self)
		ent:SetOwner(self)
		ent:SetLocalPos(vector_origin)
		ent:SetLocalAngles(angle_zero)
		ent:SetMaterial("phoenix_storms/torpedo")
		ent:SetColor(Color(70, 70, 70))

		matrix = Matrix()
		matrix:Scale(Vector(1.1, 0.9, 0.9))
		ent:EnableMatrix("RenderMultiply", matrix)

		ent:Spawn()
		self.GunAttachment = ent
	end

	ent = ClientsideModel("models/weapons/w_rif_aug.mdl")
	if ent:IsValid() then
		ent:SetParent(self)
		ent:SetOwner(self)
		ent:SetLocalPos(vector_origin)
		ent:SetLocalAngles(angle_zero)
		ent:SetMaterial("phoenix_storms/torpedo")
		ent:SetColor(Color(70, 70, 70))

		matrix = Matrix()
		matrix:Scale(Vector(1.1, 0.9, 0.9))
		ent:EnableMatrix("RenderMultiply", matrix)

		ent:Spawn()
		self.GunAttachment2 = ent
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
		local gunpos = self:ShootPos() + ang:Forward() * 4 + ang:Right() * 4
		ang:RotateAroundAxis(ang:Forward(), 45)

		atch:SetPos(gunpos)
		atch:SetAngles(ang)

		atch:SetNoDraw(nodrawattachs or self:GetObjectOwner() == MySelf and self:GetManualControl())
	end

	atch = self.GunAttachment2
	if atch and atch:IsValid() then
		local ang = self:GetGunAngles()
		local gunpos = self:ShootPos() + ang:Forward() * 4 + ang:Right() * 4
		ang:RotateAroundAxis(ang:Forward(), -45)

		atch:SetPos(gunpos)
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

	if self.GunAttachment2 and self.GunAttachment2:IsValid() then
		self.GunAttachment2:Remove()
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

end

function ENT:PlayShootSound()
	self:EmitSound("weapons/galil/galil-1.wav", 70, 125, 0.75, CHAN_AUTO)
	self:EmitSound("weapons/m4a1/m4a1_unsil-1.wav", 70, 145, 0.55, CHAN_WEAPON)
end
