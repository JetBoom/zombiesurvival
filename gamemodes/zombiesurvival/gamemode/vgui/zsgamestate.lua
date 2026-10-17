local cvCompactNumbers = CreateClientConVar("zs_compact_numbers", "0", true, false)

local CompactNumberUnits = {
    {1e63, "number_suffix_vigintillion"},
    {1e60, "number_suffix_novemdecillion"},
    {1e57, "number_suffix_octodecillion"},
    {1e54, "number_suffix_septendecillion"},
    {1e51, "number_suffix_sexdecillion"},
    {1e48, "number_suffix_quindecillion"},
    {1e45, "number_suffix_quattuordecillion"},
    {1e42, "number_suffix_tredecillion"},
    {1e39, "number_suffix_duodecillion"},
    {1e36, "number_suffix_undecillion"},
    {1e33, "number_suffix_decillion"},
    {1e30, "number_suffix_quetta"},
	{1e27, "number_suffix_ronna"},
	{1e24, "number_suffix_yotta"},
	{1e21, "number_suffix_zetta"},
	{1e18, "number_suffix_exa"},
	{1e15, "number_suffix_peta"},
	{1e12, "number_suffix_tera"},
	{1e9,  "number_suffix_giga"},
	{1e6,  "number_suffix_mega"},
	{1e3,  "number_suffix_kilo"}
}

local function TrimNumberZeros(str)
	str = string.gsub(str, "(%..-)0+$", "%1")
	str = string.gsub(str, "%.$", "")
	return str
end

function GAMEMODE:FormatNumber(number, forceCompact, maxDecimals)
	number = tonumber(number) or 0

	if not forceCompact and not cvCompactNumbers:GetBool() then
		return string.format("%.0f", number)
	end

	local absnumber = math.abs(number)

	if absnumber < 1000 then
		return string.format("%.0f", number)
	end

	for _, unit in ipairs(CompactNumberUnits) do
		local value = unit[1]
		local translationID = unit[2]

		if absnumber >= value then
			local scaled = number / value

			local decimals = 2

			if maxDecimals then
				decimals = math.min(decimals, maxDecimals)
			end

			local formatted = string.format(
				"%." .. decimals .. "f",
				scaled
			)

			formatted = TrimNumberZeros(formatted)

			local separator = translate.Get("number_decimal_separator")
			if separator and separator ~= "@" .. "number_decimal_separator" .. "@" then
				formatted = string.Replace(formatted, ".", separator)
			end

			local suffix = translate.Get(translationID)

			if suffix == "@" .. translationID .. "@" then
				suffix = ""
			end

			return formatted .. suffix
		end
	end

	return string.format("%.0f", number)
end

local ZS_SCORE_NW2_KEY = "zs_score"

function GAMEMODE:GetDisplayedScore(pl)
	if not pl or not pl:IsValid() then return 0 end

	local value = pl:GetNW2String(ZS_SCORE_NW2_KEY, "")
	if value ~= "" then
		return tonumber(value) or 0
	end

	return pl:Frags()
end

local function GetDisplayedZSScore(pl)
	return GAMEMODE:GetDisplayedScore(pl)
end

local PANEL = {}

function PANEL:Init()
	self.m_HumanCount = vgui.Create("DTeamCounter", self)
	self.m_HumanCount:SetTeam(TEAM_HUMAN)
	self.m_HumanCount:SetImage("zombiesurvival/humanhead")

	self.m_ZombieCount = vgui.Create("DTeamCounter", self)
	self.m_ZombieCount:SetTeam(TEAM_UNDEAD)
	self.m_ZombieCount:SetImage("zombiesurvival/zombiehead")

	self.m_Text1 = vgui.Create("DLabel", self)
	self.m_Text2 = vgui.Create("DLabel", self)
	self.m_Text3 = vgui.Create("DLabel", self)
	self:SetTextFont("ZSHUDFontTinyOutline")

	self.m_Text1.Paint = self.Text1Paint
	self.m_Text2.Paint = self.Text2Paint
	self.m_Text3.Paint = self.Text3Paint

	self.m_CachedText1 = ""
	self.m_CachedText2 = ""
	self.m_CachedText3 = ""

	self:InvalidateLayout()
end

function PANEL:SetTextFont(font)
	self.m_Text1.Font = font
	self.m_Text1:SetFont(font)
	self.m_Text2.Font = font
	self.m_Text2:SetFont(font)
	self.m_Text3.Font = font
	self.m_Text3:SetFont(font)

	self:InvalidateLayout()
end

function PANEL:MeasureNeededWidth(text1, text2, text3)
	local baseFont = self.m_Text1.Font or "ZSHUDFontSmaller"

	local function MeasureOne(t)
		if not t or #t == 0 then return 0 end
		local font = baseFont
		if ZS_GetFontForText then
			font = ZS_GetFontForText(baseFont, t)
		end
		surface.SetFont(font)
		return surface.GetTextSize(t) or 0
	end

	local maxw = math.max(MeasureOne(text1), MeasureOne(text2), MeasureOne(text3))
	if maxw == 0 then return nil end

	local left = self:GetTall() * 0.5 + 12
	return left + maxw + 12
end

function PANEL:EnsureWidth(text, font)
	if not text or #text == 0 then return end

	surface.SetFont(font or "ZSHUDFontSmaller")
	local textw = surface.GetTextSize(text)

	local offset = self:GetTall() * 0.5 + 12
	local needed = offset + textw + 12

	if needed > self:GetWide() then
		self:SetWide(needed)
	end
end

function PANEL:PerformLayout()
	local hs = self:GetTall() * 0.5
	self.m_HumanCount:SetSize(hs, hs)
	self.m_ZombieCount:SetSize(hs, hs)
	self.m_ZombieCount:AlignTop(hs)

	local left = hs + 12
	local w = self:GetWide() - left - 12

	self.m_Text1:SetPos(left, 4)
	self.m_Text1:SetSize(w, self.m_Text1:GetTall())
	self.m_Text1:SizeToContentsY()

	self.m_Text2:SetPos(left, 0)
	self.m_Text2:SetSize(w, self.m_Text2:GetTall())
	self.m_Text2:SizeToContentsY()
	self.m_Text2:CenterVertical()

	self.m_Text3:SetPos(left, 0)
	self.m_Text3:SetSize(w, self.m_Text3:GetTall())
	self.m_Text3:SizeToContentsY()
	self.m_Text3:AlignBottom(4)
end

function PANEL:RefreshCachedStrings()
	self.m_CachedText1 = self:GetText1String()
	self.m_CachedText2 = self:GetText2String()
	self.m_CachedText3 = self:GetText3String()
end

local nextRefresh = 0
function PANEL:Think()
	if not MySelf or not MySelf:IsValid() then return end

	local now = CurTime()
	if now < nextRefresh then return end
	nextRefresh = now + 0.25

	self:RefreshCachedStrings()

	local need = self:MeasureNeededWidth(
		self.m_CachedText1,
		self.m_CachedText2,
		self.m_CachedText3
	)
	if need and need ~= self:GetWide() then
		self:SetWide(need)
	end
end

function PANEL:GetText1String()
    local override = MySelf:IsValid() and GetGlobalString("hudoverride"..MySelf:Team(), "")
    if override and #override > 0 then
        return translate.MapText(override)
    end

    local wave = GAMEMODE:GetWave()
    if GAMEMODE:IsEscapeSequence() then
		return translate.Get(MySelf:IsValid() and MySelf:Team() == TEAM_UNDEAD and "prop_obj_exit_z" or "prop_obj_exit_h")
	elseif wave <= 0 then
		return translate.Get("prepare_yourself")
	elseif GAMEMODE.ZombieEscape then
		local round = GAMEMODE.CurrentRound
		return translate.Format("zombie_escape_round_x_of_y", round, 2)
	else
		local maxwaves = GAMEMODE:GetNumberOfWaves()
		if maxwaves ~= -1 then
			if not GAMEMODE:GetWaveActive() then
				return translate.Format("intermission_wave_x_of_y", wave, maxwaves)
			end
			return translate.Format("wave_x_of_y", wave, maxwaves)
		elseif not GAMEMODE:GetWaveActive() then
			return translate.Get("intermission")
		end
	end
end

function PANEL:GetText2String()
	if GAMEMODE:GetWave() <= 0 then
		local timeleft = math.max(0, GAMEMODE:GetWaveStart() - CurTime())
		return translate.Format("zombie_invasion_in_x", util.ToMinutesSecondsCD(timeleft))
	elseif GAMEMODE:GetWaveActive() then
		local waveend = GAMEMODE:GetWaveEnd()
		if waveend ~= -1 then
			return translate.Format("wave_ends_in_x", util.ToMinutesSecondsCD(math.max(0, waveend - CurTime())))
		end
	else
		local wavestart = GAMEMODE:GetWaveStart()
		if wavestart ~= -1 then
			return translate.Format("next_wave_in_x", util.ToMinutesSecondsCD(math.max(0, wavestart - CurTime())))
		end
	end
end

function PANEL:GetText3String()
	if not MySelf:IsValid() then return end
	if MySelf:Team() == TEAM_UNDEAD then
		local toredeem = GAMEMODE:GetRedeemBrains()
		if toredeem > 0 then
			return translate.Format("brains_eaten_x", GetDisplayedZSScore(MySelf).." / "..toredeem)
		end
		return translate.Format("brains_eaten_x", GetDisplayedZSScore(MySelf))
	end
	return translate.Format("gamestate_points_x_score_x", GAMEMODE:FormatNumber(MySelf:GetPoints()), GAMEMODE:FormatNumber(GetDisplayedZSScore(MySelf), nil, 1))
end

function PANEL:Text1Paint()
	local text = self:GetParent().m_CachedText1
	if text then
		draw.SimpleText(text, self.Font, 0, 0, COLOR_GRAY)
	end
	return true
end

function PANEL:Text2Paint()
	local parent = self:GetParent()
	local text = parent.m_CachedText2
	if not text then return true end

	local col
	local timeleft
	if GAMEMODE:GetWave() <= 0 then
		timeleft = math.max(0, GAMEMODE:GetWaveStart() - CurTime())
		if timeleft < 10 then
			local glow = math.sin(RealTime() * 8) * 200 + 255
			col = Color(255, glow, glow)
		else
			col = COLOR_GRAY
		end
	elseif GAMEMODE:GetWaveActive() then
		timeleft = math.max(0, GAMEMODE:GetWaveEnd() - CurTime())
		col = 10 < timeleft and COLOR_GRAY or Color(255, 0, 0, math.abs(math.sin(RealTime() * 8)) * 180 + 40)
	else
		timeleft = math.max(0, GAMEMODE:GetWaveStart() - CurTime())
		col = 10 < timeleft and COLOR_GRAY or Color(255, 0, 0, math.abs(math.sin(RealTime() * 8)) * 180 + 40)
	end

	draw.SimpleText(text, self.Font, 0, 0, col)
	return true
end

function PANEL:Text3Paint()
	local text = self:GetParent().m_CachedText3
	if text then
		draw.SimpleText(text, self.Font, 0, 0, COLOR_SOFTRED)
	end
	return true
end

local matGradientLeft = CreateMaterial("gradient-l", "UnlitGeneric", {["$basetexture"] = "vgui/gradient-l", ["$vertexalpha"] = "1", ["$vertexcolor"] = "1", ["$ignorez"] = "1", ["$nomip"] = "1"})
function PANEL:Paint(w, h)
	surface.SetDrawColor(0, 0, 0, 180)
	surface.DrawRect(0, 0, w * 0.4, h)
	surface.SetMaterial(matGradientLeft)
	surface.DrawTexturedRect(w * 0.4, 0, w * 0.6, h)
	--surface.DrawLine(0, h - 1, w, h - 1)
	surface.SetDrawColor(0, 0, 0, 250)
	surface.SetMaterial(matGradientLeft)
	surface.DrawTexturedRect(0, h - 1, w, 1)

	return true
end

vgui.Register("ZSGameState", PANEL, "DPanel")
