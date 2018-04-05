local PANEL = {}

function PANEL:PaintAt( x, y, dw, dh )

	self:LoadMaterial()

	if ( !self.m_Material ) then return true end

	surface.SetMaterial( self.m_Material )
	surface.SetDrawColor( self.m_Color.r, self.m_Color.g, self.m_Color.b, self.m_Color.a )
	
	if ( self:GetKeepAspect() ) then
	
		local w = self.ActualWidth
		local h = self.ActualHeight
		
		-- Image is bigger than panel, shrink to suitable size
		if ( w > dw && h > dh ) then
		
			if ( w > dw ) then
			
				local diff = dw / w
				w = w * diff
				h = h * diff
			
			end
			
			if ( h > dh ) then
			
				local diff = dh / h
				w = w * diff
				h = h * diff
			
			end

		end
		
		if ( w < dw ) then
		
			local diff = dw / w
			w = w * diff
			h = h * diff
		
		end
		
		if ( h < dh ) then
		
			local diff = dh / h
			w = w * diff
			h = h * diff
		
		end
		
		local OffX = (dw - w) * 0.5
		local OffY = (dh - h) * 0.5
			
		surface.DrawTexturedRect( OffX+x, OffY+y, w, h )
	
		return true
	
	end
	
	
	surface.DrawTexturedRectRotated( x + dw / 2, y + dh / 2, dw, dh, self:GetRotation() )
	return true

end

function PANEL:SetRotation(m)
	self.m_Rotation = m
end

function PANEL:GetRotation()
	return self.m_Rotation or 0
end

vgui.Register("DEXRotatedImage", PANEL, "DImage")
