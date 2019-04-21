INC_SERVER()

ENT.DieTime = 0

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetSolid(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetModelScale(1.03, 0)

	self.DieTime = CurTime() + 10
end

function ENT:AttachTo(ent)
	if IsValid(ent) and ent:GetModel() ~= "models/error.mdl" then
		self:SetModel(ent:GetModel())
		self:SetSkin(ent:GetSkin() or 0)
		self:SetPos(ent:GetPos())
		self:SetAngles(ent:GetAngles())
		self:SetAlpha(ent:GetAlpha())
		self:SetOwner(ent)
		self:SetParent(ent)
		ent._BARRICADEBROKEN = self
	else
		self:Fire("kill", "", 1)
	end
end

function ENT:Think()
	if CurTime() >= self.DieTime and not self.Broken then
		self.Broken = true

		local ent = self:GetParent()
		if ent:IsValid() then
			ent:Fire("break", "", 0)
			ent:Fire("kill", "", 0.01)

			local effectdata = EffectData()
				effectdata:SetOrigin(ent:WorldSpaceCenter())
			util.Effect("Explosion", effectdata)
		end

		self:Remove()
	end
end
