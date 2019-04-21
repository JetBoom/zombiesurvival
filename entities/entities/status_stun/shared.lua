ENT.Type = "anim"
ENT.Base = "status__base"

ENT.Model = Model("models/effects/splodeglass.mdl")

ENT.Ephemeral = true

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	self:SetModel(self.Model)
	self:SetModelScale(0.05, 0)
	self:DrawShadow(false)

end
