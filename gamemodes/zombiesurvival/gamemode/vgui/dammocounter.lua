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

	self.m_AmmoTypeLabel = EasyLabel(self, " ", font, col2)

	self.m_DropButton = vgui.Create("DImageButton", self)
	self.m_DropButton:SetImage("icon16/box.png")
	self.m_DropButton:SizeToContents()
	self.m_DropButton:SetTooltip("Drop")
	self.m_DropButton.DoClick = DropDoClick

	self.m_GiveButton = vgui.Create("DImageButton", self)
	self.m_GiveButton:SetImage("icon16/user_go.png")
	self.m_GiveButton:SizeToContents()
	self.m_GiveButton:SetTooltip("Give")
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

	self.m_AmmoCountLabel:SetTextColor(count == 0 and coldark or color_black)
	self.m_AmmoCountLabel:SetText(count)
	self.m_AmmoCountLabel:SizeToContents()

	self:InvalidateLayout()
end

function PANEL:PerformLayout()
	self.m_AmmoTypeLabel:Center()

	self.m_AmmoCountLabel:SetPos(8 + (self:GetTall() - 8) * 0.5 - self.m_AmmoCountLabel:GetWide() / 2, 0)
	self.m_AmmoCountLabel:CenterVertical()

	self.m_DropButton:AlignTop(1)
	self.m_DropButton:AlignRight(8)

	self.m_GiveButton:AlignBottom(1)
	self.m_GiveButton:AlignRight(8)
end

function PANEL:SetAmmoType(ammotype)
	self.m_AmmoType = ammotype

	self.m_AmmoTypeLabel:SetText(GAMEMODE.AmmoNames[ammotype] or ammotype)
	self.m_AmmoTypeLabel:SizeToContents()

	self:RefreshContents()
end

function PANEL:GetAmmoType()
	return self.m_AmmoType
end

vgui.Register("DAmmoCounter", PANEL, "DPanel")
