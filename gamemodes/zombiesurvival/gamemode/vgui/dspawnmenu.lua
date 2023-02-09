local PANEL = {}

PANEL.Spacing = 12
PANEL.SlideTime = 0 --0.2
PANEL.NextRefresh = 0
PANEL.RefreshTime = 1

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
	self:SetSize(BetterScreenScale() * 320, ScrH())
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
end

function PANEL:RefreshContents()
	for k, v in pairs(self.Items) do
		v:Remove()
	end
	self.Items = {}

	local occurs = {}

	for k, nest in ipairs(GAMEMODE.CachedNests) do
		if not nest:IsValid() then continue end
		local nown = nest:GetNestOwner()
		occurs[nown] = (occurs[nown] or 0) + 1
		local ownname = nown:IsValidZombie() and nown:ClippedName() or ""

		local item = EasyButton(self, "Nest (" .. ownname .. " - " .. occurs[nown] .. ")", 8, 4)
		item:SetFont("ZSHUDFontSmall")
		item:SizeToContents()
		item.DoClick = function()
			net.Start("zs_nestspec")
				net.WriteEntity(nest)
			net.SendToServer()
		end

		self:AddItem(item)
	end

	for k, baby in ipairs(GAMEMODE.CachedBabies) do
		if not baby:IsValid() then continue end

		local item = EasyButton(self, "Gore Child", 8, 4)
		item:SetFont("ZSHUDFontSmall")
		item:SizeToContents()
		item.DoClick = function()
			net.Start("zs_nestspec")
				net.WriteEntity(baby)
			net.SendToServer()
		end

		self:AddItem(item)
	end

	self:InvalidateLayout()
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

vgui.Register("DZombieSpawnMenu", PANEL, "DPanel")
