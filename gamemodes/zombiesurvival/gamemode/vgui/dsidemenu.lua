local PANEL = {}

PANEL.Spacing = 8
PANEL.SlideTime = 0 --0.2
PANEL.NextRefresh = 0

function PANEL:Init()
	self:RefreshSize()
	self:SetPos(ScrW() - 1, 0)

	self.Items = {}
end

function PANEL:Think()
	local time = RealTime()
	if self.CloseTime and time >= self.CloseTime then
		self.CloseTime = nil
		self:SetVisible(false)
	elseif self.StartChecking and time >= self.StartChecking then
		if not MySelf:KeyDown(GAMEMODE.MenuKey) then
			self:CloseMenu()
		end
	end
end

function PANEL:RefreshSize()
	self:SetSize(BetterScreenScale() * 256, ScrH())
end

function PANEL:OpenMenu()
	if self.StartChecking and RealTime() < self.StartChecking then return end

	self.CloseTime = nil

	self:RefreshSize()
	self:SetPos(ScrW() - self:GetWide(), 0, self.SlideTime, 0, self.SlideTime * 0.8) --self:MoveTo(ScrW() - self:GetWide(), 0, self.SlideTime, 0, self.SlideTime * 0.8)
	self:SetVisible(true)
	self:MakePopup()
	self.StartChecking = RealTime() + 0.1
	self:RefreshContents()

	timer.Simple(0, function()
		gui.SetMousePos(ScrW() * 0.5, ScrH() * 0.5)
	end)
end

function PANEL:CloseMenu()
	self:RefreshContents()

	if self.CloseTime then return end
	self.CloseTime = RealTime() + self.SlideTime

	--self:MoveTo(ScrW() - 1, 0, self.SlideTime, 0, self.SlideTime * 0.8)
end

local texRightEdge = surface.GetTextureID("gui/gradient")
function PANEL:Paint()
	surface.SetDrawColor(5, 5, 5, 180)
	surface.DrawRect(self:GetWide() * 0.4, 0, self:GetWide() * 0.6 + 1, self:GetTall())
	surface.SetTexture(texRightEdge)
	surface.DrawTexturedRectRotated(self:GetWide() * 0.2, self:GetTall() * 0.5, self:GetWide() * 0.4, self:GetTall(), 180)
end

function PANEL:AddItem(item)
	item:SetParent(self)
	item:SetWide(self:GetWide() - 16)

	table.insert(self.Items, item)

	self:InvalidateLayout()
end

function PANEL:RemoveItem(item)
	for k, v in ipairs(self.Items) do
		if v == item then
			item:Remove()
			table.remove(self.Items, k)
			self:InvalidateLayout()
			break
		end
	end
end

function PANEL:RefreshContents()
	local changed = false

	for k, v in ipairs(self.Items) do
		if v.GetAmmoType then
			if MySelf:GetAmmoCount(v:GetAmmoType()) <= 0 then
				if v:IsVisible() then
					v:SetVisible(false)
					changed = true
				end
			elseif not v:IsVisible() then
				v:SetVisible(true)
				changed = true
			end
		end
	end

	if changed then
		self:InvalidateLayout()
	end
end

function PANEL:PerformLayout()
	local y = ScrH() / 2
	for k, item in ipairs(self.Items) do
		if item and item:IsValid() and item:IsVisible() then
			y = y - (item:GetTall() + self.Spacing) / 2
		end
	end

	for k, item in ipairs(self.Items) do
		if item and item:IsValid() and item:IsVisible() then
			item:SetPos(0, y)
			item:CenterHorizontal()
			y = y + item:GetTall() + self.Spacing
		end
	end
end

vgui.Register("DSideMenu", PANEL, "DPanel")
