GM.NotifyFadeTime = 8

local DefaultFont = "ZSHUDFontSmallest"
local DefaultFontEntity = "ZSHUDFontSmallest"

-- Vertical shift (in pixels) of font-based kill icons. Positive = lower, negative = higher.
local KILLICON_Y_OFFSET = 0

-- True if the text has a capital letter with a mark above it (Й, Ё, Ї, É, Ü, ...) that needs extra headroom.
local function HasTallGlyph(text)
	local ok, res = pcall(function()
		for _, c in utf8.codes(text) do
			if (c >= 0xC0 and c <= 0xC5) or (c >= 0xC8 and c <= 0xCF) or (c >= 0xD1 and c <= 0xD6)
			or (c >= 0xD9 and c <= 0xDD) or (c >= 0x100 and c <= 0x17F)
			or c == 0x401 or c == 0x407 or c == 0x40D or c == 0x40E or c == 0x419 then
				return true
			end
		end
		return false
	end)
	return ok and res
end

local PANEL  = {}

function PANEL:Init()
	self:DockPadding(8, 2, 8, 2)

	self:SetKeyboardInputEnabled(false)
	self:SetMouseInputEnabled(false)
end

local matGrad = Material("VGUI/gradient-r")
function PANEL:Paint()
	surface.SetMaterial(matGrad)
	surface.SetDrawColor(0, 0, 0, 180)

	local align = self:GetParent():GetAlign()
	if align == RIGHT then
		surface.DrawTexturedRect(self:GetWide() * 0.25, 0, self:GetWide(), self:GetTall())
	elseif align == CENTER then
		surface.DrawTexturedRect(self:GetWide() * 0.25, 0, self:GetWide() * 0.25, self:GetTall())
		surface.DrawTexturedRectRotated(self:GetWide() * 0.625, self:GetTall() / 2, self:GetWide() * 0.25, self:GetTall(), 180)
	else
		surface.DrawTexturedRectRotated(self:GetWide() * 0.25, self:GetTall() / 2, self:GetWide() / 2, self:GetTall(), 180)
	end
end

function PANEL:AddLabel(text, col, font, extramargin)
	local label = vgui.Create("DLabel", self)
	label:SetText(text)
	label:SetFont(font or DefaultFont)
	label:SetTextColor(col or color_white)
	label:SizeToContents()
	if extramargin then
		label:SetContentAlignment(7)
		label:DockMargin(0, label:GetTall() * 0.2, 0, 0)
		label.KillFont = true
		label.KillTall = label:GetTall()
	else
		label:SetContentAlignment(4)
		label.NaturalTall = label:GetTall()
		label.HasTallGlyph = HasTallGlyph(text)
	end
	label:Dock(LEFT)
end

function PANEL:AddImage(mat, col)
	local img = vgui.Create("DImage", self)
	img:SetImage(mat)
	if col then
		img:SetImageColor(col)
	end
	img:SizeToContents()
	local height = img:GetTall()
	if height > self:GetTall() then
		img:SetSize(self:GetTall() / height * img:GetWide(), self:GetTall())
	end
	img.IconTall = img:GetTall()
	img:DockMargin(0, (self:GetTall() - img:GetTall()) / 2, 0, 0)
	img:Dock(LEFT)
end

function PANEL:AddKillIcon(class)
	local icondata = killicon.GetIcon(class)

	if icondata then
		self:AddImage(icondata[1], icondata[2])
	else
		local fontdata = killicon.GetFont(class) or killicon.GetFont("default")
		if fontdata then
			self:AddLabel(fontdata[2], fontdata[3], fontdata[1], true)
		end
	end
end

function PANEL:SetNotification(...)
	local args = {...}

	local defaultcol = color_white
	local defaultfont
	for k, v in ipairs(args) do
		local vtype = type(v)

		if vtype == "table" then
			if v.r and v.g and v.b then
				defaultcol = v
			elseif v.font then
				if v.font == "" then
					defaultfont = nil
				else
					local th = draw.GetFontHeight(v.font)
					if th then
						defaultfont = v.font
					end
				end
			elseif v.killicon then
				self:AddKillIcon(v.killicon)
				if v.headshot then
					self:AddKillIcon("headshot")
				end
			elseif v.avatar then
				-- Avatar only, without a baked-in name.
				local ply = v.avatar
				local avatar = vgui.Create("AvatarImage", self)
				local size = self:GetTall() >= 32 and 32 or 16
				avatar:SetSize(size, size)
				if ply and ply:IsValid() then
					avatar:SetPlayer(ply, size)
				end
				avatar:SetAlpha(220)
				avatar.IconTall = size
				avatar:DockMargin(0, (self:GetTall() - avatar:GetTall()) / 2, 0, 0)
				avatar:Dock(LEFT)
			elseif v.image then
				self:AddImage(v.image, v.color)
			end
	elseif vtype == "Player" then
		local avatar = vgui.Create("AvatarImage", self)
		local size = self:GetTall() >= 32 and 32 or 16
		avatar:SetSize(size, size)
		if v:IsValid() then
			avatar:SetPlayer(v, size)
		end
		avatar:SetAlpha(220)
		avatar.IconTall = size
		avatar:DockMargin(0, (self:GetTall() - avatar:GetTall()) / 2, 0, 0)
		avatar:Dock(LEFT)

		if v:IsValid() then
			local displayname
			if self:GetParent() and self:GetParent().GetAlign and self:GetParent():GetAlign() == RIGHT then
				displayname = v:Name()
				if not displayname or displayname == "" then displayname = v:Nick() end
				if not displayname or displayname == "" then displayname = v:IsBot() and "BOT" or "???" end
			else
				displayname = v:DisplayName()
			end

			self:AddLabel(" "..displayname, team.GetColor(v:Team()), DefaultFontEntity)
		else
			self:AddLabel(" ?", team.GetColor(TEAM_UNASSIGNED), DefaultFontEntity)
		end
		elseif vtype == "Entity" then
			self:AddLabel("["..(v:IsValid() and v:GetClass() or "?").."]", COLOR_RED, DefaultFontEntity)
		else
			local text = tostring(v)

			self:AddLabel(text, defaultcol, defaultfont)
		end
	end
end

vgui.Register("DEXNotification", PANEL, "Panel")

local PANEL  = {}

AccessorFunc(PANEL, "m_Align", "Align", FORCE_NUMBER)
AccessorFunc(PANEL, "m_MessageHeight", "MessageHeight", FORCE_NUMBER)
AccessorFunc(PANEL, "m_WrapText", "WrapText", FORCE_BOOL)
AccessorFunc(PANEL, "m_DynamicHeight", "DynamicHeight", FORCE_BOOL)

function PANEL:Init()
	self:SetAlign(LEFT)
	self:SetMessageHeight(32)
	self:ParentToHUD()
	self:InvalidateLayout()
end

function PANEL:PerformLayout()
end

function PANEL:Paint()
end

local function GetTextWidth(text, font)
	surface.SetFont(font or DefaultFont)
	return (surface.GetTextSize(text))
end

function PANEL:WrapNotification(maxw, ...)
	local lines = {}
	local cur, curw, hascontent = {}, 0, false
	local colorstate, fontstate, timestate, fontname
	local iconw = self:GetMessageHeight() * BetterScreenScale()

	local function newline()
		if hascontent then
			lines[#lines + 1] = cur
		end
		cur, curw, hascontent = {}, 0, false
		if colorstate then cur[#cur + 1] = colorstate end
		if fontstate then cur[#cur + 1] = fontstate end
		if timestate then cur[#cur + 1] = timestate end
	end

	local function addelement(elem, w)
		if hascontent and curw + w > maxw then
			newline()
		end
		cur[#cur + 1] = elem
		curw = curw + w
		hascontent = true
	end

	for _, v in ipairs({...}) do
		local vtype = type(v)

		if vtype == "table" then
			if v.r and v.g and v.b then
				colorstate = v
				cur[#cur + 1] = v
			elseif v.font then
				fontstate = v
				fontname = v.font ~= "" and v.font or nil
				cur[#cur + 1] = v
			elseif v.killicon or v.image or v.avatar then
				addelement(v, iconw * (v.headshot and 2 or 1))
			else
				if v.CustomTime then
					timestate = v
				end
				cur[#cur + 1] = v
			end
		elseif vtype == "Player" then
			local name
			if v:IsValid() then
				if self:GetAlign() == RIGHT then
					name = v:Name()
					if not name or name == "" then name = v:Nick() end
					if not name or name == "" then name = v:IsBot() and "BOT" or "???" end
				else
					name = v:DisplayName()
				end
			else
				name = "?"
			end
			addelement(v, 32 + GetTextWidth(" " .. name, DefaultFontEntity))
		elseif vtype == "Entity" then
			addelement(v, GetTextWidth("[" .. (v:IsValid() and v:GetClass() or "?") .. "]", DefaultFontEntity))
		else
			local text = tostring(v)
			local buf = ""

			for word in string.gmatch(text, "%s*%S+%s*") do
				local w = GetTextWidth(word, fontname)

				-- If the word itself is wider than the line (typical for CJK,
				-- where there are no spaces) — split character by character.
				if w > maxw then
					if buf ~= "" then
						cur[#cur + 1] = buf
						buf = ""
					end
					newline()
					word = string.match(word, "^%s*(.*)$")

					for _, code in utf8.codes(word) do
						local ch = utf8.char(code)
						local chw = GetTextWidth(ch, fontname)
						if hascontent and curw + chw > maxw then
							newline()
						end
						cur[#cur + 1] = ch
						curw = curw + chw
						hascontent = true
					end
				else
					if hascontent and curw + w > maxw then
						if buf ~= "" then
							cur[#cur + 1] = buf
							buf = ""
						end
						newline()
						word = string.match(word, "^%s*(.*)$")
						w = GetTextWidth(word, fontname)
					end

					buf = buf .. word
					curw = curw + w
					hascontent = true
				end
			end

			if buf ~= "" then
				cur[#cur + 1] = buf
			elseif not string.find(text, "%S") then
				addelement(text, GetTextWidth(text, fontname))
			end
		end
	end

	if hascontent then
		lines[#lines + 1] = cur
	end

	return lines
end

function PANEL:AddNotification(...)
	if self:GetWrapText() then
		local scale = BetterScreenScale()
		local maxw = self:GetWide() - (self:GetAlign() == RIGHT and 40 or 16) * scale
		local lines = self:WrapNotification(maxw, ...)

		if #lines > 1 then
			local notif
			for _, line in ipairs(lines) do
				notif = self:AddNotificationLine(unpack(line))
			end

			return notif
		end
	end

	return self:AddNotificationLine(...)
end

function PANEL:AddNotificationLine(...)
	local notif = vgui.Create("DEXNotification", self)
	notif:SetTall(BetterScreenScale() * self:GetMessageHeight())
	notif:SetNotification(...)

	local base = notif:GetTall()
	local pad = 4
	local needed, hastall = 0, false
	for _, p in pairs(notif:GetChildren()) do
		if p.NaturalTall then
			needed = math.max(needed, p.NaturalTall)
			hastall = hastall or p.HasTallGlyph
		end
	end

	if self:GetDynamicHeight() then
		-- Height follows the text: just the font height, plus headroom only for lines with Й, Ё, É, ...
		local h = needed + pad
		if hastall then
			h = h + math.ceil(needed * 0.25)
		end
		for _, p in pairs(notif:GetChildren()) do
			if p.IconTall then
				h = math.max(h, p.IconTall + pad)
			elseif p.KillTall then
				h = math.max(h, base)
			end
		end
		notif:SetTall(h)
		for _, p in pairs(notif:GetChildren()) do
			if p.IconTall then
				local m = math.max(0, (h - p.IconTall) / 2)
				p:DockMargin(0, m, 0, m)
			elseif p.KillTall then
				p:SetContentAlignment(7)
				p:DockMargin(0, p.KillTall * 0.2 + (h - base) / 2 + KILLICON_Y_OFFSET, 0, 0)
			end
		end
	elseif needed + 6 > notif:GetTall() then
		notif:SetTall(needed + 6)
	end

	local w = 0
	for _, p in pairs(notif:GetChildren()) do
		w = w + p:GetWide()
	end
	if self:GetAlign() == RIGHT then
		notif:DockPadding(self:GetWide() - w - (32 * BetterScreenScale()), 0, 8, 0)
	elseif self:GetAlign() == CENTER then
		notif:DockPadding((self:GetWide() - w) / 2, 0, 0, 0)
	else
		notif:DockPadding(8, 0, 8, 0)
	end

	notif:Dock(TOP)

	local args = {...}

	local FadeTime = GAMEMODE.NotifyFadeTime

	for k, v in pairs(args) do
		if type(v) == "table" and v.CustomTime and type(v.CustomTime == "number") then
			FadeTime = v.CustomTime
			break
		end
	end

	notif:SetAlpha(1)
	notif:AlphaTo(255, 0.15)
	notif:AlphaTo(1, 1, FadeTime - 1)

	notif.DieTime = CurTime() + FadeTime

	return notif
end

function PANEL:Think()
	local time = CurTime()
	local anyRemoved = false

	for _, pan in pairs(self:GetChildren()) do
		if pan.DieTime and time >= pan.DieTime then
			pan:Remove()
			anyRemoved = true
		end
	end

	if anyRemoved then
		self:InvalidateLayout(true)
	end
end

vgui.Register("DEXNotificationsList", PANEL, "Panel")