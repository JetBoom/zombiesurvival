local PANEL = {}

local colHealth = Color(0, 0, 0, 240)
local function ContentsPaint(self)
	local lp = LocalPlayer()
	if lp:IsValid() then
		local health = math.max(lp:Health(), 0)
		local healthperc = math.Clamp(health / lp:GetMaxHealthEx(), 0, 1)

		colHealth.r = (1 - healthperc) * 180
		colHealth.g = healthperc * 180

		draw.SimpleTextBlurry(health, "ZSHUDFont", 8, self:GetTall() - 8, colHealth, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	end
end

function PANEL:Init()
	self:DockMargin(0, 0, 0, 0)
	self:DockPadding(0, 0, 0, 0)

	self.HealthModel = vgui.Create("ZSHealthModelPanel", self)
	self.HealthModel:Dock(LEFT)

	local contents = vgui.Create("Panel", self)
	contents:Dock(FILL)
	contents.Paint = ContentsPaint

	local poisonstatus = vgui.Create("ZSHealthStatus", contents)
	poisonstatus:SetTall(20)
	poisonstatus:SetAlpha(200)
	poisonstatus:SetColor(Color(180, 180, 0))
	poisonstatus:SetMemberName("POISON!")
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
	bleedstatus:SetMemberName("BLEED!")
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
	ghoultouchstatus:SetMemberName("GHOUL TOUCH!")
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

	self:SetSize(screenscale * 350, screenscale * 128)

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

function PANEL:Think()
	local lp = LocalPlayer()
	if lp:IsValid() then
		self.Health = math.Clamp(lp:Health() / lp:GetMaxHealthEx(), 0, 1)
		self.BarricadeGhosting = math.Approach(self.BarricadeGhosting, lp:IsBarricadeGhosting() and 1 or 0, FrameTime() * 5)

		local model = lp:GetModel()
		local ent = self.Entity
		if not ent or not ent:IsValid() or model ~= ent:GetModel() then
			if IsValid(self.OverrideEntity) then
				self.OverrideEntity:Remove()
				self.OverrideEntity = nil
			end

			self:SetModel(model)
		end

		local overridemodel = lp.status_overridemodel
		if overridemodel and overridemodel:IsValid() then
			if IsValid(self.Entity) and not IsValid(self.OverrideEntity) then
				self.OverrideEntity = ClientsideModel(overridemodel:GetModel(), RENDER_GROUP_OPAQUE_ENTITY)
				if IsValid(self.OverrideEntity) then
					self.OverrideEntity:SetPos(self.Entity:GetPos())
					self.OverrideEntity:SetParent(self.Entity)
					self.OverrideEntity:AddEffects(bit.bor(EF_BONEMERGE, EF_BONEMERGE_FASTCULL))
					self.OverrideEntity:SetNoDraw(true)
				end
			end
		elseif self.OverrideEntity and self.OverrideEntity:IsValid() then
			self.OverrideEntity:Remove()
			self.OverrideEntity = nil
		end

		ent = self.Entity
		if ent and ent:IsValid() then
			ent:SetSequence(lp:GetSequence())

			ent:SetPoseParameter("move_x", lp:GetPoseParameter("move_x") * 2 - 1)
			ent:SetPoseParameter("move_y", lp:GetPoseParameter("move_y") * 2 - 1)
			ent:SetCycle(lp:GetCycle())

			local modellow, modelhigh = LowestAndHighest(ent)
			self.ModelLow = math.Approach(self.ModelLow, modellow, FrameTime() * 256)
			self.ModelHigh = math.Approach(self.ModelHigh, modelhigh, FrameTime() * 256)
			self.ModelHigh = math.max(self.ModelLow + 1, self.ModelHigh)
		end
	end
end

function PANEL:OnRemove()
	if IsValid(self.Entity) then
		self.Entity:Remove()
	end
	if IsValid(self.OverrideEntity) then
		self.OverrideEntity:Remove()
	end
end

local matWhite = Material("models/debug/debugwhite")
local matGlow = Material("sprites/glow04_noz")
local matShadow = CreateMaterial("zshealthhudshadow", "UnlitGeneric", {["$basetexture"] = "decals/simpleshadow", ["$vertexalpha"] = "1", ["$vertexcolor"] = "1"})
local colShadow = Color(20, 20, 20, 230)
function PANEL:Paint()
	local ent = self.OverrideEntity or self.Entity
	if not ent or not ent:IsValid() then return end

	local lp = LocalPlayer()
	if not lp:IsValid() then return end

	local x, y = self:LocalToScreen(0, 0)
	local w, h = self:GetSize()
	local health = self.Health
	local entpos = ent:GetPos()
	local mins, maxs = lp:OBBMins(), lp:OBBMaxs()
	maxs.z = maxs.x * 4.5
	local campos = mins:Distance(maxs) * Vector(0, -0.9, 0.4)
	local lookat = (mins + maxs) / 2
	local ang = (lookat - campos):Angle()
	local modelscale = lp:GetModelScale()
	if ent:GetModelScale() ~= modelscale then
		ent:SetModelScale(modelscale, 0)
	end

	self:LayoutEntity(ent)

	render.ModelMaterialOverride(matWhite)
	render.SuppressEngineLighting(true)
	cam.IgnoreZ(true)

	cam.Start3D(campos - ang:Forward() * 16, ang, self.fFOV * 0.75, x, y, w, h, 5, 4096)
		render.OverrideDepthEnable(true, false)
		render.SetColorModulation(0, 0, self.BarricadeGhosting)
		ent:DrawModel()
		render.OverrideDepthEnable(false)
	cam.End3D()

	cam.Start3D(campos, ang, self.fFOV, x, y, w, h, 5, 4096)

	render.SetMaterial(matShadow)
	render.DrawQuadEasy(entpos, Vector(0, 0, 1), 45, 90, colShadow)

	render.SetLightingOrigin(entpos)
	render.ResetModelLighting(0.2, 0.2, 0.2)
	render.SetModelLighting(BOX_FRONT, 0.8, 0.8, 0.8)
	render.SetModelLighting(BOX_TOP, 0.8, 0.8, 0.8)

	if health == 1 then
		render.SetColorModulation(0, 0.6, 0)
		ent:DrawModel()
	elseif health == 0 then
		render.SetColorModulation(0, 0, 0)
		ent:DrawModel()
	else
		local normal = Vector(0, 0, 1)
		local pos = entpos + Vector(0, 0, self.ModelLow * (1 - health) + self.ModelHigh * health)

		render.EnableClipping(true)

		render.PushCustomClipPlane(normal, normal:Dot(pos))
		render.SetColorModulation(health > 0.5 and 0.6 or (0.7 + math.sin(CurTime() * math.pi * 2) * 0.2), 0, 0)
		ent:DrawModel()
		render.PopCustomClipPlane()

		normal = normal * -1
		render.PushCustomClipPlane(normal, normal:Dot(pos))
		render.SetColorModulation(0, 0.6, 0)
		ent:DrawModel()
		render.PopCustomClipPlane()

		render.EnableClipping(false)
	end

	cam.End3D()

	render.ModelMaterialOverride()
	render.SuppressEngineLighting(false)
	render.SetColorModulation(1, 1, 1)
	cam.IgnoreZ(false)
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
