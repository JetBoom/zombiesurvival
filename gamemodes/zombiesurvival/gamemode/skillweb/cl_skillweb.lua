local draw_SimpleText = draw.SimpleText

local render_SetBlend = render.SetBlend
local render_DrawBeam = render.DrawBeam
local render_ModelMaterialOverride = render.ModelMaterialOverride
local render_SetColorModulation = render.SetColorModulation
local render_SuppressEngineLighting = render.SuppressEngineLighting

-- ============================================================
-- Single sorted list of skill IDs.
-- Built once, used by all net.Receive handlers.
-- Must be declared BEFORE the first net.Receive.
-- ============================================================
local SortedSkillIDs = nil
local function GetSortedSkillIDs()
	if SortedSkillIDs then return SortedSkillIDs end

	local ids = {}
	for skillid in pairs(GAMEMODE.Skills) do
		ids[#ids + 1] = skillid
	end
	table.sort(ids)

	SortedSkillIDs = ids
	return ids
end

hook.Add("OnReloaded", "ZS_SkillWeb_InvalidateSortedIDs", function()
	SortedSkillIDs = nil
end)

net.Receive("zs_skills_notify", function(length)
	if GAMEMODE.SkillWeb then
		GAMEMODE.SkillWeb:DisplayMessage(net.ReadString(), net.ReadBool() and COLOR_RED or COLOR_GREEN)
	end
end)

net.Receive("zs_skill_is_desired", function(length)
	local skillid = net.ReadUInt(16)
	local yesno = net.ReadBool()

	if MySelf:IsValid() then
		MySelf:SetSkillDesired(skillid, yesno)

		if GAMEMODE.SkillWeb and GAMEMODE.SkillWeb:IsValid() then
			surface.PlaySound("zombiesurvival/ui/misc" .. (yesno and 2 or 1) .. ".ogg")

			GAMEMODE.SkillWeb:UpdateQuickStats()
		end
	end
end)

net.Receive("zs_skill_is_unlocked", function(length)
	local skillid = net.ReadUInt(16)
	local yesno = net.ReadBool()

	if MySelf:IsValid() then
		MySelf:SetSkillUnlocked(skillid, yesno)
	end
end)

net.Receive("zs_skills_active", function(length)
	local t = {}

	local ids = GetSortedSkillIDs()

	for _, skillid in ipairs(ids) do
		if net.ReadBool() then
			t[skillid] = true
		end
	end

	if MySelf:IsValid() then
		MySelf:ApplySkills(t)
	end
end)

net.Receive("zs_skills_init", function(length)
	GAMEMODE.ReceivedInitialSkills = true

	local unlocked = {}
	local desired = {}
	local active = {}

	local ids = GetSortedSkillIDs()

	for _, skillid in ipairs(ids) do
		if net.ReadBool() then
			unlocked[skillid] = true
		end
	end

	for _, skillid in ipairs(ids) do
		if net.ReadBool() then
			desired[skillid] = true
		end
	end

	if net.ReadBool() then
		for _, skillid in ipairs(ids) do
			if net.ReadBool() then
				active[skillid] = true
			end
		end
	end

	if MySelf:IsValid() then
		MySelf:SetUnlockedSkills(unlocked)
		MySelf:SetDesiredActiveSkills(desired)
		MySelf:ApplySkills(active)
	end
end)

net.Receive("zs_skills_desired", function(length)
	local t = {}

	local ids = GetSortedSkillIDs()

	for _, skillid in ipairs(ids) do
		if net.ReadBool() then
			t[skillid] = true
		end
	end

	if MySelf:IsValid() then
		MySelf:SetDesiredActiveSkills(t)
	end

	if GAMEMODE.SkillWeb and GAMEMODE.SkillWeb:IsValid() then
		GAMEMODE.SkillWeb:UpdateQuickStats()
	end
end)

net.Receive("zs_skills_unlocked", function(length)
	local t = {}

	local ids = GetSortedSkillIDs()

	for _, skillid in ipairs(ids) do
		if net.ReadBool() then
			t[skillid] = true
		end
	end

	if MySelf:IsValid() then
		MySelf:SetUnlockedSkills(t)
	end
end)

net.Receive("zs_skills_nextreset", function(length)
	GAMEMODE.NextSkillReset = net.ReadUInt(32)

	if GAMEMODE.SkillWeb and GAMEMODE.SkillWeb:IsValid() then
		local days = math.floor(GAMEMODE.NextSkillReset / 86400)
		local btn = GAMEMODE.SkillWeb.Reset

		btn:SetText(GAMEMODE.NextSkillReset <= 0 and translate.Get("skillweb_reset_button") or translate.Format("skillweb_reset_days_left", days))
		btn:SetDisabled(GAMEMODE.NextSkillReset > 0)
	end
end)

GM.SavedSkillLoadouts = {}
hook.Add("Initialize", "LoadSkillLoadouts", function()
	if file.Exists(GAMEMODE.SkillLoadoutsFile, "DATA") then
		GAMEMODE.SavedSkillLoadouts = Deserialize(file.Read(GAMEMODE.SkillLoadoutsFile)) or {}
	end
end)

local function UpdateDropDown(dropdown)
	dropdown:Clear()

	for i, cart in ipairs(GAMEMODE.SavedSkillLoadouts) do
		dropdown:AddChoice(cart[1])
	end
end

local function SaveSkillLoadout(name)
	for i, cart in ipairs(GAMEMODE.SavedSkillLoadouts) do
		if string.lower(cart[1]) == string.lower(name) then
			cart[1] = name
			cart[2] = MySelf:GetDesiredActiveSkills()

			file.Write(GAMEMODE.SkillLoadoutsFile, Serialize(GAMEMODE.SavedSkillLoadouts))
			return
		end
	end

	GAMEMODE.SavedSkillLoadouts[#GAMEMODE.SavedSkillLoadouts + 1] = {name, MySelf:GetDesiredActiveSkills()}
	file.Write(GAMEMODE.SkillLoadoutsFile, Serialize(GAMEMODE.SavedSkillLoadouts))
end

-- For getting the positions of skill webs. See skillwebgrid.png
-- The file is not used in the gamemode so feel free to edit it.
function GM:GenerateFromSkillWebGrid()
	local mat = Material("zombiesurvival/skillwebgrid.png")
	local w, h = mat:Width(), mat:Height()
	local prelines = {}
	local lines = {}
	local col

	for y = 1, h do
		for x = 1, w do
			col = mat:GetColor(x - 1, y - 1)
			if col.r ~= 255 or col.g ~= 255 or col.b ~= 255 then
				local id = col.r + col.g * 255 + col.b * 65052
				local lx, ly = math.ceil(x - w / 2), math.floor(y - h / 2)

				if lines[id] then
					print(string.format("-- WARNING: Skill ID %d already exists (pixel %d, %d)", id, x, y))
				end

				prelines[id] = string.format("SKILL_%d = %d",
					id,
					id
				)
				lines[id] =	string.format(
					"GM:AddSkill(SKILL_%d, \"\", \"\",\n%s%d,%s%d,%s{})",
					id,
					string.rep("\t", 16),
					lx,
					string.rep("\t", 3),
					ly,
					string.rep("\t", 3)
				)
			end
		end
	end

	print(table.concat(prelines, "\n"))
	print("")
	print(table.concat(lines, "\n"))
end

local LABEL_WRAP_WIDTH  = 440
local LABEL_MAX_LINES   = 3 

local hoveredskill

-- ============================================================
-- Adaptive line height for node labels.
--
-- Logic:
--   1. Measure actual line height via ZS_MeasureMixedText,
--      which already accounts for the fact that some lines are
--      drawn with the base font (Ghoulish Fright AOE) and some
--      with a twin font (Tahoma etc.).
--   2. Detect which scripts are present in the text and pick
--      the appropriate multipliers. CJK glyphs are square and
--      need almost the full em-box; Latin GFA is narrow and
--      needs ~0.6; Cyrillic Tahoma is slightly taller than Latin.
--   3. Take the largest multiplier from the mixed text so that
--      CJK glyphs don't overlap.
-- ============================================================

-- Codepoint ranges by script. Rough but covers all locales
-- for which ZS has translations (or which are reasonable to add).
local SCRIPT_RANGES = {
    latin      = {{0x0041,0x005A},{0x0061,0x007A},{0x00C0,0x024F}},
    cyrillic   = {{0x0400,0x04FF},{0x0500,0x052F}},
    greek      = {{0x0370,0x03FF},{0x1F00,0x1FFF}},
    armenian   = {{0x0530,0x058F}},
    georgian   = {{0x10A0,0x10FF},{0x2D00,0x2D2D}},
    hebrew     = {{0x0590,0x05FF}},
    arabic     = {{0x0600,0x06FF},{0x0750,0x077F},{0xFB50,0xFDFF},{0xFE70,0xFEFF}},
    devanagari = {{0x0900,0x097F}},
    thai       = {{0x0E00,0x0E7F}},
    kana       = {{0x3040,0x309F},{0x30A0,0x30FF}},
    hangul     = {{0xAC00,0xD7AF},{0x1100,0x11FF},{0x3130,0x318F}},
    cjk        = {{0x3400,0x4DBF},{0x4E00,0x9FFF},{0xF900,0xFAFF},{0x20000,0x2A6DF}},
}

-- Multiplier against measured height. Lower value = tighter
-- lines. Values picked empirically for standard fonts
-- Tahoma / Segoe UI / YaHei / SimHei and the decorative GFA.
local SCRIPT_MUL = {
    latin      = 0.62,
    cyrillic   = 0.68,
    greek      = 0.68,
    armenian   = 0.68,
    georgian   = 0.68,
    hebrew     = 0.72,
    arabic     = 0.78,
    devanagari = 0.85,
    thai       = 0.85,
    kana       = 0.92,
    hangul     = 0.92,
    cjk        = 0.92,
    default    = 0.70,   -- fallback for unknown scripts
}

local function CodeInRanges(code, ranges)
    for _, r in ipairs(ranges) do
        if code >= r[1] and code <= r[2] then return true end
    end
    return false
end

local function DetectScript(code)
    for name, ranges in pairs(SCRIPT_RANGES) do
        if CodeInRanges(code, ranges) then return name end
    end
    return nil
end

-- Returns the largest multiplier across all scripts in the text.
-- If nothing is recognized — SCRIPT_MUL.default.
local function PickScriptMul(lines)
    local bestMul = 0

    for _, line in ipairs(lines) do
        local ok = pcall(function()
            for _, code in utf8.codes(line) do
                local script = DetectScript(code)
                if script then
                    local mul = SCRIPT_MUL[script] or SCRIPT_MUL.default
                    if mul > bestMul then bestMul = mul end
                end
            end
        end)
        -- Ignore utf8 errors — they are not critical.
    end

    return bestMul > 0 and bestMul or SCRIPT_MUL.default
end

local LineHeightCache = {}
local LineHeightCacheCount = 0
local LH_CACHE_MAX = 256
local function ComputeLineHeight(lines, font)
    if not lines or #lines == 0 then return 1 end

    -- Cache by (first line + line count + font).
    local key = (lines[1] or "") .. "\1" .. #lines .. "\1" .. (font or "")
    local cached = LineHeightCache[key]
    if cached then return cached end

    -- 1. Actual max height across all lines.
    local maxH = 0
    for _, line in ipairs(lines) do
        local _, h
        if ZS_MeasureMixedText then
            _, h = ZS_MeasureMixedText(line, font)
        end
        if not h or h <= 0 then
            surface.SetFont(font)
            _, h = surface.GetTextSize(line)
        end
        maxH = math.max(maxH, h or 0)
    end
    if maxH <= 0 then maxH = draw.GetFontHeight(font) end

    -- 2. Script multiplier.
    local mul = PickScriptMul(lines)

    -- 3. Very long blocks (5+ lines) visually "stick together" more
    --    than short ones — tighten slightly. Don't do this for CJK:
    --    there the gap is already at the minimum.
    if #lines >= 5 and mul < 0.85 then
        mul = mul - 0.02
    end

    local result = math.max(1, math.floor(maxH * mul))

    if LineHeightCacheCount >= LH_CACHE_MAX then
        LineHeightCache = {}
        LineHeightCacheCount = 0
    end
    LineHeightCache[key] = result
    LineHeightCacheCount = LineHeightCacheCount + 1

    return result
end

local REMORT_SKILL = {Name = "skill_remort_name", Description = "skill_remort_desc"}

-- Scrolling button. A DLabelAutoScroll is created inside the DButton,
-- filling the whole button area. The button's own text is cleared
-- so the engine doesn't draw a duplicate on top of the label.
local function ScrollingButton(parent, text, font, scrollMode)
    local btn = vgui.Create("DButton", parent)
    btn:SetText("")

    btn.ScrollText      = text or ""
    btn.ScrollFont      = font or "ZSHUDFontSmallest"
    btn.ScrollMode      = scrollMode or "time"
    btn.ScrollTimeStart = RealTime()

    local basePaint = btn.Paint
    btn.Paint = function(me, w, h)
        if basePaint then basePaint(me, w, h) end

        local txt = me.ScrollText
        if not txt or txt == "" then return end

        local f = me.ScrollFont
        if type(f) ~= "string" then f = "ZSHUDFontSmallest" end

        local col
        if me:GetDisabled() then
            col = COLOR_DARKGRAY
        elseif me:IsDown() then
            col = COLOR_WHITE
        elseif me:IsHovered() then
            col = COLOR_WHITE
        else
            col = COLOR_GRAY
        end

        local tw
        if ZS_MeasureMixedText then
            tw = ZS_MeasureMixedText(txt, f)
        else
            surface.SetFont(f)
            tw = surface.GetTextSize(txt)
        end

        if tw <= w - 4 or me.ScrollMode ~= "time" then
            draw.SimpleText(txt, f, w * 0.5, h * 0.5, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            return
        end

        local travel     = tw - (w - 4)
        local speed      = 40
        local pause      = 1.2
        local scrollTime = travel / speed
        local cycle      = (scrollTime + pause) * 2
        local t          = (RealTime() - me.ScrollTimeStart) % cycle

        local frac
        if t < pause then
            frac = 0
        elseif t < pause + scrollTime then
            frac = (t - pause) / scrollTime
        elseif t < pause + scrollTime + pause then
            frac = 1
        else
            frac = 1 - (t - pause - scrollTime - pause) / scrollTime
        end

        local x = 2 - travel * frac
        local sx, sy = me:LocalToScreen(0, 0)
        render.SetScissorRect(sx + 2, sy, sx + w - 2, sy + h, true)
            draw.SimpleText(txt, f, x, h * 0.5, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        render.SetScissorRect(0, 0, 0, 0, false)
    end

    btn.SetText = function(me, t)
        me.ScrollText      = tostring(t or "")
        me.ScrollTimeStart = RealTime()
    end
    btn.GetText = function(me)
        return me.ScrollText or ""
    end
    btn.SetFont = function(me, f)
        me.ScrollFont = f or "ZSHUDFontSmallest"
    end
    btn.GetFont = function(me)
        return me.ScrollFont or "ZSHUDFontSmallest"
    end

    return btn
end

local PANEL = {}

AccessorFunc( PANEL, "vCamPos",			"CamPos" )
AccessorFunc( PANEL, "fFOV",			"FOV" )
AccessorFunc( PANEL, "vLookatPos",		"LookAt" )
AccessorFunc( PANEL, "aLookAngle",		"LookAng" )
AccessorFunc( PANEL, "colAmbientLight",	"AmbientLight" )

PANEL.CreationTime = 0
PANEL.DesiredZoom = 5000
PANEL.ZoomChange = 0
PANEL.DesiredTree = 0
PANEL.ShadeAlpha = 0
PANEL.ShadeVelocity = 0

local offsets = {
	[TREE_HEALTHTREE] = {0, 16},
	[TREE_SPEEDTREE] = {0, -12},
	[TREE_GUNTREE] = {13, -7},
	[TREE_MELEETREE] = {13, 8},
	[TREE_BUILDINGTREE] = {-14, 8},
	[TREE_SUPPORTTREE] = {-13, -7}
}

function PANEL:Init()
	local allskills = GAMEMODE.Skills
	local node

	self.LastPaint = RealTime()
	self.DirectionalLight = {}
	self.FarZ = 32000

	self:SetCamPos( Vector( 15000, 0, 0 ) )
	self:SetLookAt( Vector( 0, 0, 0 ) )
	self:SetFOV(6)

	self:SetAmbientLight( Color( 50, 50, 50 ) )

	self:SetDirectionalLight( BOX_TOP, color_white )
	self:SetDirectionalLight( BOX_FRONT, color_white )

	self.SkillNodes = {}
	for id, skill in pairs(allskills) do
		if not skill.Trinket then
			node = ClientsideModel("models/dav0r/hoverball.mdl", RENDER_GROUP_OPAQUE_ENTITY)
			if IsValid(node) then
				node:SetNoDraw(true)
				node:SetPos(Vector(0, (skill.x + offsets[skill.Tree][1]) * 20, (skill.y + offsets[skill.Tree][2]) * 20))
				if skill.Disabled then
					node:SetModelScale(0.46, 0)
				else
					node:SetModelScale(0.66, 0)
				end

				node.Skill = skill
				node.SkillID = id
				self.SkillNodes[id] = node
			end
		end
	end

	-- Create the special remort node
	node = ClientsideModel("models/Gibs/HGIBS.mdl", RENDER_GROUP_OPAQUE_ENTITY)
	if IsValid(node) then
		node:SetNoDraw(true)
		node:SetPos(Vector(0, 0, 10))
		node:SetModelScale(1.5, 0)

		node.Skill = REMORT_SKILL
		node.SkillID = -1
		self.SkillNodes[-1] = node
	end

	local top = vgui.Create("Panel", self)
	top:SetSize(ScrW(), 256)
	top:SetMouseInputEnabled(false)

	local skillname = vgui.Create("DLabel", top)
	skillname:SetFont("ZSHUDFont")
	skillname:SetTextColor(COLOR_WHITE)
	skillname:SetContentAlignment(8)
	skillname:Dock(TOP)

	local desc = {}
	for i=1, 5 do
		local skilldesc = vgui.Create("DLabel", top)
		skilldesc:SetFont("ZSHUDFontSmall")
		skilldesc:SetTextColor(COLOR_GRAY)
		skilldesc:SetContentAlignment(8)
		skilldesc:Dock(TOP)
		table.insert(desc, skilldesc)
	end

	local screenscale = BetterScreenScale()

	local bottomleft = vgui.Create("DEXRoundedPanel", self)
	bottomleft:DockPadding(10, 10, 10, 10)
	bottomleft:SetSize(190 * screenscale, 130 * screenscale)

	local bottomleftup = vgui.Create("DEXRoundedPanel", self)
	bottomleftup:DockPadding(10, 10, 10, 10)
	bottomleftup:SetSize(190 * screenscale, 120 * screenscale)

	local quickFont = "ZSHUDFontSmaller"
	local quickRowH = draw.GetFontHeight(quickFont) + 2
	local quickstats = {}
	for i=1,3 do
		local hpstat = vgui.Create("DLabelAutoScroll", bottomleftup)
		hpstat:SetFont(quickFont)
		hpstat:SetTextColor(COLOR_WHITE)
		hpstat:SetContentAlignment(8)
		hpstat:SetScrollingMode("time")
		hpstat:SetTall(quickRowH)
		hpstat:Dock(TOP)
		hpstat:SetText("---")
		table.insert(quickstats, hpstat)
	end

	local dropdown = vgui.Create("DComboBox", bottomleft)
	dropdown:Dock(TOP)
	dropdown:SetMouseInputEnabled(true)
	StyleZSComboBox(dropdown)

	local delbtn = ScrollingButton(bottomleft, translate.Get("skillweb_delete_button"), "ZSHUDFontSmallest", "time")
	delbtn:SetTall(bottomleft:GetTall() / 5)
	delbtn:Dock(BOTTOM)
	delbtn.DoClick = function(me)
		surface.PlaySound("zombiesurvival/ui/misc1.ogg")

		local delloadout
		for k, v in pairs(GAMEMODE.SavedSkillLoadouts) do
			if v[1] == dropdown:GetSelected() then
				delloadout = k
				break
			end
		end

		if not delloadout then return end

		table.remove(GAMEMODE.SavedSkillLoadouts, delloadout)
		file.Write(GAMEMODE.SkillLoadoutsFile, Serialize(GAMEMODE.SavedSkillLoadouts))
		surface.PlaySound("buttons/button19.wav")

		UpdateDropDown(dropdown)
	end

	local savebtn = ScrollingButton(bottomleft, translate.Get("skillweb_save_button"), "ZSHUDFontSmallest", "time")
	savebtn:SetTall(bottomleft:GetTall() / 5)
	savebtn:Dock(BOTTOM)
	savebtn.DoClick = function(me)
		surface.PlaySound("zombiesurvival/ui/misc1.ogg")

		local function RestoreSkillWebPopup()
			if IsValid(self) then
				self:MakePopup()
			end
		end

		local frame = Derma_StringRequest(translate.Get("skillweb_save_loadout_title"), translate.Get("skillweb_save_loadout_prompt"), translate.Get("skillweb_save_loadout_default"),
		function(strTextOut)
			SaveSkillLoadout(strTextOut)
			UpdateDropDown(dropdown)

			self:DisplayMessage(translate.Format("skillweb_loadout_saved", strTextOut), COLOR_GREEN)
			RestoreSkillWebPopup()
		end,
		function(strTextOut)
			RestoreSkillWebPopup()
		end,
		translate.Get("skillweb_ok_button"), translate.Get("skillweb_cancel_button"))

		frame:GetChildren()[5]:GetChildren()[2]:SetTextColor(Color(30, 30, 30))

		local oldRemove = frame.OnRemove
		frame.OnRemove = function(me2, ...)
			if oldRemove then oldRemove(me2, ...) end

			timer.Simple(0, RestoreSkillWebPopup)
		end
	end

	UpdateDropDown(dropdown)

	local loadbtn = ScrollingButton(bottomleft, translate.Get("skillweb_load_button"), "ZSHUDFontSmallest", "time")
	loadbtn:SetTall(bottomleft:GetTall() / 5)
	loadbtn:Dock(BOTTOM)
	loadbtn.DoClick = function(me)
		surface.PlaySound("zombiesurvival/ui/misc1.ogg")

		local newloadout, nlname
		for _, v in pairs(GAMEMODE.SavedSkillLoadouts) do
			if v[1] == dropdown:GetSelected() then
				newloadout = v[2]
				nlname = v[1]
				break
			end
		end

		if not newloadout then return end

		net.Start("zs_skill_set_desired")
			net.WriteTable(newloadout)
		net.SendToServer()

		self:DisplayMessage(translate.Format("skillweb_loadout_loaded", nlname), COLOR_GREEN)
	end

	local bottomlefttop = vgui.Create("DEXRoundedPanel", self)
	bottomlefttop:DockPadding(8, 8, 8, 8)
	bottomlefttop:SetSize(160 * screenscale, 130 * screenscale)

	local smallRowH = draw.GetFontHeight("ZSHUDFontSmallest") + 8
	local resetRowH = draw.GetFontHeight("ZSHUDFontSmaller") + 8

	local activateall = ScrollingButton(bottomlefttop, translate.Get("skillweb_activate_all"), "ZSHUDFontSmallest", "time")
	activateall:Dock(TOP)
	activateall:SetTall(smallRowH)
	activateall.DoClick = function(me)
		surface.PlaySound("zombiesurvival/ui/misc1.ogg")

		if #MySelf:GetUnlockedSkills() == 0 then
			self:DisplayMessage(translate.Get("skillweb_no_skills_activate"), COLOR_RED)
		else
			self:DisplayMessage(translate.Get("skillweb_all_activated"), COLOR_GREEN)
		end

		net.Start("zs_skills_all_desired")
			net.WriteBool(true)
		net.SendToServer()
	end

	local deactivateall = ScrollingButton(bottomlefttop, translate.Get("skillweb_deactivate_all"), "ZSHUDFontSmallest", "time")
	deactivateall:DockMargin(0, 4, 0, 0)
	deactivateall:Dock(TOP)
	deactivateall:SetTall(smallRowH)
	deactivateall.DoClick = function(me)
		surface.PlaySound("zombiesurvival/ui/misc1.ogg")

		if #MySelf:GetUnlockedSkills() == 0 then
			self:DisplayMessage(translate.Get("skillweb_no_skills_deactivate"), COLOR_RED)
		else
			self:DisplayMessage(translate.Get("skillweb_all_deactivated"), COLOR_RED)
		end

		net.Start("zs_skills_all_desired")
			net.WriteBool(false)
		net.SendToServer()
	end

	local resettime = GAMEMODE.NextSkillReset or 0
	local days = math.floor(resettime / 86400)

	local reset = ScrollingButton(bottomlefttop, resettime <= 0 and translate.Get("skillweb_reset_button") or translate.Format("skillweb_reset_days_left", days), "ZSHUDFontSmaller", "time")
	reset:DockMargin(0, 4, 0, 0)
	reset:Dock(TOP)
	reset:SetTall(resetRowH)
	reset:SetDisabled(resettime > 0)
	reset.DoClick = function(me)
		Derma_Query(
			translate.Get("skillweb_reset_query"),
			translate.Get("skillweb_warning_title"),
			translate.Get("skillweb_ok_button"),
			function() net.Start("zs_skills_reset") net.SendToServer() end,
			translate.Get("skillweb_cancel_button"),
			function() end
		)
	end

	local topright = vgui.Create("DEXRoundedPanel", self)
	topright:SetSize(160 * screenscale, 64 * screenscale)
	topright:DockPadding(10, 10, 10, 10)

	local quit = ScrollingButton(topright, translate.Get("skillweb_quit"), "ZSHUDFont", "time")
	quit:Dock(FILL)
	quit.DoClick = function()
		self:Remove()
	end

	local bottom = vgui.Create("DEXRoundedPanel", self)
	bottom:SetSize(600 * screenscale, math.Clamp(84 * screenscale, 70, 125))
	bottom:DockPadding(10, 10, 10, 10)

	local spremaining = vgui.Create("DLabelAutoScroll", bottom)
	spremaining:SetFont("ZSHUDFontSmall")
	spremaining:SetTextColor(COLOR_GRAY)
	spremaining:SetContentAlignment(5)
	spremaining:SetScrollingMode("time")
	spremaining:SetTall(draw.GetFontHeight("ZSHUDFontSmall") + 2)
	spremaining:Dock(TOP)
	spremaining.m_LastValue = nil
	spremaining.Think = function(me)
		local val = translate.Format("skillweb_sp_remaining", MySelf:GetZSSPRemaining())
		if me.m_LastValue ~= val then
			me.m_LastValue = val
			me:SetText(val)
			if MySelf:GetZSSPRemaining() >= 1 then
				me:SetTextColor(COLOR_GRAY)
			else
				me:SetTextColor(COLOR_RED)
			end
		end
	end

	local expbar = vgui.Create("Panel", bottom)
	expbar.Paint = function(me, w, h)
		GAMEMODE:DrawXPBar(0, 2 - screenscale * 2, w, h, w, 1, 0.95, MySelf:GetZSLevel())
	end
	expbar:SetContentAlignment(5)
	expbar:Dock(BOTTOM)

	local contextmenu = vgui.Create("Panel", self)
	contextmenu:SetVisible(false)

	local button = vgui.Create("DButton", contextmenu)
	button:SetFont("ZSHUDFontSmall")
	button:SetDisabled(false)
	button.DoClick = function(me)
		local skillid = contextmenu.SkillID
		local name = allskills[skillid].Name
		if MySelf:IsSkillDesired(skillid) then
			net.Start("zs_skill_is_desired")
				net.WriteUInt(skillid, 16)
				net.WriteBool(false)
			net.SendToServer()

			self:DisplayMessage(translate.Format("skillweb_deactivated_x", name))
		elseif MySelf:IsSkillUnlocked(skillid) then
			net.Start("zs_skill_is_desired")
				net.WriteUInt(skillid, 16)
				net.WriteBool(true)
			net.SendToServer()

			self:DisplayMessage(translate.Format("skillweb_activated_x", name), COLOR_DARKGREEN)
		else
			net.Start("zs_skill_is_unlocked")
				net.WriteUInt(skillid, 16)
				net.WriteBool(true)
			net.SendToServer()

			self:DisplayMessage(translate.Format("skillweb_unlocked_activated_x", name), COLOR_GREEN)
		end

		contextmenu:SetVisible(false)
	end
	contextmenu.Button = button

	local messagebox = vgui.Create("Panel", self)
	messagebox:SetSize(850 * screenscale, 48)
	messagebox.Paint = function(me, w, h)
		PaintGenericFrame(me, 0, 0, w, h, 16)
	end
	messagebox:SetKeyboardInputEnabled(false)
	messagebox:SetMouseInputEnabled(false)
	messagebox:SetZPos(-100)
	local messagetext = vgui.Create("DLabel", messagebox)
	messagetext:SetTextColor(COLOR_GRAY)
	messagetext:SetText("")
	messagetext:SetFont("ZSHUDFontSmall")
	messagetext:SetContentAlignment(5)
	messagetext:Dock(FILL)
	messagetext:SetKeyboardInputEnabled(false)
	messagetext:SetMouseInputEnabled(false)
	messagetext:SetZPos(-200)
	messagebox:SetVisible(false)

	local warningtext = vgui.Create("DLabel", self)
	warningtext:SetTextColor(COLOR_RED)
	warningtext:SetFont("ZSHUDFontSmall")
	warningtext:SetText(translate.Get("skillweb_changes_warning"))
	warningtext:SizeToContents()
	warningtext:SetKeyboardInputEnabled(false)
	warningtext:SetMouseInputEnabled(false)

	self:GenerateParticles()

	self.Top = top
	self.BottomLeft = bottomleft
	self.BottomLeftTop = bottomlefttop
	self.BottomLeftUp = bottomleftup
	self.QuickStats = quickstats
	self.Bottom = bottom
	self.TopRight = topright
	self.SkillName = skillname
	self.SkillDesc = desc
	self.ContextMenu = contextmenu
	self.MessageBox = messagebox
	self.MessageText = messagetext
	self.WarningText = warningtext
	self.LoadoutsDrop = dropdown
	self.Reset = reset

	top:SetAlpha(0)

	self.AmbientSound = CreateSound(MySelf, "zombiesurvival/skilltree_ambiance.ogg")
	self.AmbientSound:PlayEx(0, 60)
	self.AmbientSound:ChangeVolume(0, 0)
	self.AmbientSound:ChangeVolume(0.66, 1.5)

	self:DockMargin(0, 0, 0, 0)
	self:DockPadding(0, 0, 0, 0)
	self:Dock(FILL)

	self:InvalidateLayout()

	self.CreationTime = RealTime()

	self:MakePopup()
	self:SetMouseInputEnabled(true)
	self:SetKeyboardInputEnabled(false)

	self:UpdateQuickStats()

	self:SizeContextMenu(translate.Get("skillweb_context_activate"))
	net.Start("zs_skills_refunded")
	net.SendToServer()
end

local QUICKSTAT_KEYS = {
	"skillweb_quickstat_health",
	"skillweb_quickstat_speed",
	"skillweb_quickstat_worth",
}

function PANEL:UpdateQuickStats()
	local skillmodifiers = {}
	local gm_modifiers = GAMEMODE.SkillModifiers
	for skillid in pairs(table.ToAssoc(MySelf:GetDesiredActiveSkills())) do
		local modifiers = gm_modifiers[skillid]
		if modifiers then
			for modid, amount in pairs(modifiers) do
				skillmodifiers[modid] = (skillmodifiers[modid] or 0) + amount
			end
		end
	end

	for i=1,3 do
		local prefix = translate.Get(QUICKSTAT_KEYS[i])
		local val = i == 2 and SPEED_NORMAL or 100
		self.QuickStats[i]:SetText(translate.Format("skillweb_quickstat_format", prefix, val + (skillmodifiers[i] or 0)))
	end
end

function PANEL:DisplayMessage(msg, col)
	self.MessageText:SetText(msg)
	self.MessageText:SetTextColor(col or COLOR_GRAY)

	self.MessageBox:SetVisible(true)

	timer.Create("SKillWebMessageRemove", 4, 1, function() if self:IsValid() then self.MessageBox:SetVisible(false) end end)
end

function PANEL:SizeContextMenu(text)
	local cm = self.ContextMenu
	local btn = cm and cm.Button
	if not (cm and cm:IsValid() and btn and btn:IsValid()) then return end

	local screenscale = BetterScreenScale()

	btn:SetWrap(false)
	btn:SetAutoStretchVertical(false)
	btn:SetContentAlignment(5)

	btn:SetFont("ZSHUDFontSmall")
	btn:SetText(text)

	local measureFont = btn:GetFont() or "ZSHUDFontSmall"

	local tw, th = 0, 0
	if ZS_MeasureMixedText then
		tw, th = ZS_MeasureMixedText(text, measureFont)
	end
	if not tw or tw <= 0 then
		surface.SetFont(measureFont)
		tw, th = surface.GetTextSize(text)
	end

	tw = tonumber(tw) or 0
	th = tonumber(th) or 0
	if tw <= 0 then tw = 100 end
	if th <= 0 then th = draw.GetFontHeight(measureFont) end

	local padW = 32 * screenscale
	local padH = 14 * screenscale

	local btnW = math.ceil(tw + padW)
	local btnH = math.ceil(th + padH)

	local minW = math.ceil(64 * screenscale)
	if btnW < minW then btnW = minW end

	cm:SetSize(btnW, btnH)
	btn:SetSize(btnW, btnH)
	btn:SetPos(0, 0)
	btn:InvalidateLayout(true)
end

PANEL.NextWarningThink = 0
function PANEL:Think()
	local time = RealTime()

	if self.AmbientSound and time >= self.CreationTime + 1 then
		self.AmbientSound:PlayEx(0.66, 60 + CurTime() % 0.1)
	end

	if time < self.NextWarningThink then return end
	self.NextWarningThink = time + 0.1

	local display_warning = false
	local desired = table.ToAssoc(MySelf:GetDesiredActiveSkills())
	local active  = MySelf:GetActiveSkills()

	for k in pairs(desired) do
		if not active[k] then
			display_warning = true
			break
		end
	end

	if not display_warning then
		for k in pairs(active) do
			if not desired[k] then
				display_warning = true
				break
			end
		end
	end

	if display_warning ~= self.WarningText:IsVisible() then
		self.WarningText:SetVisible(display_warning)
	end
end

function PANEL:GenerateParticles()
	local particles = {}
	local particle
	for i=1, 140 do
		-- struct: Position, Roll, Roll rate, Size, Alpha
		particle = {}
		particle[1] = Vector(math.Rand(-1524, -32), math.Rand(-610, 610), math.Rand(-610, 610))
		particle[2] = math.Rand(0, 360)
		particle[3] = math.Rand(-5, 5)
		particle[4] = math.Rand(180, 240)
		particle[5] = math.Rand(30, 90)
		particles[i] = particle
	end

	self.Particles = particles
end

function PANEL:GenerateSplines()
	if GAMEMODE.SkillsSplined then return end

	-- for skillid, skill in pairs(GAMEMODE.Skills) do
	-- 	if skill.Curves then
	-- 		skill.Splines = {}
	-- 		local pos_a = self.SkillNodes[1][skillid]:GetPos()
	-- 		pos_a.x = 0
	-- 		for connectid, curve in pairs(skill.Curves) do
	-- 			local cm
	-- 			local splines = {}
	-- 			local pos_b = self.SkillNodes[1][connectid]:GetPos()
	-- 			pos_b.x = 0
	--
	-- 			table.insert(splines, pos_a)
	-- 			for mu=0, 0.9, 0.1 do
	-- 				cm = CatmullInterpolate(pos_a, pos_a, curve * 20, pos_b, mu, 1)
	-- 				cm.x = -16
	-- 				table.insert(splines, cm)
	-- 			end
	-- 			for mu=0, 0.9, 0.1 do
	-- 				cm = CatmullInterpolate(pos_a, curve * 20, pos_b, pos_b, mu, 1)
	-- 				cm.x = -16
	-- 				table.insert(splines, cm)
	-- 			end
	-- 			table.insert(splines, pos_b)
	-- 			skill.Splines[connectid] = splines
	-- 		end
	-- 		skill.Curves = nil
	-- 	end
	-- end

	GAMEMODE.SkillsSplined = true
end

function PANEL:PerformLayout()
	local screenscale = BetterScreenScale()
	local gap = 10 * screenscale

	self.Top:AlignTop(8)
	self.Top:CenterHorizontal()

	self.BottomLeft:AlignLeft(gap)
	self.BottomLeft:AlignBottom(gap)

	self.BottomLeftUp:AlignLeft(gap)
	self.BottomLeftUp:AlignBottom(gap + self.BottomLeft:GetTall() + gap)

	self.BottomLeftTop:AlignLeft(gap + self.BottomLeft:GetWide() + gap)
	self.BottomLeftTop:AlignBottom(gap)

	self.Bottom:AlignBottom(gap)
	self.Bottom:CenterHorizontal()

	self.TopRight:AlignRight(gap)
	self.TopRight:AlignTop(gap)

	self.MessageBox:CenterHorizontal()
	self.MessageBox:AlignTop(ScrH() * 0.65)

	self.WarningText:AlignTop(32)
	self.WarningText:AlignLeft(32)
end

function PANEL:SetDirectionalLight(iDirection, color)
	self.DirectionalLight[iDirection] = color
end

local camera_velocity = Vector(0, 0, 0)
function PANEL:DoEdgeScroll(deltatime)
	if not system.HasFocus() then return end

	local mx, my = gui.MousePos()
	local edge = math.min(w, h) * 0.035
	local scrolldir = Vector(0, 0, 0)
	local campos = self.vCamPos

	if mx <= edge and mx >= 0 then
		scrolldir.y = scrolldir.y - 1
	elseif mx >= w - edge and mx <= w then
		scrolldir.y = scrolldir.y + 1
	end

	if my <= edge and my >= 0 then
		scrolldir.z = scrolldir.z + 1
	elseif my >= h - edge and my <= h then
		scrolldir.z = scrolldir.z - 1
	end

	scrolldir:Normalize()

	if scrolldir.y ~= 0 or scrolldir.z ~= 0 and self.ContextMenu and self.ContextMenu:IsVisible() then
		self.ContextMenu:SetVisible(false)
	end

	camera_velocity = LerpVector(deltatime * (scrolldir.y == 0 and scrolldir.z == 0 and 3 or 1), camera_velocity, scrolldir)

	if camera_velocity.y ~= 0 or camera_velocity.z ~= 0 then
		campos = campos + deltatime * edge * 12 * camera_velocity
		campos.y = math.Clamp(campos.y, -262, 262)
		campos.z = math.Clamp(campos.z, -262, 310)

		self:SetCamPos(campos)
		self.vLookatPos:Set(campos)
		self.vLookatPos.x = 0
	end
end

local nodecolors = {
	[TREE_HEALTHTREE] = {1.75, 3, 5},
	[TREE_SPEEDTREE] = {2, 2, 5},
	[TREE_SUPPORTTREE] = {3, 1.5, 6},
	[TREE_BUILDINGTREE] = {2, 6, 3},
	[TREE_MELEETREE] = {1.5, 7, 7},
	[TREE_GUNTREE] = {5, 2, 2}
}

local matBeam = Material("effects/laser1")
local matGlow = Material("sprites/glow04_noz")
local matSmoke = Material("particles/smokey")
local matWhite = Material("models/debug/debugwhite")
local colBeam = Color(0, 0, 0)
local colBeam2 = Color(255, 255, 255)
local colSmoke = Color(140, 160, 185, 160)
local colGlow = Color(0, 0, 0)
function PANEL:Paint(w, h)
	local realtime = RealTime()
	local lifetime = realtime - self.CreationTime
	local dt = realtime - self.LastPaint
	local can_remort = MySelf:CanSkillsRemort()
	local skillid, skill, nodepos, selected
	local col, connectskill, othernode, othernodepos
	local add, pos_a, pos_b, sat
	local size, desc, --[[curve, desired_curve]] ang
	--local dir = Vector(0, 0, 0)

	self:DoEdgeScroll(dt)

	local campos = self.vCamPos
	--campos.x = Lerp(math.min(lifetime * 0.1, (realtime - self.ZoomChange) * 4), campos.x, self.DesiredZoom)
	campos.x = math.Approach(campos.x, self.DesiredZoom, dt * 13500)
	self:SetCamPos(campos)

	surface.SetDrawColor(0, 0, 0, 252)
	surface.DrawRect(0, 0, w, h)

	ang = self.aLookAngle
	if not ang then
		ang = (self.vLookatPos - self.vCamPos):Angle()
	end
	local to_camera = ang:Forward() * -1
	--ang.roll = math.sin(realtime / 4) * 1.8

	local mx, my = gui.MousePos()
	local aimvector = util.AimVector(ang, self.fFOV, mx, my, w, h)
	local intersectpos = util.IntersectRayWithPlane(self.vCamPos, aimvector, self:GetLookAt(), Vector(-1, 0, 0))

	cam.Start3D( self.vCamPos, ang, self.fFOV, 0, 0, w, h, 5, self.FarZ )
	cam.IgnoreZ( true )

	render_SuppressEngineLighting( true )
	render.SetLightingOrigin( vector_origin )
	render.ResetModelLighting( self.colAmbientLight.r / 255, self.colAmbientLight.g / 255, self.colAmbientLight.b / 255 )

	for i=0, 6 do
		col = self.DirectionalLight[ i ]
		if col then
			render.SetModelLighting( i, col.r / 255, col.g / 255, col.b / 255 )
		end
	end

	local particles = self.Particles
	render.SetMaterial(matSmoke)
	for i = 1, #particles do
		local particle = particles[i]
		particle[2] = particle[2] + particle[3] * dt
		colSmoke.a = particle[5]
		render.DrawQuadEasy(particle[1], to_camera, particle[4], particle[4], colSmoke, particle[2])
	end

	local skillnodes = self.SkillNodes
	local campost = self.vCamPos
	local camheightadj = (campost.x ^ 2) * 1.0035 -- Don't render nodes outside our view.

	render.SetMaterial(matBeam)
	for id, node in pairs(skillnodes) do
		if IsValid(node) then
			nodepos = node:GetPos()

			if (nodepos - campost):LengthSqr() > camheightadj then
				continue
			end

			skill = node.Skill

			if skill.Disabled then
				continue
			end

			if skill.Connections then
				for connectid, _ in pairs(skill.Connections) do
					connectskill = GAMEMODE.Skills[connectid]
					if id < connectid and (not connectskillskill or connectskill and not connectskill.Disabled) then -- Nodes are double linked so only draw one half-edge
						othernode = skillnodes[connectid]
						if IsValid(othernode) then
							othernodepos = othernode:GetPos()
							local beamsize = 4
							if MySelf:IsSkillUnlocked(node.SkillID) or MySelf:IsSkillUnlocked(connectid) then
								colBeam.r = 32
								colBeam.g = 128
								colBeam.b = 255
							elseif MySelf:SkillCanUnlock(node.SkillID) or MySelf:SkillCanUnlock(connectid) then
								colBeam.r = 255
								colBeam.g = 192
								colBeam.b = 0
							else
								colBeam.r = 128
								colBeam.g = 40
								colBeam.b = 40

								beamsize = 2
							end

							if hoveredskill == node.SkillID or hoveredskill == connectid then
								add = math.abs(math.sin(realtime * math.pi)) * 120
								colBeam.r = math.min(colBeam.r + add, 255)
								colBeam.g = math.min(colBeam.g + add, 255)
								colBeam.b = math.min(colBeam.b + add, 255)

								colBeam.a = 180
								colBeam2.a = 255
							else
								colBeam.a = 110
								colBeam2.a = 190
							end

							pos_a = nodepos + Vector(-16, 0, 0)
							pos_b = othernodepos + Vector(-16, 0, 0)
							local splines = skill.Splines and skill.Splines[connectid]
							if splines then
								local numsplines = #splines
								render_StartBeam(#splines)
								for i, spline in ipairs(splines) do
									render.AddBeam(spline, 4, i / numsplines, colBeam2)
								end
								render_EndBeam()
								render_StartBeam(#splines)
								for i, spline in ipairs(splines) do
									render.AddBeam(spline, 12, i / numsplines, colBeam)
								end
								render_EndBeam()
							else
								render_DrawBeam(pos_a, pos_b, beamsize, 0, 1, colBeam2)
								render_DrawBeam(pos_a, pos_b, 16, 0, 1, colBeam)
							end
						end
					end
				end
			end
		end
	end

	local oldskill = hoveredskill
	hoveredskill = nil

	local angle = (realtime * 180) % 360

	for id, node in pairs(skillnodes) do
		if IsValid(node) then
			nodepos = node:GetPos()
			if (nodepos - campost):LengthSqr() > camheightadj then
				continue
			end

			skillid = node.SkillID
			skill = node.Skill
			selected = not skill.Disabled and intersectpos and nodepos:DistToSqr(intersectpos) <= 36 -- 6^2

			cam.Start3D2D(node:GetPos() - to_camera * 8, Angle(0, 90, 90), 0.09)
			surface.DisableClipping(true)
			DisableClipping(true)

			if selected then
				hoveredskill = skillid

				sat = 1 - math.abs(math.sin(realtime * math.pi)) * 0.25
			else
				sat = 1
			end

			local notunlockable = false
			local divs = nodecolors[skill.Tree]

			if skill.Disabled or (skillid == -1 and not can_remort) then
				render_SetColorModulation(sat / 6, sat / 6, sat / 6)
			elseif skillid == -1 then
				render_SetColorModulation(sat, sat, sat)
			elseif skillid < -1 then
				local tbl = particlecolors[-skillid - 1]

				render_SetColorModulation(tbl.r/255, tbl.g/255, tbl.b/255)
			elseif MySelf:IsSkillDesired(skillid) then
				render_SetColorModulation(sat / 4, sat / 4, sat / 2)
			elseif MySelf:IsSkillUnlocked(skillid) then
				render_SetColorModulation(sat, sat, sat)
			elseif MySelf:SkillCanUnlock(skillid) then
				render_SetColorModulation(sat, sat / 1.25, sat / 4)
			else
				render_SetColorModulation(sat / divs[1] / 1.25, sat / divs[2] / 1.25, sat / divs[3] / 1.25)
				notunlockable = true
			end

			render_ModelMaterialOverride(matWhite)
			render_SetBlend(0.95)

			node:DrawModel()

			render_SetBlend(1)
			render_ModelMaterialOverride()

			render_SetColorModulation(1, 1, 1)

			if self.DesiredZoom < 9500 then
				local colo = skill.Disabled and COLOR_DARKGRAY
					or selected and color_white
					or notunlockable and COLOR_MIDGRAY
					or COLOR_GRAY
				local font = skillid <= -1 and "ZS3D2DFont2Big" or "ZS3D2DFont2"
				local displayname = translate.SkillName(skillid, skill)

				-- WrapTextLines returns a table, but if displayname
				-- is nil or the function returns nil in some unhandled
				-- case — guard it, otherwise ipairs will error.
				local lines = displayname
					and string.WrapTextLines(
						displayname,
						font,
						LABEL_WRAP_WIDTH,
						selected and 99 or LABEL_MAX_LINES
					)
					or { "" }

				local lineH = ComputeLineHeight(lines, font)

				for i, line in ipairs(lines) do
					draw.DrawText(line, font, 0, (i - 1) * lineH, colo, TEXT_ALIGN_CENTER)
				end
			end

			DisableClipping(false)
			surface.DisableClipping(false)
			cam.End3D2D()

			render.SetMaterial(matGlow)
			if skillid == -1 then
				if can_remort then
					render.DrawQuadEasy(nodepos, to_camera, 32, 32, color_white, angle)
				end
			elseif not skill.Disabled then
				colGlow.r = sat * 255 colGlow.g = sat * 255 colGlow.b = sat * 255
				if MySelf:IsSkillDesired(skillid) then
					colGlow.r = colGlow.r / 4
					colGlow.g = colGlow.g / 4
				elseif not MySelf:IsSkillUnlocked(skillid) then
					if MySelf:SkillCanUnlock(skillid) then
						colGlow.g = colGlow.g / 1.5
						colGlow.b = 0
					else
						colGlow.r = colGlow.r / divs[1]
						colGlow.g = colGlow.g / divs[2]
						colGlow.b = colGlow.b / divs[3]
					end
				end
				size = selected and 40 or 27
				render.DrawQuadEasy(nodepos, to_camera, size, size, colGlow, angle)
				angle = angle + 45
			end
		end
	end

	if intersectpos then
		intersectpos = intersectpos + Vector(16, 0, 0)
		render.SetMaterial(matGlow)
		render.DrawQuadEasy(intersectpos, to_camera, 12, 12, color_white, realtime * 90)
	end

	render_SuppressEngineLighting(false)

	cam.IgnoreZ(false)
	cam.End3D()

	if oldskill ~= hoveredskill then
		self.Top:Stop()

		if hoveredskill then
			skill = hoveredskill < -1 and TREE_SKILLS[-hoveredskill - 1] or hoveredskill == -1 and REMORT_SKILL or GAMEMODE.Skills[hoveredskill]
			self.SkillName:SetText(translate.SkillName(hoveredskill, skill))
			self.SkillName:SizeToContents()

			desc = string.Explode("\n", translate.SkillDescription(hoveredskill, skill))
			local txt, colid
			for i=1, 5 do
				txt = desc[i] or " "
				if txt:sub(1, 1) == "^" then
					colid = tonumber(txt:sub(2, 2)) or 0
					txt = txt:sub(3)

					if colid == 1 then
						self.SkillDesc[i]:SetTextColor(COLOR_RED)
					elseif colid == 2 then
						self.SkillDesc[i]:SetTextColor(COLOR_GREEN)
					elseif colid == 3 then
						self.SkillDesc[i]:SetTextColor(COLOR_BLUE)
					elseif colid == 4 then
						self.SkillDesc[i]:SetTextColor(COLOR_YELLOW)
					elseif colid == 5 then
						self.SkillDesc[i]:SetTextColor(COLOR_PURPLE)
					else
						self.SkillDesc[i]:SetTextColor(COLOR_GRAY)
					end
				else
					self.SkillDesc[i]:SetTextColor(COLOR_GRAY)
				end
				self.SkillDesc[i]:SetText(txt)
				self.SkillDesc[i]:SizeToContents()
			end

			surface.PlaySound("zombiesurvival/ui/misc1.ogg")

			self.Top:SetAlpha(0)
			self.Top:AlphaTo(255, 0.15)
		else
			self.Top:AlphaTo(0, 0.15)
		end
	end

	self.LastPaint = realtime

	local fgalpha = 255 - lifetime * 100
	if fgalpha > 0 then
		surface.SetDrawColor(0, 0, 0, fgalpha)
		surface.DrawRect(0, 0, w, h)
	end

	return true
end

function PANEL:OnMousePressed(mc)
	if mc ~= MOUSE_LEFT then return end

	local contextmenu = self.ContextMenu
	if not hoveredskill then
		contextmenu:SetVisible(false)
		return
	end

	local mx, my = gui.MousePos()
	local can_remort = MySelf:CanSkillsRemort()
	local btnText

	if hoveredskill == -1 and can_remort then
		Derma_Query(
			translate.Format("skillweb_remort_query", GAMEMODE.RemortSkillPoints),
			translate.Get("skillweb_warning_title"),
			translate.Get("skillweb_ok_button"),
			function() net.Start("zs_skills_remort") net.SendToServer() end,
			translate.Get("skillweb_cancel_button"),
			function() end
		)
		return
	elseif hoveredskill == -1 then
		self:DisplayMessage(translate.Format("skillweb_need_level_x", GAMEMODE.MaxLevel), COLOR_RED)
		surface.PlaySound("buttons/button8.wav")
		return
	elseif MySelf:IsSkillDesired(hoveredskill) then
		local skill = GAMEMODE.Skills[hoveredskill]
		if skill and skill.AlwaysActive then
			self:DisplayMessage(translate.Get("skillweb_cant_deactivate"), COLOR_RED)
			surface.PlaySound("buttons/button8.wav")
			return
		end
		btnText = translate.Get("skillweb_context_deactivate")
	elseif MySelf:IsSkillUnlocked(hoveredskill) then
		btnText = translate.Get("skillweb_context_activate")
	elseif MySelf:SkillCanUnlock(hoveredskill) then
		if MySelf:GetZSSPRemaining() >= 1 then
			btnText = translate.Get("skillweb_context_unlock")
		else
			self:DisplayMessage(translate.Get("skillweb_need_sp_unlock"), COLOR_RED)
			surface.PlaySound("buttons/button8.wav")
			return
		end
	else
		self:DisplayMessage(translate.Get("skillweb_need_adjacent"), COLOR_RED)
		surface.PlaySound("buttons/button8.wav")
		return
	end

	self:SizeContextMenu(btnText)

	contextmenu.SkillID = hoveredskill
	contextmenu:SetPos(mx - contextmenu:GetWide() / 2, my - contextmenu:GetTall() / 2)
	contextmenu:SetVisible(true)
end

function PANEL:OnMouseWheeled(delta)
	self.DesiredZoom = math.Clamp(self.DesiredZoom - delta * 500, 2500, 25000)
end

function PANEL:OnRemove()
	for _, node in pairs(self.SkillNodes) do
		if IsValid(node) then
			node:Remove()
		end
	end

	local snd = self.AmbientSound
	snd:FadeOut(1.5)
	timer.Simple(1.5, function() if snd then snd:Stop() end end)
end

vgui.Register("ZSSkillWeb", PANEL, "Panel")

function GM:DrawXPBar(x, y, w, h, xpw, barwm, hm, level)
	local barw = xpw * barwm
	local xp = MySelf:GetZSXP()
	local progress = GAMEMODE:ProgressForXP(xp)
	local rlevel = MySelf:GetZSRemortLevel()
	local append = ""
	if rlevel > 0 then
		append = " // R.Level "..rlevel
	end

	surface.SetDrawColor(0, 0, 0, 220)
	surface.DrawRect(x, y, barw, 4)

	surface.SetDrawColor(10, 200, 10, 160)
	surface.DrawRect(x, y, barw * progress, 2)
	surface.SetDrawColor(0, 170, 0, 160)
	surface.DrawRect(x, y + 2, barw * progress, 2)

	local maxstr
	if rlevel > 0 then
		maxstr = translate.Format("skillweb_level_max_remort", rlevel)
	else
		maxstr = translate.Get("skillweb_level_max")
	end

	if level == GAMEMODE.MaxLevel then
		draw_SimpleText(maxstr, "ZSXPBar", xpw / 2, h / 2 + y, COLOR_GREEN, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	else
		local levelstr
		if rlevel > 0 then
			levelstr = translate.Format("skillweb_level_remort", level, rlevel)
		else
			levelstr = translate.Format("skillweb_level", level)
		end

		if progress > 0 then
			local lx = x + barw * progress - 1
			surface.SetDrawColor(255, 255, 255, 20 + math.abs(math.sin(RealTime() * 2)) * 170)
			surface.DrawLine(lx, y - 2, lx, y + 7)
			surface.SetDrawColor(255, 255, 255, 160)
			surface.DrawLine(x, y - 1, x, y + 5)
			lx = x + barw - 1
			surface.DrawLine(lx, y - 1, lx, y + 5)
		end

		draw_SimpleText(levelstr, "ZSXPBar", x, h / 2 + y, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw_SimpleText(translate.Format("skillweb_xp_progress", string.CommaSeparate(xp), string.CommaSeparate(GAMEMODE:XPForLevel(level + 1))), "ZSXPBar", x + barw, h / 2 + y, COLOR_WHITE, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	end
end

PANEL = {}

PANEL.PlayerLevel = 0

function PANEL:Init()
	self:SetMouseInputEnabled(false)
	self:SetKeyboardInputEnabled(false)
end

function PANEL:PerformLayout()
	local screenscale = BetterScreenScale()

	self:SetSize(350 * screenscale, 36 * screenscale)
	if GAMEMODE.GameStatePanel and GAMEMODE.GameStatePanel:IsValid() then
		self:MoveBelow(GAMEMODE.GameStatePanel, screenscale * 32)
	else
		self:AlignTop(400)
	end
	self:AlignLeft()
end

function PANEL:Think()
	local new_level = MySelf:GetZSLevel()

	if new_level ~= self.PlayerLevel then
		if new_level ~= 1 and self.FirstLevelChange then
			GAMEMODE:CenterNotify(translate.Format("you_ascended_to_level_x", new_level))
			surface.PlaySound("weapons/physcannon/energy_disintegrate"..math.random(4, 5)..".wav")
		else
			self.FirstLevelChange = true
		end
	end

	self.PlayerLevel = new_level
end

local matGradientLeft = CreateMaterial("gradient-l", "UnlitGeneric", {["$basetexture"] = "vgui/gradient-l", ["$vertexalpha"] = "1", ["$vertexcolor"] = "1", ["$ignorez"] = "1", ["$nomip"] = "1"})
local colFlash = Color(255, 255, 255)
function PANEL:Paint(w, h)
	surface.SetDrawColor(0, 0, 0, 180)
	surface.DrawRect(0, 0, w * 0.4, h)
	surface.SetMaterial(matGradientLeft)
	surface.DrawTexturedRect(w * 0.4, 0, w * 0.6, h)

	local xpw = w * 0.85
	local x = xpw * 0.03
	local y = h * 0.15
	GAMEMODE:DrawXPBar(x, y, w, h, xpw, 0.9, 0.85, self.PlayerLevel)

	local sp = MySelf:GetZSSPRemaining()
	if sp > 0 then
		colFlash.a = 90 + math.abs(math.sin(RealTime() * 2)) * 160
		draw_SimpleText(translate.Format("skillweb_sp_short", sp), "ZSHUDFontSmallest", w - 2, h / 2, colFlash, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	end
end

vgui.Register("ZSExperienceHUD", PANEL, "Panel")

function GM:ToggleSkillWeb()
	if self.SkillWeb and self.SkillWeb:IsValid() then
		self.SkillWeb:Remove()
		self.SkillWeb = nil
		return
	end

	self.SkillWeb = vgui.Create("ZSSkillWeb")
end

local meta = FindMetaTable("Player")
if not meta then return end

function meta:SetSkillDesired(skillid, desired)
	local desiredskills = self:GetDesiredActiveSkills()

	if desired then
		if self:IsSkillUnlocked(skillid) and not self:IsSkillDesired(skillid) then
			table.insert(desiredskills, skillid)
		end
	else
		table.RemoveByValue(desiredskills, skillid)
	end

	self:SetDesiredActiveSkills(desiredskills)
end

function meta:SetSkillUnlocked(skillid, unlocked)
	local unlockedskills = self:GetUnlockedSkills()

	if self:IsSkillUnlocked(skillid) ~= unlocked then
		if unlocked then
			table.insert(unlockedskills, skillid)
		else
			table.RemoveByValue(unlockedskills, skillid)
		end
	end

	self:SetUnlockedSkills(unlockedskills)
end

function meta:SetDesiredActiveSkills(skills, nosend)
	self.DesiredActiveSkills = table.ToKeyValues(skills)
	self.DesiredActiveSkillsAssoc = nil
end

function meta:SetActiveSkills(skills, nosend)
	self.ActiveSkills = table.ToAssoc(skills)
end

function meta:SetUnlockedSkills(skills, nosend)
	self.UnlockedSkills = table.ToKeyValues(skills)
	self.UnlockedSkillsAssoc = nil
end
