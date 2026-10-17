local PANEL = {}

PANEL.NextRefresh = 0
PANEL.RefreshTime = 1

local col2 = Color(190, 150, 80, 210)
local coldark = Color(0, 0, 0, 100)

local function GetTargetEntIndex()
	return GAMEMODE.HumanMenuLockOn and GAMEMODE.HumanMenuLockOn:IsValid() and GAMEMODE.HumanMenuLockOn:EntIndex() or 0
end

local function DropDoClick(self)
	RunConsoleCommand("zsdropammo", self:GetParent():GetAmmoType())
end

local function GiveDoClick(self)
	RunConsoleCommand("zsgiveammo", self:GetParent():GetAmmoType(), GetTargetEntIndex())
end

function PANEL:Init()
	local font = "ZSAmmoName"
	self.m_AmmoCountLabel = EasyLabel(self, "0", font, color_black)

	self.m_AmmoTypeLabel = vgui.Create("DLabelAutoScroll", self)
	self.m_AmmoTypeLabel:SetFont(font)
	self.m_AmmoTypeLabel:SetTextColor(col2)
	self.m_AmmoTypeLabel:SetScrollingMode("time")
	self.m_AmmoTypeLabel:SetContentAlignment(5)
	self.m_AmmoTypeLabel:SetAutoScroll(true)
	self.m_AmmoTypeLabel:SetText(" ")

	self.m_DropButton = vgui.Create("DImageButton", self)
	self.m_DropButton:SetImage("icon16/box.png")
	self.m_DropButton:SizeToContents()
	self.m_DropButton:SetTooltip(translate.Get("ammocounter_drop"))
	self.m_DropButton.DoClick = DropDoClick

	self.m_GiveButton = vgui.Create("DImageButton", self)
	self.m_GiveButton:SetImage("icon16/user_go.png")
	self.m_GiveButton:SizeToContents()
	self.m_GiveButton:SetTooltip(translate.Get("ammocounter_give"))
	self.m_GiveButton.DoClick = GiveDoClick

	self:SetAmmoType("pistol")
end

local colBG = Color(5, 5, 5, 180)
function PANEL:Paint()
	local tall = self:GetTall()
	local csize = tall - 8
	draw.RoundedBoxEx(8, 0, 0, self:GetWide(), tall, colBG)
	draw.RoundedBox(4, 8, tall * 0.5 - csize * 0.5, csize, csize, col2)

	return true
end

function PANEL:Think()
	if RealTime() >= self.NextRefresh then
		self.NextRefresh = RealTime() + self.RefreshTime
		self:RefreshContents()
	end
end

function PANEL:RefreshContents()
	local count = MySelf:GetAmmoCount(self:GetAmmoType())
	if self._LastCount == count then return end
	self._LastCount = count

	self.m_AmmoCountLabel:SetTextColor(count == 0 and coldark or color_black)
	self.m_AmmoCountLabel:SetText(count)
	self.m_AmmoCountLabel:SizeToContents()

	self:InvalidateLayout()
end

function PANEL:PerformLayout()
	local tall = self:GetTall()
	local wide = self:GetWide()
	local csize = tall - 8

	-- Counter stays on the left, on the colored circle.
	self.m_AmmoCountLabel:SetPos(8 + csize * 0.5 - self.m_AmmoCountLabel:GetWide() / 2, 0)
	self.m_AmmoCountLabel:CenterVertical()

	-- Buttons on the right, in the corners.
	self.m_DropButton:AlignTop(1)
	self.m_DropButton:AlignRight(8)

	self.m_GiveButton:AlignBottom(1)
	self.m_GiveButton:AlignRight(8)

	-- Ammo name fills all the room between the counter and the buttons.
	-- If the text doesn't fit, DLabelAutoScroll scrolls it.
	local left  = 8 + csize + 4
	local right = wide - 8 - math.max(self.m_DropButton:GetWide(), self.m_GiveButton:GetWide()) - 4
	local labelW = math.max(20, right - left)
	self.m_AmmoTypeLabel:SetSize(labelW, tall)
	self.m_AmmoTypeLabel:SetPos(left, 0)
end

function PANEL:SetAmmoType(ammotype)
	self.m_AmmoType = ammotype

	self.m_AmmoTypeLabel:SetText(translate.AmmoName(ammotype, "inv"))
	-- Do not call SizeToContents: DLabelAutoScroll gets its fixed width
	-- from PerformLayout. SizeToContents would stretch the label to the
	-- full text width and overlap the buttons.

	self:RefreshContents()
end

function PANEL:GetAmmoType()
	return self.m_AmmoType
end

vgui.Register("DAmmoCounter", PANEL, "DPanel")