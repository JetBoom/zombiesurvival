INC_CLIENT()
include("cl_animations.lua")

ENT.ColorModulation = Color(1, 0.5, 0)

function ENT:Think()
	local itype = self:GetInventoryItemType()
	if itype ~= self.LastInvItemType then
		self.LastInvItemType = itype

		self:RemoveModels()

		local invdata = GAMEMODE.ZSInventoryItemData[itype]
		local droppedeles = invdata.DroppedEles

		if invdata then
			--local showmdl = --weptab.ShowWorldModel or not self:LookupBone("ValveBiped.Bip01_R_Hand") and not weptab.NoDroppedWorldModel
			self.ShowBaseModel = not istable(droppedeles)--weptab.ShowWorldModel == nil and true or showmdl

			if istable(droppedeles) then
				self.WElements = table.FullCopy(droppedeles)
				self:CreateModels(self.WElements)
			end

			self.ColorModulation = self.ColorModulation
			self.PropWeapon = true
		end
	end
end

function ENT:OnRemove()
	self:RemoveModels()
end
