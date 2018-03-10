function MakepOptions()
	PlayMenuOpenSound()

	if pOptions then
		pOptions:SetAlpha(0)
		pOptions:AlphaTo(255, 0.5, 0)
		pOptions:SetVisible(true)
		pOptions:MakePopup()
		return
	end

	local Window = vgui.Create("DFrame")
	local wide = math.min(ScrW(), 500)
	local tall = math.min(ScrH(), 580)
	Window:SetSize(wide, tall)
	Window:Center()
	Window:SetTitle(" ")
	Window:SetDeleteOnClose(false)
	pOptions = Window

	local y = 8

	local label = EasyLabel(Window, translate.Get("options_options"), "ZSHUDFont", color_white)
	label:SetPos(wide * 0.5 - label:GetWide() * 0.5, y)
	y = y + label:GetTall() + 8

	local list = vgui.Create("DPanelList", pOptions)
	list:EnableVerticalScrollbar()
	list:EnableHorizontal(false)
	list:SetSize(wide - 24, tall - y - 12)
	list:SetPos(12, y)
	list:SetPadding(8)
	list:SetSpacing(4)

	gamemode.Call("AddExtraOptions", list, Window)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(translate.Get("options_no_floating_score"))
	check:SetConVar("zs_nofloatingscore")
	check:SizeToContents()
	list:AddItem(check)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(translate.Get("options_iron_sights_crosshair"))
	check:SetConVar("zs_ironsightscrosshair")
	check:SizeToContents()
	list:AddItem(check)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(translate.Get("options_film_mode"))
	check:SetConVar("zs_filmmode")
	check:SizeToContents()
	list:AddItem(check)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(translate.Get("options_beats"))
	check:SetConVar("zs_beats")
	check:SizeToContents()
	list:AddItem(check)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(translate.Get("options_play_music"))
	check:SetConVar("zs_playmusic")
	check:SizeToContents()
	list:AddItem(check)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(translate.Get("options_post_processing"))
	check:SetConVar("zs_postprocessing")
	check:SizeToContents()
	list:AddItem(check)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(translate.Get("options_film_grain"))
	check:SetConVar("zs_filmgrain")
	check:SizeToContents()
	list:AddItem(check)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(translate.Get("options_color_mod"))
	check:SetConVar("zs_colormod")
	check:SizeToContents()
	list:AddItem(check)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(translate.Get("options_draw_pain_flash"))
	check:SetConVar("zs_drawpainflash")
	check:SizeToContents()
	list:AddItem(check)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(translate.Get("options_no_crosshair_rotate"))
	check:SetConVar("zs_nocrosshairrotate")
	check:SizeToContents()
	list:AddItem(check)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(translate.Get("options_auras"))
	check:SetConVar("zs_auras")
	check:SizeToContents()
	list:AddItem(check)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(translate.Get("options_damage_floaters"))
	check:SetConVar("zs_damagefloaters")
	check:SizeToContents()
	list:AddItem(check)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(translate.Get("options_movement_view_roll"))
	check:SetConVar("zs_movementviewroll")
	check:SizeToContents()
	list:AddItem(check)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(translate.Get("options_always_show_nails"))
	check:SetConVar("zs_alwaysshownails")
	check:SizeToContents()
	list:AddItem(check)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(translate.Get("options_no_redeem"))
	check:SetConVar("zs_noredeem")
	check:SizeToContents()
	list:AddItem(check)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(translate.Get("options_always_volunteer"))
	check:SetConVar("zs_alwaysvolunteer")
	check:SizeToContents()
	list:AddItem(check)
	
	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(translate.Get("options_no_boss_pick"))
	check:SetConVar("zs_nobosspick")
	check:SizeToContents()
	list:AddItem(check)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText(translate.Get("options_suicide_on_change"))
	check:SetConVar("zs_suicideonchange")
	check:SizeToContents()
	list:AddItem(check)

	list:AddItem(EasyLabel(Window, translate.Get"options_weapon_hud_mode") , "DefaultFontSmall", color_white)
	local dropdown = vgui.Create("DComboBox", Window)
	dropdown:SetMouseInputEnabled(true)
	dropdown:AddChoice("3D")
	dropdown:AddChoice("2D")
	dropdown:AddChoice("Both")
	dropdown.OnSelect = function(me, index, value, data)
		RunConsoleCommand("zs_weaponhudmode", value == "Both" and 2 or value == "2D" and 1 or 0)
	end
	dropdown:SetText(GAMEMODE.WeaponHUDMode == 2 and "Both" or GAMEMODE.WeaponHUDMode == 1 and "2D" or "3D")
	list:AddItem(dropdown)

	list:AddItem(EasyLabel(Window, translate.Get"options_beatset_human"), "DefaultFontSmall", color_white)
	local dropdown = vgui.Create("DComboBox", Window)
	dropdown:SetMouseInputEnabled(true)
	for setname in pairs(GAMEMODE.Beats) do
		if setname ~= GAMEMODE.BeatSetHumanDefualt then
			dropdown:AddChoice(setname)
		end
	end
	dropdown:AddChoice("none")
	dropdown:AddChoice("default")
	dropdown.OnSelect = function(me, index, value, data)
		RunConsoleCommand("zs_beatset_human", value)
	end
	dropdown:SetText(GAMEMODE.BeatSetHuman == GAMEMODE.BeatSetHumanDefault and "default" or GAMEMODE.BeatSetHuman)
	list:AddItem(dropdown)

	list:AddItem(EasyLabel(Window, translate.Get"options_beatset_zombie"), "DefaultFontSmall", color_white)
	local dropdown = vgui.Create("DComboBox", Window)
	dropdown:SetMouseInputEnabled(true)
	for setname in pairs(GAMEMODE.Beats) do
		if setname ~= GAMEMODE.BeatSetZombieDefualt then
			dropdown:AddChoice(setname)
		end
	end
	dropdown:AddChoice("none")
	dropdown:AddChoice("default")
	dropdown.OnSelect = function(me, index, value, data)
		RunConsoleCommand("zs_beatset_zombie", value)
	end
	dropdown:SetText(GAMEMODE.BeatSetZombie == GAMEMODE.BeatSetZombieDefault and "default" or GAMEMODE.BeatSetZombie)
	list:AddItem(dropdown)

	local slider = vgui.Create("DNumSlider", Window)
	slider:SetDecimals(0)
	slider:SetMinMax(0, 100)
	slider:SetConVar("zs_beatsvolume")
	slider:SetText(translate.Get("options_music_volume"))
	slider:SizeToContents()
	list:AddItem(slider)

	local slider = vgui.Create("DNumSlider", Window)
	slider:SetDecimals(0)
	slider:SetMinMax(0, 512)
	slider:SetConVar("zs_transparencyradius")
	slider:SetText(translate.Get("options_transparency_radius"))
	slider:SizeToContents()
	list:AddItem(slider)

	local slider = vgui.Create("DNumSlider", Window)
	slider:SetDecimals(1)
	slider:SetMinMax(0, 255)
	slider:SetConVar("zs_filmgrainopacity")
	slider:SetText(translate.Get("options_film_grain"))
	slider:SizeToContents()
	list:AddItem(slider)

	list:AddItem(EasyLabel(Window, translate.Get"options_crosshair_p"))
	local colpicker = vgui.Create("DColorMixer", Window)
	colpicker:SetAlphaBar(false)
	colpicker:SetPalette(false)
	colpicker:SetConVarR("zs_crosshair_colr")
	colpicker:SetConVarG("zs_crosshair_colg")
	colpicker:SetConVarB("zs_crosshair_colb")
	colpicker:SetTall(72)
	list:AddItem(colpicker)

	list:AddItem(EasyLabel(Window, translate.Get"options_crosshair_s"))
	local colpicker = vgui.Create("DColorMixer", Window)
	colpicker:SetAlphaBar(false)
	colpicker:SetPalette(false)
	colpicker:SetConVarR("zs_crosshair_colr2")
	colpicker:SetConVarG("zs_crosshair_colg2")
	colpicker:SetConVarB("zs_crosshair_colb2")
	colpicker:SetTall(72)
	list:AddItem(colpicker)

	list:AddItem(EasyLabel(Window, translate.Get"options_hp_full"))
	local colpicker = vgui.Create("DColorMixer", Window)
	colpicker:SetAlphaBar(false)
	colpicker:SetPalette(false)
	colpicker:SetConVarR("zs_auracolor_full_r")
	colpicker:SetConVarG("zs_auracolor_full_g")
	colpicker:SetConVarB("zs_auracolor_full_b")
	colpicker:SetTall(72)
	list:AddItem(colpicker)

	list:AddItem(EasyLabel(Window, translate.Get"options_hp_no"))
	local colpicker = vgui.Create("DColorMixer", Window)
	colpicker:SetAlphaBar(false)
	colpicker:SetPalette(false)
	colpicker:SetConVarR("zs_auracolor_empty_r")
	colpicker:SetConVarG("zs_auracolor_empty_g")
	colpicker:SetConVarB("zs_auracolor_empty_b")
	colpicker:SetTall(72)
	list:AddItem(colpicker)

	Window:SetAlpha(0)
	Window:AlphaTo(255, 0.5, 0)
	Window:MakePopup()
end
