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

	local label = EasyLabel(Window, "옵션", "ZSHUDFont", color_white)
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
	check:SetText("포인트 숫자가 나타나지 않게 합니다.")
	check:SetConVar("zs_nofloatingscore")
	check:SizeToContents()
	list:AddItem(check)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText("정조준 시 조준점을 그립니다.")
	check:SetConVar("zs_ironsightscrosshair")
	check:SizeToContents()
	list:AddItem(check)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText("극장 모드 (화면 위 글씨 대부분 안 보이게 하기)")
	check:SetConVar("zs_filmmode")
	check:SizeToContents()
	list:AddItem(check)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText("라운드 중 BGM을 듣고 싶습니다.")
	check:SetConVar("zs_beats")
	check:SizeToContents()
	list:AddItem(check)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText("마지막 인간 BGM을 들리게 합니다.")
	check:SetConVar("zs_playmusic")
	check:SizeToContents()
	list:AddItem(check)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText("특수 효과(좀비 비전 등)을 보입니다.")
	check:SetConVar("zs_postprocessing")
	check:SizeToContents()
	list:AddItem(check)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText("필름 그레인 효과를 보이게 합니다.")
	check:SetConVar("zs_filmgrain")
	check:SizeToContents()
	list:AddItem(check)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText("화면 위 색깔 효과를 보이게 합니다.")
	check:SetConVar("zs_colormod")
	check:SizeToContents()
	list:AddItem(check)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText("다칠 때 고통 효과를 보이게 합니다.")
	check:SetConVar("zs_drawpainflash")
	check:SizeToContents()
	list:AddItem(check)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText("조준점 회전 금지")
	check:SetConVar("zs_nocrosshairrotate")
	check:SizeToContents()
	list:AddItem(check)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText("좀비일 경우, 인간의 체력을 보여주는 원을 그리지 않습니다.")
	check:SetConVar("zs_auras")
	check:SizeToContents()
	list:AddItem(check)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText("입힌 데미지를 숫자로 보여줍니다.")
	check:SetConVar("zs_damagefloaters")
	check:SizeToContents()
	list:AddItem(check)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText("움직일 때 화면을 회전합니다.")
	check:SetConVar("zs_movementviewroll")
	check:SizeToContents()
	list:AddItem(check)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText("항상 못의 체력을 표시되게 합니다.")
	check:SetConVar("zs_alwaysshownails")
	check:SizeToContents()
	list:AddItem(check)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText("다음 라운드부터 자신의 성불 막기")
	check:SetConVar("zs_noredeem")
	check:SizeToContents()
	list:AddItem(check)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText("항상 좀비 지원자로 고정합니다.")
	check:SetConVar("zs_alwaysvolunteer")
	check:SizeToContents()
	list:AddItem(check)
	
	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText("보스좀비가 되지 않도록 막기")
	check:SetConVar("zs_nobosspick")
	check:SizeToContents()
	list:AddItem(check)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText("자동으로 좀비 클래스 변경 시 자살합니다.")
	check:SetConVar("zs_suicideonchange")
	check:SizeToContents()
	list:AddItem(check)

	list:AddItem(EasyLabel(Window, "무기 탄약 표시 방법", "DefaultFontSmall", color_white))
	local dropdown = vgui.Create("DComboBox", Window)
	dropdown:SetMouseInputEnabled(true)
	dropdown:AddChoice("3D")
	dropdown:AddChoice("2D")
	dropdown:AddChoice("둘 다")
	dropdown.OnSelect = function(me, index, value, data)
		RunConsoleCommand("zs_weaponhudmode", value == "둘 다" and 2 or value == "2D" and 1 or 0)
	end
	dropdown:SetText(GAMEMODE.WeaponHUDMode == 2 and "둘 다" or GAMEMODE.WeaponHUDMode == 1 and "2D" or "3D")
	list:AddItem(dropdown)

	--[[list:AddItem(EasyLabel(Window, "Human ambient beat set", "DefaultFontSmall", color_white))
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

	list:AddItem(EasyLabel(Window, "Zombie ambient beat set", "DefaultFontSmall", color_white))
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
	list:AddItem(dropdown)]]

	local slider = vgui.Create("DNumSlider", Window)
	slider:SetDecimals(0)
	slider:SetMinMax(0, 100)
	slider:SetConVar("zs_beatsvolume")
	slider:SetText("음악 볼륨")
	slider:SizeToContents()
	list:AddItem(slider)

	local slider = vgui.Create("DNumSlider", Window)
	slider:SetDecimals(0)
	slider:SetMinMax(0, 512)
	slider:SetConVar("zs_transparencyradius")
	slider:SetText("투명도")
	slider:SizeToContents()
	list:AddItem(slider)

	local slider = vgui.Create("DNumSlider", Window)
	slider:SetDecimals(1)
	slider:SetMinMax(0, 255)
	slider:SetConVar("zs_filmgrainopacity")
	slider:SetText("필름 그레인 효과의 정도")
	slider:SizeToContents()
	list:AddItem(slider)

	list:AddItem(EasyLabel(Window, "조준점 1차 색상"))
	local colpicker = vgui.Create("DColorMixer", Window)
	colpicker:SetAlphaBar(false)
	colpicker:SetPalette(false)
	colpicker:SetConVarR("zs_crosshair_colr")
	colpicker:SetConVarG("zs_crosshair_colg")
	colpicker:SetConVarB("zs_crosshair_colb")
	colpicker:SetTall(72)
	list:AddItem(colpicker)

	list:AddItem(EasyLabel(Window, "조준점 2차 색상"))
	local colpicker = vgui.Create("DColorMixer", Window)
	colpicker:SetAlphaBar(false)
	colpicker:SetPalette(false)
	colpicker:SetConVarR("zs_crosshair_colr2")
	colpicker:SetConVarG("zs_crosshair_colg2")
	colpicker:SetConVarB("zs_crosshair_colb2")
	colpicker:SetTall(72)
	list:AddItem(colpicker)

	list:AddItem(EasyLabel(Window, "좀비일떄 인간 체력 표시기 - 체력 100%"))
	local colpicker = vgui.Create("DColorMixer", Window)
	colpicker:SetAlphaBar(false)
	colpicker:SetPalette(false)
	colpicker:SetConVarR("zs_auracolor_full_r")
	colpicker:SetConVarG("zs_auracolor_full_g")
	colpicker:SetConVarB("zs_auracolor_full_b")
	colpicker:SetTall(72)
	list:AddItem(colpicker)

	list:AddItem(EasyLabel(Window, "좀비일떄 인간 체력 표시기 - 체력 0%"))
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
