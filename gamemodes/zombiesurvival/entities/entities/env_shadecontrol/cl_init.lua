INC_CLIENT()

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetModelScale(1.03, 0)

	self.AmbientSound = CreateSound(self, ")weapons/physcannon/superphys_hold_loop.wav")
	self.AmbientSound:PlayEx(0.5, 60)

	self:GetOwner().ShadeControl = self
end

function ENT:OnRemove()
	self.AmbientSound:Stop()

	local owner = self:GetOwner()
	if owner.ShadeControl == self then
		owner.ShadeControl = nil
	end
end

local matRefract = Material("models/spawn_effect")
function ENT:Draw()
	if not render.SupportsPixelShaders_2_0() then return end

	render.UpdateRefractTexture()

	matRefract:SetFloat("$refractamount", 0.02)

	render.ModelMaterialOverride(matRefract)
	self:DrawModel()
	render.ModelMaterialOverride(0)
end
