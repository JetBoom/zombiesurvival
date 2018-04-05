local PANEL = {}

function PANEL:Init()
	self:DockMargin(0, 0, 0, 0)
	self:DockPadding(0, 0, 0, 0)

	self.HealthModel = vgui.Create("ZSHealthModelPanel", self)
	self.HealthModel:Dock(RIGHT)

	local contents = vgui.Create("Panel", self)
	contents:Dock(FILL)
	contents.Paint = ContentsPaint

	local poisonstatus = vgui.Create("ZSHealthStatus", contents)
	poisonstatus:SetTall(20)
	poisonstatus:SetAlpha(200)
	poisonstatus:SetColor(Color(180, 180, 0))
	poisonstatus:SetMemberName (translate.Get("pl_poison"))
	poisonstatus.GetMemberValue = function(me)
		local lp = LocalPlayer()
		if lp:IsValid() then
			return lp:GetPoisonDamage()
		end

		return 0
	end
	poisonstatus.MemberMaxValue = 50
	poisonstatus:Dock(TOP)

	local bleedstatus = vgui.Create("ZSHealthStatus", contents)
	bleedstatus:SetTall(20)
	bleedstatus:SetAlpha(200)
	bleedstatus:SetColor(Color(220, 0, 0))
	bleedstatus:SetMemberName (translate.Get("pl_bleed"))
	bleedstatus.GetMemberValue = function(me)
		local lp = LocalPlayer()
		if lp:IsValid() then
			return lp:GetBleedDamage()
		end

		return 0
	end
	bleedstatus.MemberMaxValue = 20
	bleedstatus:Dock(TOP)

	local ghoultouchstatus = vgui.Create("ZSHealthStatus", contents)
	ghoultouchstatus:SetTall(20)
	ghoultouchstatus:SetAlpha(200)
	ghoultouchstatus:SetColor(Color(255, 0, 0))
	ghoultouchstatus:SetMemberName (translate.Get("pl_ghtc"))
	ghoultouchstatus.GetMemberValue = function(me)
		local lp = LocalPlayer()
		if lp:IsValid() then
			local status = lp:GetStatus("ghoultouch")
			if status and status:IsValid() then
				return math.max(status.DieTime - CurTime(), 0)
			end
		end

		return 0
	end
	ghoultouchstatus.MemberMaxValue = 10
	ghoultouchstatus:Dock(TOP)

	self:ParentToHUD()
	self:InvalidateLayout()
end

function PANEL:PerformLayout()
	local screenscale = BetterScreenScale()

	self:SetSize(screenscale * 350, screenscale * 200)

	self.HealthModel:SetWide(self:GetTall())

	self:AlignLeft(screenscale * 24)
	self:AlignBottom(screenscale * 24)
end

function PANEL:Paint()
end

vgui.Register("ZSHealthArea", PANEL, "Panel")

local PANEL = {}

PANEL.ModelLow = 0
PANEL.ModelHigh = 72
PANEL.Health = 100
PANEL.BarricadeGhosting = 0

function PANEL:Init()
	self:SetAnimSpeed(0)
	self:SetFOV(55)
end

local function LowestAndHighest(ent)
	local lowest
	local highest

	local basepos = ent:GetPos()
	for i=0, ent:GetBoneCount() - 1 do
		local bonepos, boneang = ent:GetBonePosition(i)
		if bonepos and bonepos ~= basepos then
			if lowest == nil then
				lowest = bonepos.z
				highest = bonepos.z
			else
				lowest = math.min(lowest, bonepos.z)
				highest = math.max(highest, bonepos.z)
			end
		end
	end

	highest = (highest or 1) + ent:GetModelScale() * 8

	return lowest or 0, highest
end


function PANEL:OnRemove()
	if IsValid(self.Entity) then
		self.Entity:Remove()
	end
	if IsValid(self.OverrideEntity) then
		self.OverrideEntity:Remove()
	end
end



function PANEL:LayoutEntity(ent)
	self:RunAnimation()
end

vgui.Register("ZSHealthModelPanel", PANEL, "DModelPanel")

local PANEL = {}

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
end

function PANEL:Think()
	if self.GetMemberValue then
		self.MemberValue = self:GetMemberValue() or self.MemberValue
	end
	if self.GetMemberMaxValue then
		self.MemberMaxValue = self:GetMemberMaxValue() or self.MemberMaxValue
	end

	if self.MemberValue > self.LerpMemberValue then
		self.LerpMemberValue = self.MemberValue
	elseif self.MemberValue < self.LerpMemberValue then
		self.LerpMemberValue = math.Approach(self.LerpMemberValue, self.MemberValue, FrameTime() * 10)
	end
end

function PANEL:Paint()
	local value = self.LerpMemberValue
	if value <= 0 then return end

	local col = self:GetColor()
	local max = self.MemberMaxValue
	local w, h = self:GetSize()

	surface.SetDrawColor(0, 0, 0, 255)
	surface.DrawRect(0, 0, w, h)

	surface.SetDrawColor(col)
	surface.DrawOutlinedRect(0, 0, w, h)
	surface.DrawRect(3, 3, (w - 6) * math.Clamp(value / max, 0, 1), h - 6)

	local t1 = math.ceil(value)
	draw.SimpleText(t1, "ZSHUDFontTinyNS", w - 3, h / 2 + 1, color_black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	draw.SimpleText(t1, "ZSHUDFontTinyNS", w - 4, h / 2, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	draw.SimpleText(self.MemberName, "ZSHUDFontTinyNS", 5, h / 2 + 1, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	draw.SimpleText(self.MemberName, "ZSHUDFontTinyNS", 4, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

vgui.Register("ZSHealthStatus", PANEL, "Panel")