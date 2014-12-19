local PANEL = {}

function PANEL:SetModel(strModelName)
	self.BaseClass.SetModel(self, strModelName)

	self:AutoCam()
end

local matWhite = Material("models/debug/debugwhite")
function PANEL:Paint(w, h)
	if !IsValid( self.Entity ) then return end
	
	self:LayoutEntity( self.Entity )
	
	local ang = self.aLookAngle
	local x, y = self:LocalToScreen( 0, 0 )
	local col = self.colColor

	if not ang then
		ang = (self.vLookatPos - self.vCamPos):Angle()
	end
	
	cam.Start3D(self.vCamPos, ang, self.fFOV, x, y, w, h, 5, self.FarZ)
	cam.IgnoreZ(true)
	
	render.SuppressEngineLighting(true)
	render.SetColorModulation(col.r / 255, col.g / 255, col.b / 255)
	render.SetBlend(col.a / 255)
	render.ModelMaterialOverride(matWhite)

	self:DrawModel()

	render.ModelMaterialOverride()	
	render.SetBlend(1)
	render.SetColorModulation(1, 1, 1)
	render.SuppressEngineLighting(false)

	cam.IgnoreZ(false)
	cam.End3D()
	
	self.LastPaint = RealTime()
end

vgui.Register("DModelKillIcon", PANEL, "DModelPanelEx")
