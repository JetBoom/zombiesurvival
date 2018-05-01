function statusValueFunction(statusname)
	return function(self, lp)
		local status = lp:GetStatus(statusname)
		if status and status:IsValid() then
			return math.max(status:GetStartTime() + status:GetDuration() - CurTime(), 0)
		end

		return 0
	end
end

local statusdisplays = {
{
	Color = Color(180, 200, 0),
	Name = "POISON!",
	ValFunc = function(self, lp)
		return lp:GetPoisonDamage()
	end,
	Max = GM.MaxPoisonDamage or 50,
	Icon = Material("zombiesurvival/poison.png")
},
{
	Color = Color(220, 0, 0),
	Name = "BLEED!",
	ValFunc = function(self, lp)
		return lp:GetBleedDamage()
	end,
	Max = GM.MaxBleedDamage or 50,
	Icon = Material("zombiesurvival/bleed.png")
},
{
	Color = Color(255, 50, 50),
	Name = "ENFEEBLE!",
	ValFunc = statusValueFunction("enfeeble"),
	Max = 10,
	Icon = Material("zombiesurvival/infeeble.png")
},
{
	Color = Color(90, 90, 90),
	Name = "DIM VISION!",
	ValFunc = statusValueFunction("dimvision"),
	Max = 10,
	Icon = Material("zombiesurvival/dim_vision.png")
},
{
	Color = Color(75, 140, 75),
	Name = "SLOW!",
	ValFunc = statusValueFunction("slow"),
	Max = 8,
	Icon = Material("zombiesurvival/slow.png")
},
{
	Color = Color(0, 135, 255),
	Name = "FROST!",
	ValFunc = statusValueFunction("frost"),
	Max = 9,
	Icon = Material("zombiesurvival/frost.png")
},
{
	Color = Color(155, 0, 255),
	Name = "TREMOR!",
	ValFunc = statusValueFunction("frightened"),
	Max = 10,
	Icon = Material("zombiesurvival/tremors.png")
},
{
	Color = Color(255, 120, 0),
	Name = "SICKNESS!",
	ValFunc = statusValueFunction("sickness"),
	Max = 15,
	Icon = Material("zombiesurvival/sickness.png")
},
{
	Color = Color(157, 75, 20),
	Name = "KNOCK DOWN!",
	ValFunc = statusValueFunction("knockdown"),
	Max = 5,
	Icon = Material("zombiesurvival/knock_down.png")
},
{
	Color = Color(200, 100, 90),
	Name = "STRENGTH!",
	ValFunc = statusValueFunction("strengthdartboost"),
	Max = 10,
	Icon = Material("zombiesurvival/strength_shot.png")
},
{
	Color = Color(170, 200, 120),
	Name = "ADRENALINE!",
	ValFunc = statusValueFunction("adrenalineamp"),
	Max = 10,
	Icon = Material("zombiesurvival/speed_up.png")
},
{
	Color = Color(130, 220, 110),
	Name = "SPEED!",
	ValFunc = statusValueFunction("healdartboost"),
	Max = 10,
	Icon = Material("zombiesurvival/speed_up.png")
},
{
	Color = Color(90, 120, 220),
	Name = "DEFENCE!",
	ValFunc = statusValueFunction("medrifledefboost"),
	Max = 10,
	Icon = Material("zombiesurvival/defense.png")
},
{
	Color = Color(130, 30, 140),
	Name = "REAPER!",
	ValFunc = statusValueFunction("reaper"),
	Max = 14,
	Icon = Material("zombiesurvival/reaper.png")
},
{
	Color = Color(235, 160, 40),
	Name = "Renegade!",
	ValFunc = statusValueFunction("renegade"),
	Max = 14,
	Icon = Material("zombiesurvival/headshot_stacks.png")
}
}

local PANEL = {}

PANEL.StatusPanels = {}

function PANEL:Init()
	self:DockMargin(0, 0, 0, 0)
	self:DockPadding(0, 0, 0, 0)

	self.StatusPanels = {}

	for _, statusdisp in pairs(statusdisplays) do
		status = vgui.Create("ZSStatus", self)
		status:SetAlpha(240)
		status:SetColor(statusdisp.Color)
		status:SetMemberName(statusdisp.Name)
		status.GetMemberValue = statusdisp.ValFunc
		status.MemberMaxValue = statusdisp.Max
		status.Icon = statusdisp.Icon
		status:Dock(LEFT)

		table.insert(self.StatusPanels, status)
	end

	self:ParentToHUD()
	self:InvalidateLayout()
end

function PANEL:PerformLayout()
	local w = 0
	for _, child in pairs(self:GetChildren()) do
		w = w + child:GetWide()
	end

	self:SetSize(w, BetterScreenScale() * 400)

	self:AlignLeft(math.max(0, ScrW() * 0.01))
	self:CenterVertical(0.92)
end

function PANEL:Think()
	local lp = LocalPlayer()
	if lp:IsValid() then
		for _, panel in pairs(self.StatusPanels) do
			panel:StatusThink(lp)
		end
	end
end

vgui.Register("ZSStatusArea", PANEL, "Panel")

PANEL = {}

PANEL.MemberValue = 0
PANEL.LerpMemberValue = 0
PANEL.MemberMaxValue = 100
PANEL.MemberName = "Unnamed"

function PANEL:SetColor(col) self.m_Color = col end
function PANEL:GetColor() return self.m_Color end
function PANEL:SetMemberName(n) self.MemberName = n end
function PANEL:GetMemberName() return self.MemberName end

function PANEL:Init()
	self:SetColor(Color(255, 255, 255))
	self:SetTall(BetterScreenScale() * 68)
	self:SetWide(BetterScreenScale() * 50)
end

function PANEL:StatusThink(lp)
	if self.GetMemberValue then
		self.MemberValue = self:GetMemberValue(lp) or self.MemberValue
	end
	if self.GetMemberMaxValue then
		self.MemberMaxValue = self:GetMemberMaxValue(lp) or self.MemberMaxValue
	end

	if self.MemberValue > self.LerpMemberValue then
		self.LerpMemberValue = self.MemberValue
	elseif self.MemberValue < self.LerpMemberValue then
		self.LerpMemberValue = math.Approach(self.LerpMemberValue, self.MemberValue, FrameTime() * 30)
	end

	if self.MemberValue < 0.1 and self:GetWide() ~= 0 then
		self:SetWide(0)
		self:GetParent():InvalidateLayout()
	elseif self.MemberValue > 0.1 and self:GetWide() == 0 then
		self:SetWide(BetterScreenScale() * 50)
		self:GetParent():InvalidateLayout()
	end
end

local texDownEdge = surface.GetTextureID("gui/gradient_down")
function PANEL:Paint(w, h)
	local value = self.LerpMemberValue
	if value <= 0 then return end

	local col = self:GetColor()
	local max = self.MemberMaxValue

	local y = 0

	y = y + draw.GetFontHeight("ZSBodyTextFont")
	h = h - y

	local boxsize = 42

	surface.SetDrawColor(col.r * 0.8, col.g * 0.8, col.b * 0.8, col.a * 0.75)
	surface.SetTexture(texDownEdge)
	surface.DrawTexturedRect(w/2 - boxsize/2, h/2 - boxsize/2, boxsize, boxsize)
	surface.SetDrawColor(col.r * 0.8, col.g * 0.8, col.b * 0.8, col.a * 0.3)
	surface.DrawRect(w/2 - boxsize/2, h/2 - boxsize/2, boxsize, boxsize)

	local perc = function(add) return math.Clamp((value - max * add) / (max * 0.25), 0, 1) end

	if self.Icon then
		surface.SetMaterial(self.Icon)
		surface.SetDrawColor(col.r * 0.6 + 100, col.g * 0.6 + 100, col.b * 0.6 + 100, col.a * 0.8)
		surface.DrawTexturedRect(w/2 - boxsize/2, h/2 - boxsize/2, boxsize, boxsize)
	end

	surface.SetDrawColor(col)
	surface.DrawRect(
		w/2 + boxsize/2,
		h/2 + boxsize/2 - (boxsize + 2) * perc(0.75),
		2,
		math.ceil((boxsize + 2) * perc(0.75))
	)
	surface.DrawRect(
		w/2 - boxsize/2,
		h/2 + boxsize/2,
		(boxsize + 2) * perc(0.5),
		2
	)
	surface.DrawRect(
		w/2 - boxsize/2 - 2,
		h/2 - boxsize/2,
		2,
		(boxsize + 2) * perc(0.25)
	)
	surface.DrawRect(
		w/2 + boxsize/2 + 2 - (boxsize + 4) * perc(0),
		h/2 - boxsize/2 - 2,
		math.ceil((boxsize + 2) * perc(0)),
		2
	)

	local t1 = math.ceil(value)
	draw.SimpleText(t1, "ZSHUDFontSmall", w / 2, y + h / 2 - boxsize/2 + 5, color_white_alpha230, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

vgui.Register("ZSStatus", PANEL, "Panel")
