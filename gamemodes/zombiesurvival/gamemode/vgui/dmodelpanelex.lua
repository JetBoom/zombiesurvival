local PANEL = {}

function PANEL:SetModel(strModelName)
	if IsValid(self.Entity) then
		self.Entity:Remove()
		self.Entity = nil		
	end

	if not ClientsideModel then return end
	
	self.Entity = ClientsideModel(strModelName, RENDER_GROUP_OPAQUE_ENTITY)
	if not IsValid(self.Entity) then return end

	self.Entity:SetNoDraw(true)

	local iSeq = self.Entity:LookupSequence("walk")
	if iSeq <= 0 then iSeq = self.Entity:LookupSequence("Run1") end
	if iSeq <= 0 then iSeq = self.Entity:LookupSequence("walk_all") end
	if iSeq <= 0 then iSeq = self.Entity:LookupSequence("WalkUnarmed_all") end
	if iSeq <= 0 then iSeq = self.Entity:LookupSequence("walk_all_moderate") end
	if iSeq > 0 then self.Entity:ResetSequence(iSeq) end
end

function PANEL:AutoCam()
	if IsValid(self.Entity) then
		local mins, maxs = self.Entity:GetRenderBounds()
		self:SetCamPos(mins:Distance(maxs) * Vector(0.75, 0.75, 0.5))
		self:SetLookAt((mins + maxs) / 2)
	end
end

vgui.Register("DModelPanelEx", PANEL, "DModelPanel")
