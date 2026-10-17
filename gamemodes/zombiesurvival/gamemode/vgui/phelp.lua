GM.Help = {
{Name = "help_cat_introduction",
Content = "help_cont_introduction"},

{Name = "help_cat_survival",
Content = "help_cont_survival"},

{Name = "help_cat_barricading",
Content = "help_cont_barricading"},

{Name = "help_cat_upgrades",
Content = "help_cont_upgrades"},

{Name = "help_cat_being_a_zombie",
Content = "help_cont_being_a_zombie"}
}

function HideOtherSubmenus(except)
	local subs = {pHelp, pOptions, pWeapons, pCredits, pPlayerColor, GAMEMODE.SkillWeb}
	for i = 1, #subs do
		local sub = subs[i]
		if IsValid(sub) and sub ~= except and (not sub.IsVisible or sub:IsVisible()) then
			sub:SetVisible(false)
		end
	end
end

function MakepCredits()
	PlayMenuOpenSound()
	HideOtherSubmenus(nil)
	pCredits = nil

	local screenscale = math.Clamp(BetterScreenScale(), 0.55, 1.4)

	local wid = math.min(
		math.floor(ScrW() * 0.92 + 0.5),
		math.floor(750 * screenscale + 0.5)
	)

	local padX              = math.floor(8  * screenscale + 0.5)
	local padY              = math.floor(8  * screenscale + 0.5)
	local gapAfterTitle     = math.floor(8  * screenscale + 0.5)
	local gapBetweenAuthors = math.floor(10 * screenscale + 0.5)

	local titleH = math.floor(24 * screenscale + 0.5)

	local frame = vgui.Create("DEXRoundedFrame")
	frame:SetColorAlpha(230)
	frame:SetWide(wid)
	frame:SetTitle(" ")
	frame:SetKeyboardInputEnabled(false)
	frame.MainMenuSubmenu = true
	pCredits = frame

	local estimatedContentH = padY * 2
	for _, authortab in ipairs(GAMEMODE.Credits) do
		estimatedContentH = estimatedContentH + math.floor(22 * screenscale + 0.5)
		if authortab[2] and #authortab[2] > 0 then
			estimatedContentH = estimatedContentH + math.floor(14 * screenscale + 0.5)
		end
		estimatedContentH = estimatedContentH + gapBetweenAuthors
	end

	local headerLabel = EasyLabel(
		frame,
		translate.Format("credits_header", translate.Get("gamemode_name")),
		"ZSHUDFontNS",
		color_white
	)
	headerLabel:AlignTop(titleH + padY)
	headerLabel:CenterHorizontal()

	local scrollTop = titleH + padY + headerLabel:GetTall() + gapAfterTitle

	local maxH   = ScrH() * 0.88
	local finalH = math.min(estimatedContentH + scrollTop + padY, maxH)
	frame:SetTall(finalH)

	local scrollH = finalH - scrollTop

	local scroll = vgui.Create("DScrollPanel", frame)
	scroll:SetPos(0, scrollTop)
	scroll:SetSize(wid, scrollH)

	local vbar = scroll:GetVBar()

	local inner = vgui.Create("DPanel", scroll)
	inner:SetWide(wid - (vbar and vbar:GetWide() or 0))
	inner.Paint = function() end

	local y = padY

	-- Measure the string in the same metric it will be drawn with.
	-- For Cyrillic, ZS_MeasureMixedText uses the twin font
	-- (Tahoma) because the base Ghoulish Fright AOE font has no Cyrillic.
	local function measureText(s, font)
		if ZS_MeasureMixedText then
			return ZS_MeasureMixedText(s, font)
		end
		surface.SetFont(font)
		return surface.GetTextSize(s)
	end

	local function WrapTextLines(text, font, maxw)
		local lines = {}
		if not text or text == "" then
			lines[1] = ""
			return lines
		end

		-- Fast path: fits on a single line.
		if measureText(text, font) <= maxw then
			lines[1] = text
			return lines
		end

		local current = ""
		local i = 1
		local n = #text
		while i <= n do
			local b = string.byte(text, i)
			local charLen = 1
			if b >= 0xF0 then charLen = 4
			elseif b >= 0xE0 then charLen = 3
			elseif b >= 0xC0 then charLen = 2
			end
			if i + charLen - 1 > n then charLen = n - i + 1 end

			local char = string.sub(text, i, i + charLen - 1)
			i = i + charLen

			local test = current .. char
			if measureText(test, font) > maxw and current ~= "" then
				local breakAt = current:match("^.*()%s")
				if breakAt and breakAt > 1 then
					lines[#lines + 1] = string.sub(current, 1, breakAt - 1)
					current = string.sub(current, breakAt + 1) .. char
				else
					lines[#lines + 1] = current
					current = char
				end
			else
				current = test
			end
		end

		if current ~= "" then
			lines[#lines + 1] = current
		end

		return lines
	end

	local function MeasureWrappedHeight(text, font, maxw)
		local lineH
		if ZS_MeasureMixedText then
			_, lineH = ZS_MeasureMixedText("Ag", font)
		end
		if not lineH or lineH <= 0 then
			surface.SetFont(font)
			_, lineH = surface.GetTextSize("Ag")
		end
		if not lineH or lineH <= 0 then lineH = 14 end

		local lines = WrapTextLines(text, font, maxw)
		return #lines * lineH
	end

		for _, authortab in ipairs(GAMEMODE.Credits) do
		local authorName = translate.Exists(authortab[1]) and translate.Get(authortab[1]) or authortab[1]
		local authorRole = translate.Exists(authortab[3]) and translate.Get(authortab[3]) or authortab[3]
		authorName = string.Replace(authorName, "@", "(at)")

		local font = "ZSHUDFontSmallestNS"

		-- Create the separator first — we need its width to compute columns.
		local linemid = EasyLabel(inner, "-", font, color_white)
		linemid:CenterHorizontal()
		linemid:AlignTop(y)

		-- Max width of each column: from panel edge to the dash.
		local innerW = inner:GetWide()
		local colGap = math.floor(8 * screenscale + 0.5)
		local maxColW = math.floor(innerW * 0.5 - linemid:GetWide() * 0.5 - padX - colGap)
		if maxColW < 32 then maxColW = 32 end

		-- Manual wrap — this way we know the length of the longest line
		-- and can place the label right up against the needed edge.
		local nameLines = WrapTextLines(authorName, font, maxColW)
		local roleLines = WrapTextLines(authorRole, font, maxColW)

		-- Line height in the metric of the font that actually draws the
		-- text. Use ZS_MeasureMixedText — otherwise surface.GetTextSize
		-- with the base font returns ~0 for Russian text.
		local lineH
		if ZS_MeasureMixedText then
			_, lineH = ZS_MeasureMixedText("Ag", font)
		end
		if not lineH or lineH <= 0 then
			surface.SetFont(font)
			_, lineH = surface.GetTextSize("Ag")
		end
		if not lineH or lineH <= 0 then lineH = 14 end

		-- Width of the longest wrapped line — also via the mixed metric,
		-- otherwise nameW/roleW collapse to 0 for Cyrillic and the left
		-- column collapses to zero width.
		local function LinesMaxWidth(lines)
			local w = 0
			for _, ln in ipairs(lines) do
				local lw
				if ZS_MeasureMixedText then
					lw = ZS_MeasureMixedText(ln, font)
				else
					surface.SetFont(font)
					lw = surface.GetTextSize(ln)
				end
				if lw > w then w = lw end
			end
			return w
		end

		local nameW = LinesMaxWidth(nameLines)
		local roleW = LinesMaxWidth(roleLines)
		local nameH = #nameLines * lineH
		local roleH = #roleLines * lineH

		-- LEFT column — flush left (x = padX).
		local lineleft = EasyLabel(inner, table.concat(nameLines, "\n"), font, color_white)
		lineleft:SetContentAlignment(0) -- top-left
		lineleft:SetWide(nameW)
		lineleft:SetTall(nameH)
		lineleft:SetPos(padX, y)

		-- RIGHT column — flush right (right edge at innerW - padX).
		local lineright = EasyLabel(inner, table.concat(roleLines, "\n"), font, color_white)
		lineright:SetContentAlignment(0) -- top-left (text exactly fills its box)
		lineright:SetWide(roleW)
		lineright:SetTall(roleH)
		lineright:SetPos(innerW - padX - roleW, y)

		-- Substring (email/url) — under the name, left, full width.
		local linesub
		if authortab[2] and #authortab[2] > 0 then
			linesub = EasyLabel(inner, authortab[2], "DefaultFont", color_white)
		end

		y = y + math.max(nameH, roleH)

		if linesub then
			linesub:AlignTop(y)
			linesub:AlignLeft(padX)
			y = y + linesub:GetTall()
		end
		y = y + gapBetweenAuthors
	end

	inner:SetTall(y + padY)

	frame:Center()
	frame:SetAlpha(0)
	frame:AlphaTo(255, 0.15, 0)
	frame:MakePopup()
end

function MakepHelp()
	PlayMenuOpenSound()

	if pHelp then
		HideOtherSubmenus(pHelp)
		pHelp:SetAlpha(0)
		pHelp:AlphaTo(255, 0.15, 0)
		pHelp:SetVisible(true)
		pHelp:MakePopup()
		return
	end

	local wide, tall = 500, 480

	local Window = vgui.Create("DFrame")
	Window:SetSize(wide, tall)
	Window:Center()
	Window:SetTitle(" ")
	Window:SetDraggable(false)
	Window:SetDeleteOnClose(false)
	Window:SetKeyboardInputEnabled(false)
	Window:SetCursor("pointer")
	Window.MainMenuSubmenu = true
	HideOtherSubmenus(nil)
	pHelp = Window

	local label = EasyLabel(Window, translate.Get("submenu_help"), "ZSHUDFont", color_white)
	label:CenterHorizontal()
	label:AlignTop(8)

	local propertysheet = vgui.Create("DPropertySheet", Window)
	propertysheet:StretchToParent(12, 52, 12, 64)

	for _, helptab in ipairs(GAMEMODE.Help) do
		local htmlpanel = vgui.Create("DHTML", propertysheet)
		htmlpanel:StretchToParent(4, 4, 4, 24)
		htmlpanel:SetHTML([[<html>
		<head>
		<style type="text/css">
		body
		{
			font-family:tahoma;
			font-size:11px;
			color:white;
			background-color:black;
			width:]].. htmlpanel:GetWide() - 48 ..[[px;
		}
		div p
		{
			margin:10px;
			padding:2px;
		}
		</style>
		</head>
		<body>
<center><span style="font-size:22px;font-weight:bold;color:limegreen;text-decoration:underline;">]]..GAMEMODE.Name..[[</span><br>
]]..translate.Get(helptab.Name)..[[</center><br><br><div>]]..translate.Get(helptab.Content)..[[</div>
</body>
</html>]])
		propertysheet:AddSheet(translate.Get(helptab.Name), htmlpanel, helptab.Icon, false, false)
	end

	Window:Center()
	Window:MakePopup()

	local helpOpenedCredits = false

	local button = EasyButton(Window, translate.Get("submenu_credits"), 8, 4)
	button:SetPos(wide - button:GetWide() - 12, tall - button:GetTall() - 12)
	button:SetText(translate.Get("submenu_credits"))
	button.DoClick = function(btn)
		helpOpenedCredits = true
		MakepCredits()
	end

	gamemode.Call("BuildHelpMenu", Window, propertysheet)

	local timerid = "ZS_HelpMenu_ContentSync_" .. tostring(Window)
	timer.Create(timerid, 0.1, 0, function()
		if not IsValid(Window) then
			timer.Remove(timerid)
			return
		end

		if not helpOpenedCredits then return end

		local creditsopen = pCredits and IsValid(pCredits) and pCredits:IsVisible()

		if creditsopen then
			Window:SetVisible(false)
		else
			helpOpenedCredits = false
			Window:SetVisible(true)
			Window:MakePopup()
		end
	end)

	Window:SetAlpha(0)
	Window:AlphaTo(255, 0.15, 0)
	Window:MakePopup()
end

function GM:BuildHelpMenu(window, propertysheet)
end