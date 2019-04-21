INC_CLIENT()
include("cl_animations.lua")

function ENT:DrawTranslucent()
	if not self.ShowBaseModel then
		render.SetBlend(0)
	end
	self:DrawModel()
	if not self.ShowBaseModel then
		render.SetBlend(1)
	end
	if self.RenderModels and not self.NoDrawSubModels then
		self:RenderModels(ble, cmod)
	end
end

function ENT:Think()
	local class = self:GetWeaponType()
	if class ~= self.LastWeaponType then
		self.LastWeaponType = class

		self:RemoveModels()

		local weptab = weapons.Get(class)
		if weptab then
			local showmdl = weptab.ShowWorldModel or not self:LookupBone("ValveBiped.Bip01_R_Hand") and not weptab.NoDroppedWorldModel
			self.ShowBaseModel = weptab.ShowWorldModel == nil and true or showmdl

			if weptab.WElements then
				self.WElements = table.FullCopy(weptab.WElements)
				self:CreateModels(self.WElements)
			end
		end
	end
end

function ENT:OnRemove()
	self:RemoveModels()
end
