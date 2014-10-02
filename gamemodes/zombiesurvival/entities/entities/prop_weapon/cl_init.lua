include("shared.lua")
include("cl_animations.lua")

ENT.ColorModulation = Color(0.15, 0.8, 1)

function ENT:Think()
	local class = self:GetWeaponType()
	if class ~= self.LastWeaponType then
		self.LastWeaponType = class

		self:RemoveModels()
		self.ShowWorldModel = nil

		local weptab = weapons.GetStored(class)
		if weptab then
			self.ShowWorldModel = not weptab.NoDroppedWorldModel

			if weptab.WElements then
				self.WElements = table.FullCopy(weptab.WElements)
				self:CreateModels(self.WElements)
			end
		end
	end
end

function ENT:DrawTranslucent()
	if not self.NoDrawSubModels then
		self:RenderModels()
	end

	if self.ShowWorldModel == nil or self.ShowWorldModel then
		self.BaseClass.DrawTranslucent(self)
	end
end

function ENT:OnRemove()
	self:RemoveModels()
end
