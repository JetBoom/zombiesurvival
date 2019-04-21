INC_CLIENT()
include("cl_animations.lua")

ENT.ColorModulation = Color(0.15, 0.8, 1)

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

			self.ColorModulation = weptab.DroppedColorModulation or self.ColorModulation
			self.PropWeapon = true
			self.QualityTier = weptab.QualityTier
			self.Branch = weptab.Branch
			self.BranchData = weptab.Branches and weptab.Branches[self.Branch]
		end
	end
end

function ENT:OnRemove()
	self:RemoveModels()
end
