function MakepOptions()
	local function MakeDropdown(parent)
		local dd = vgui.Create("DComboBox", parent)
		StyleZSComboBox(dd)
		return dd
	end
	-- Display name of the beatset:
	--   - if there is a translation for beatset_<name>, use it (standard set);
	--   - otherwise show the folder name itself (custom set).
	local function BeatSetDisplay(setname)
		local key = "beatset_" .. setname
		if translate.Exists(key) then return translate.Get(key) end
		return setname
	end

	-- Value from the convar → text for SetText.
	-- In the convar "default"/"none"/folder name, but all of this needs to be displayed
	-- translated, if it is standard.
	local function BeatSetCurrentDisplay(stored, defaultFolder)
		if stored == defaultFolder or stored == "default" then
			return translate.Get("opt_beatset_default")
		elseif stored == "none" then
			return translate.Get("opt_beatset_none")
		end
		return BeatSetDisplay(stored)
	end
	PlayMenuOpenSound()

	local function WrapOptionText(text, font, maxWidth)
    if type(text) ~= "string" or text == "" then return text end
    if not maxWidth or maxWidth <= 0 then return text end

    local function measure(s)
        if ZS_MeasureMixedText then
            return ZS_MeasureMixedText(s, font)
        end
        surface.SetFont(font)
        return surface.GetTextSize(s)
    end

    local lines = {}
    local cur   = ""

    local function flush()
        if cur ~= "" then
            lines[#lines + 1] = cur
            cur = ""
        end
    end

    -- Iterate words while preserving separators.
    for token in string.gmatch(text, "%s*%S+%s*") do
        local w = measure(token)

        if w <= maxWidth then
            -- Word fits. Check if it fits on the current line.
            if cur ~= "" and measure(cur .. token) > maxWidth then
                flush()
                -- Drop leading whitespace on wrapped word.
                cur = string.match(token, "^%s*(.*)$")
            else
                cur = cur .. token
            end
        else
            -- Word is wider than line — split char-by-char (CJK, long URLs).
            flush()
            local bare = string.match(token, "^%s*(.-)%s*$")

            for _, code in utf8.codes(bare) do
                local ch = utf8.char(code)
                if cur ~= "" and measure(cur .. ch) > maxWidth then
                    flush()
                end
                cur = cur .. ch
            end
        end
    end

    flush()
    return table.concat(lines, "\n")
	end
	
	if pOptions then
		pOptions:SetAlpha(0)
		pOptions:AlphaTo(255, 0.15, 0)
		pOptions:SetVisible(true)
		pOptions:MakePopup()
		return
	end

	local Window = vgui.Create("DFrame")
	local wide = math.min(ScrW(), 500)
	local tall = math.min(ScrH(), 800)
	Window:SetSize(wide, tall)
	Window:Center()
	Window:SetTitle(" ")
	Window:SetDeleteOnClose(false)
	pOptions = Window

	local y = 8

	local label = EasyLabel(Window, translate.Get("options_title"), "ZSScoreBoardTitle", color_white)
	label:SetPos(wide * 0.5 - label:GetWide() * 0.5, y)
	y = y + label:GetTall() + 8

	local list = vgui.Create("DPanelList", pOptions)
	list:EnableVerticalScrollbar()
	list:EnableHorizontal(false)
	list:SetSize(wide - 24, tall - y - 12)
	list:SetPos(12, y)
	list:SetPadding(8)
	list:SetSpacing(4)

	local WRAP_W = list:GetWide() - 32

	-- Label on the left, slider on the right. Same color as DCheckBoxLabel
	-- (DLabel + SetDark(false), no SetTextColor override). Label height is
	-- computed manually from the wrapped text so multi-line translations
	-- get the room they need (SetAutoStretchVertical alone returns stale
	-- height before PerformLayout runs).
	local function AddSliderRow(labelText, cfg)
		local row = vgui.Create("DPanel", Window)
		row.Paint = function() end

		local s = vgui.Create("DNumSlider", row)
		cfg(s)
		s:SetText("")
		s:SetPos(0, 0)
		s:SetWide(WRAP_W)
		s:SetTall(32)

		local font   = "DermaDefault"
		local labelW = math.floor(WRAP_W / 2.4) - 8

		local wrapped = WrapOptionText(labelText, font, labelW)

		-- Count lines and compute the label height ourselves.
		local lineCount = 1
		for _ in wrapped:gmatch("\n") do lineCount = lineCount + 1 end
		local lineH  = draw.GetFontHeight(font) or 15
		local labelH = lineH * lineCount + 2

		local lbl = vgui.Create("DLabel", row)
		lbl:SetFont(font)
		lbl:SetDark(false)          -- same color as DCheckBoxLabel
		lbl:SetText(wrapped)
		lbl:SetPos(0, 0)
		lbl:SetSize(labelW, labelH)

		local h = math.max(labelH, 32)
		row:SetTall(h)
		s:SetTall(h)
		lbl:SetPos(0, math.floor((h - labelH) * 0.5))

		list:AddItem(row)
		return s
	end

	gamemode.Call("AddExtraOptions", list, Window)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(WrapOptionText(translate.Get("opt_always_nails"), "Default", WRAP_W - 24))
	check:SetConVar("zs_alwaysshownails")
	check:SizeToContents()
	list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(WrapOptionText(translate.Get("opt_thirdperson_knockdown"), "Default", WRAP_W - 24))
	check:SetConVar("zs_thirdpersonknockdown")
	check:SizeToContents()
	list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(WrapOptionText(translate.Get("opt_always_volunteer"), "Default", WRAP_W - 24))
	check:SetConVar("zs_alwaysvolunteer")
	check:SizeToContents()
	list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(WrapOptionText(translate.Get("opt_always_quickbuy"), "Default", WRAP_W - 24))
	check:SetConVar("zs_alwaysquickbuy")
	check:SizeToContents()
	list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(WrapOptionText(translate.Get("opt_suicide_on_change"), "Default", WRAP_W - 24))
	check:SetConVar("zs_suicideonchange")
	check:SizeToContents()
	list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(WrapOptionText(translate.Get("opt_no_redeem"), "Default", WRAP_W - 24))
	check:SetConVar("zs_noredeem")
	check:SizeToContents()
	list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(WrapOptionText(translate.Get("opt_no_use_deposit"), "Default", WRAP_W - 24))
	check:SetConVar("zs_nousetodeposit")
	check:SizeToContents()
	list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(WrapOptionText(translate.Get("opt_no_pickup_props"), "Default", WRAP_W - 24))
	check:SetConVar("zs_nopickupprops")
	check:SizeToContents()
	list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(WrapOptionText(translate.Get("opt_no_ironsights"), "Default", WRAP_W - 24))
	check:SetConVar("zs_noironsights")
	check:SizeToContents()
	list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(WrapOptionText(translate.Get("opt_no_crosshair_rotate"), "Default", WRAP_W - 24))
	check:SetConVar("zs_nocrosshairrotate")
	check:SizeToContents()
	list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(WrapOptionText(translate.Get("opt_disable_scopes"), "Default", WRAP_W - 24))
	check:SetConVar("zs_disablescopes")
	check:SizeToContents()
	list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(WrapOptionText(translate.Get("opt_draw_xp"), "Default", WRAP_W - 24))
	check:SetConVar("zs_drawxp")
	check:SizeToContents()
	list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(WrapOptionText(translate.Get("opt_no_floatingscore"), "Default", WRAP_W - 24))
	check:SetConVar("zs_nofloatingscore")
	check:SizeToContents()
	list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(WrapOptionText(translate.Get("opt_hide_packs"), "Default", WRAP_W - 24))
	check:SetConVar("zs_hidepacks")
	check:SizeToContents()
	list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(WrapOptionText(translate.Get("opt_show_friends"), "Default", WRAP_W - 24))
	check:SetConVar("zs_showfriends")
	check:SizeToContents()
	list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(WrapOptionText(translate.Get("opt_ironsights_crosshair"), "Default", WRAP_W - 24))
	check:SetConVar("zs_ironsightscrosshair")
	check:SizeToContents()
	list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(WrapOptionText(translate.Get("opt_beats"), "Default", WRAP_W - 24))
	check:SetConVar("zs_beats")
	check:SizeToContents()
	list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(WrapOptionText(translate.Get("opt_playmusic"), "Default", WRAP_W - 24))
	check:SetConVar("zs_playmusic")
	check:SizeToContents()
	list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(WrapOptionText(translate.Get("opt_postprocessing"), "Default", WRAP_W - 24))
	check:SetConVar("zs_postprocessing")
	check:SizeToContents()
	list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(WrapOptionText(translate.Get("opt_filmgrain"), "Default", WRAP_W - 24))
	check:SetConVar("zs_filmgrain")
	check:SizeToContents()
	list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(WrapOptionText(translate.Get("opt_colormod"), "Default", WRAP_W - 24))
	check:SetConVar("zs_colormod")
	check:SizeToContents()
	list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(WrapOptionText(translate.Get("opt_draw_pain_flash"), "Default", WRAP_W - 24))
	check:SetConVar("zs_drawpainflash")
	check:SizeToContents()
	list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(WrapOptionText(translate.Get("opt_font_effects"), "Default", WRAP_W - 24))
	check:SetConVar("zs_fonteffects")
	check:SizeToContents()
	list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(WrapOptionText(translate.Get("opt_auras"), "Default", WRAP_W - 24))
	check:SetConVar("zs_auras")
	check:SizeToContents()
	list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(WrapOptionText(translate.Get("opt_damage_floaters"), "Default", WRAP_W - 24))
	check:SetConVar("zs_damagefloaters")
	check:SizeToContents()
	list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(WrapOptionText(translate.Get("opt_movement_view_roll"), "Default", WRAP_W - 24))
	check:SetConVar("zs_movementviewroll")
	check:SizeToContents()
	list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(WrapOptionText(translate.Get("opt_message_beacon_show"), "Default", WRAP_W - 24))
	check:SetConVar("zs_messagebeaconshow")
	check:SizeToContents()
	list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(WrapOptionText(translate.Get("opt_film_mode"), "Default", WRAP_W - 24))
	check:SetConVar("zs_filmmode")
	check:SizeToContents()
	list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(WrapOptionText(translate.Get("opt_hide_viewmodels"), "Default", WRAP_W - 24))
	check:SetConVar("zs_hideviewmodels")
	check:SizeToContents()
	list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(WrapOptionText(translate.Get("opt_no_boss_pick"), "Default", WRAP_W - 24))
	check:SetConVar("zs_nobosspick")
	check:SizeToContents()
	list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(WrapOptionText(translate.Get("opt_damage_floaters_walls"), "Default", WRAP_W - 24))
	check:SetConVar("zs_damagefloaterswalls")
	check:SizeToContents()
	list:AddItem(check)
	
	check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(WrapOptionText(translate.Get("opt_compact_numbers"), "Default", WRAP_W - 24))
	check:SetConVar("zs_compact_numbers")
	check:SizeToContents()
	list:AddItem(check)
	
	check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(WrapOptionText(translate.Get("opt_wepelements"), "Default", WRAP_W - 24))
	check:SetConVar("zs_wepelements")
	check:SizeToContents()
	list:AddItem(check)

	list:AddItem(EasyLabel(Window, WrapOptionText(translate.Get("opt_notifystack_label"), "DefaultFontSmall", WRAP_W), "DefaultFontSmall", color_white))
	local notifDropdown = MakeDropdown(Window)
	notifDropdown:SetMouseInputEnabled(true)

	notifDropdown:AddChoice(translate.Get("opt_notifystack_none"),    0)
	notifDropdown:AddChoice(translate.Get("opt_notifystack_full"),    1)
	notifDropdown:AddChoice(translate.Get("opt_notifystack_numeric"), 2)

	notifDropdown.OnSelect = function(me, index, value, data)
		if data ~= nil then
			RunConsoleCommand("zs_notifystack", data)
		end
	end

	notifDropdown:SetText(
		GAMEMODE.NotifyStack == 2 and translate.Get("opt_notifystack_numeric")
		or GAMEMODE.NotifyStack == 1 and translate.Get("opt_notifystack_full")
		or translate.Get("opt_notifystack_none")
	)
	list:AddItem(notifDropdown)

	list:AddItem(EasyLabel(Window, WrapOptionText(translate.Get("opt_hud_style_label"), "DefaultFontSmall", WRAP_W), "DefaultFontSmall", color_white))
	local dropdown = MakeDropdown(Window)
	dropdown:SetMouseInputEnabled(true)
	dropdown:AddChoice(translate.Get("opt_hud_style_3d"))
	dropdown:AddChoice(translate.Get("opt_hud_style_2d"))
	dropdown:AddChoice(translate.Get("opt_hud_style_both"))
	dropdown.OnSelect = function(me, index, value, data)
		RunConsoleCommand("zs_weaponhudmode", value == translate.Get("opt_hud_style_both") and 2 or value == translate.Get("opt_hud_style_2d") and 1 or 0)
	end
	dropdown:SetText(GAMEMODE.WeaponHUDMode == 2 and translate.Get("opt_hud_style_both") or GAMEMODE.WeaponHUDMode == 1 and translate.Get("opt_hud_style_2d") or translate.Get("opt_hud_style_3d"))
	list:AddItem(dropdown)

	list:AddItem(EasyLabel(Window, WrapOptionText(translate.Get("opt_health_style_label"), "DefaultFontSmall", WRAP_W), "DefaultFontSmall", color_white))
	dropdown = MakeDropdown(Window)
	dropdown:SetMouseInputEnabled(true)
	dropdown:AddChoice(translate.Get("opt_health_style_percent"))
	dropdown:AddChoice(translate.Get("opt_health_style_amount"))
	dropdown.OnSelect = function(me, index, value, data)
		RunConsoleCommand("zs_healthtargetdisplay", value == translate.Get("opt_health_style_amount") and 1 or 0)
	end
	dropdown:SetText(GAMEMODE.HealthTargetDisplay == 1 and translate.Get("opt_health_style_amount") or translate.Get("opt_health_style_percent"))
	list:AddItem(dropdown)

	list:AddItem(EasyLabel(Window, WrapOptionText(translate.Get("opt_prop_snap_label"), "DefaultFontSmall", WRAP_W), "DefaultFontSmall", color_white))
	dropdown = MakeDropdown(Window)
	dropdown:SetMouseInputEnabled(true)
	dropdown:AddChoice(translate.Get("opt_prop_snap_none"))
	dropdown:AddChoice(translate.Get("opt_prop_snap_15"))
	dropdown:AddChoice(translate.Get("opt_prop_snap_30"))
	dropdown:AddChoice(translate.Get("opt_prop_snap_45"))
	dropdown.OnSelect = function(me, index, value, data)
		RunConsoleCommand("zs_proprotationsnap", value == translate.Get("opt_prop_snap_15") and 15 or value == translate.Get("opt_prop_snap_30") and 30 or value == translate.Get("opt_prop_snap_45") and 45 or 0)
	end
	dropdown:SetText(GAMEMODE.PropRotationSnap == 15 and translate.Get("opt_prop_snap_15")
		or GAMEMODE.PropRotationSnap == 30 and translate.Get("opt_prop_snap_30")
		or GAMEMODE.PropRotationSnap == 45 and translate.Get("opt_prop_snap_45")
		or translate.Get("opt_prop_snap_none"))
	list:AddItem(dropdown)

	list:AddItem(EasyLabel(Window, WrapOptionText(translate.Get("opt_beatset_human"), "DefaultFontSmall", WRAP_W), "DefaultFontSmall", color_white))
	dropdown = MakeDropdown(Window)
	dropdown:SetMouseInputEnabled(true)

	for setname in pairs(GAMEMODE.Beats) do
		if setname ~= GAMEMODE.BeatSetHumanDefault then
			dropdown:AddChoice(BeatSetDisplay(setname), setname)
		end
	end
	dropdown:AddChoice(translate.Get("opt_beatset_none"), "none")
	dropdown:AddChoice(translate.Get("opt_beatset_default"), "default")

	dropdown.OnSelect = function(me, index, value, data)
		RunConsoleCommand("zs_beatset_human", data or value)
	end

	dropdown:SetText(BeatSetCurrentDisplay(GAMEMODE.BeatSetHuman, GAMEMODE.BeatSetHumanDefault))
	list:AddItem(dropdown)

	list:AddItem(EasyLabel(Window, WrapOptionText(translate.Get("opt_beatset_zombie"), "DefaultFontSmall", WRAP_W), "DefaultFontSmall", color_white))
	dropdown = MakeDropdown(Window)
	dropdown:SetMouseInputEnabled(true)

	for setname in pairs(GAMEMODE.Beats) do
		if setname ~= GAMEMODE.BeatSetZombieDefault then
			dropdown:AddChoice(BeatSetDisplay(setname), setname)
		end
	end
	dropdown:AddChoice(translate.Get("opt_beatset_none"), "none")
	dropdown:AddChoice(translate.Get("opt_beatset_default"), "default")

	dropdown.OnSelect = function(me, index, value, data)
		RunConsoleCommand("zs_beatset_zombie", data or value)
	end

	dropdown:SetText(BeatSetCurrentDisplay(GAMEMODE.BeatSetZombie, GAMEMODE.BeatSetZombieDefault))
	list:AddItem(dropdown)

	AddSliderRow(translate.Get("opt_crosshair_lines"), function(s)
		s:SetDecimals(0) s:SetMinMax(2, 8) s:SetConVar("zs_crosshairlines")
	end)

	AddSliderRow(translate.Get("opt_crosshair_offset"), function(s)
		s:SetDecimals(0) s:SetMinMax(0, 90) s:SetConVar("zs_crosshairoffset")
	end)

	AddSliderRow(translate.Get("opt_crosshair_thickness"), function(s)
		s:SetDecimals(1) s:SetMinMax(0.5, 2) s:SetConVar("zs_crosshairthickness")
	end)

	AddSliderRow(translate.Get("opt_dmg_number_scale"), function(s)
		s:SetDecimals(1) s:SetMinMax(0.5, 2) s:SetConVar("zs_dmgnumberscale")
	end)

	AddSliderRow(translate.Get("opt_dmg_number_speed"), function(s)
		s:SetDecimals(1) s:SetMinMax(0, 1) s:SetConVar("zs_dmgnumberspeed")
	end)

	AddSliderRow(translate.Get("opt_dmg_number_life"), function(s)
		s:SetDecimals(1) s:SetMinMax(0.2, 1.5) s:SetConVar("zs_dmgnumberlife")
	end)

	AddSliderRow(translate.Get("opt_film_grain_amount"), function(s)
		s:SetDecimals(1) s:SetMinMax(0, 255) s:SetConVar("zs_filmgrainopacity")
	end)

	AddSliderRow(translate.Get("opt_interface_size"), function(s)
		s:SetDecimals(1) s:SetMinMax(0.7, 1.6) s:SetConVar("zs_interfacesize")
	end)

	AddSliderRow(translate.Get("opt_ironsight_zoom"), function(s)
		s:SetDecimals(2) s:SetMinMax(0, 1) s:SetConVar("zs_ironsightzoom")
	end)

	AddSliderRow(translate.Get("opt_beats_volume"), function(s)
		s:SetDecimals(0) s:SetMinMax(0, 100) s:SetConVar("zs_beatsvolume")
	end)

	AddSliderRow(translate.Get("opt_prop_sensitivity"), function(s)
		s:SetDecimals(1) s:SetMinMax(0.1, 4) s:SetConVar("zs_proprotationsens")
	end)

	AddSliderRow(translate.Get("opt_transparency_radius"), function(s)
		s:SetDecimals(0) s:SetMinMax(0, GAMEMODE.TransparencyRadiusMax) s:SetConVar("zs_transparencyradius")
	end)

	AddSliderRow(translate.Get("opt_transparency_radius_3p"), function(s)
		s:SetDecimals(0) s:SetMinMax(0, GAMEMODE.TransparencyRadiusMax) s:SetConVar("zs_transparencyradius3p")
	end)

	list:AddItem(EasyLabel(Window, WrapOptionText(translate.Get("opt_crosshair_color_primary"), "DefaultFontSmall", WRAP_W), "DefaultFontSmall", color_white))
	local colpicker = vgui.Create("DColorMixer", Window)
	colpicker:SetAlphaBar(true)
	colpicker:SetPalette(false)
	colpicker:SetConVarR("zs_crosshair_colr")
	colpicker:SetConVarG("zs_crosshair_colg")
	colpicker:SetConVarB("zs_crosshair_colb")
	colpicker:SetConVarA("zs_crosshair_cola")
	colpicker:SetTall(72)
	list:AddItem(colpicker)

	list:AddItem(EasyLabel(Window, WrapOptionText(translate.Get("opt_crosshair_color_secondary"), "DefaultFontSmall", WRAP_W), "DefaultFontSmall", color_white))
	colpicker = vgui.Create("DColorMixer", Window)
	colpicker:SetAlphaBar(true)
	colpicker:SetPalette(false)
	colpicker:SetConVarR("zs_crosshair_colr2")
	colpicker:SetConVarG("zs_crosshair_colg2")
	colpicker:SetConVarB("zs_crosshair_colb2")
	colpicker:SetConVarA("zs_crosshair_cola2")
	colpicker:SetTall(72)
	list:AddItem(colpicker)

	list:AddItem(EasyLabel(Window, WrapOptionText(translate.Get("opt_aura_color_full"), "DefaultFontSmall", WRAP_W), "DefaultFontSmall", color_white))
	colpicker = vgui.Create("DColorMixer", Window)
	colpicker:SetAlphaBar(false)
	colpicker:SetPalette(false)
	colpicker:SetConVarR("zs_auracolor_full_r")
	colpicker:SetConVarG("zs_auracolor_full_g")
	colpicker:SetConVarB("zs_auracolor_full_b")
	colpicker:SetTall(72)
	list:AddItem(colpicker)

	list:AddItem(EasyLabel(Window, WrapOptionText(translate.Get("opt_aura_color_empty"), "DefaultFontSmall", WRAP_W), "DefaultFontSmall", color_white))
	colpicker = vgui.Create("DColorMixer", Window)
	colpicker:SetAlphaBar(false)
	colpicker:SetPalette(false)
	colpicker:SetConVarR("zs_auracolor_empty_r")
	colpicker:SetConVarG("zs_auracolor_empty_g")
	colpicker:SetConVarB("zs_auracolor_empty_b")
	colpicker:SetTall(72)
	list:AddItem(colpicker)

	Window:SetAlpha(0)
	Window:AlphaTo(255, 0.15, 0)
	Window:MakePopup()
end
