function GM:Stats()
	if pMakepStats and pMakepStats:IsValid() then
		pMakepStats:Remove()
	end
	MakepStats()
end

local changedonly
function MakepStats()
/*
	if MySelf:Team() == TEAM_UNDEAD then
		GAMEMODE:CenterNotify(COLOR_RED, "You cannot check your character stats at the time!")
		surface.PlaySound("buttons/button10.wav")
		return
	end
*/

	skillsonly = MySelf:Team() == TEAM_UNDEAD or skillsonly

	PlayMenuOpenSound()
	if pMakepStats and pMakepStats:IsValid() then
		pMakepStats:Remove()
		pMakepStats = nil
	end

	local Window = vgui.Create("DFrame")
	local wide = math.min(ScrW(), 500)
	local tall = math.min(ScrH(), 800)
	Window:SetSize(wide, tall)
	Window:Center()
	Window:SetTitle("")
	Window:SetDeleteOnClose(false)
	pMakepStats = Window

	local y = 8

	local label = EasyLabel(Window, "Stats", "ZSScoreBoardTitle", color_white)
	label:SetPos(wide * 0.5 - label:GetWide() * 0.5, y)
	y = y + label:GetTall() + 8

	local list = vgui.Create("DPanelList", pMakepStats)
	list:EnableVerticalScrollbar()
	list:EnableHorizontal(false)
	list:SetSize(wide - 24, tall - y - 82)
	list:SetPos(12, y)
	list:SetPadding(8)
	list:SetSpacing(4)
	local updatetbl = table.ToAssoc(MySelf:GetActiveSkills())

	local function refresh_button(button)
		button:SetText(changedonly and "Show all stats" or "Show changed stats")
	end

	local function refresh_skillonly_vgui(button)
		button:SetText(skillsonly and "Show stats changed by all" or "Show stats changed by skills")
	end

	local button = EasyButton(Window, "Show changed stats")
	button:SetSize(wide - 20, 35)
	button:SetFont("ZSHUDFontSmallest")
	button:SetPos(wide / 2 - button:GetWide() / 2, tall - 17 - button:GetTall() / 2)

	local skillonly_vgui
	if MySelf:Team() == TEAM_UNDEAD then
		skillonly_vgui = EasyLabel(Window, "Showing stats changed by skills")
		skillonly_vgui:SetFont("ZSHUDFontSmallest")
		skillonly_vgui:SizeToContents()
		
		skillonly_vgui:SetPos(wide / 2 - skillonly_vgui:GetWide() / 2, tall - 52 - skillonly_vgui:GetTall() / 2)
	else
		skillonly_vgui = EasyButton(Window, "Show stats changed by skills")
		skillonly_vgui:SetSize(wide - 20, 35)
		skillonly_vgui:SetFont("ZSHUDFontSmallest")
		skillonly_vgui:SetPos(wide / 2 - skillonly_vgui:GetWide() / 2, tall - 52 - skillonly_vgui:GetTall() / 2)
	end


	local function UpdateList(changedonly, skillsonly)
		for i = 1,#GAMEMODE.SkillModifierFunctions do
			local i = i or 1
			local skillmodifiers = {}
			local gm_modifiers = GAMEMODE.SkillModifiers
			if skillsonly then
				for skillid in pairs(table.ToAssoc(MySelf:GetDesiredActiveSkills())) do
					local modifiers = gm_modifiers[skillid]
					if modifiers then
						for modid, amount in pairs(modifiers) do
							skillmodifiers[modid] = (skillmodifiers[modid] or 0) + amount
						end
					end
				end
			else
				for skillid in pairs(updatetbl)  do
					modifiers = gm_modifiers[skillid]
					if modifiers then
						for modid, amount in pairs(modifiers) do
							skillmodifiers[modid] = (skillmodifiers[modid] or 0) + amount
						end
					end
				end
			end

			local c = skillmodifiers[i] or 0
			if changedonly and c == 0 then continue end
			local d = vgui.Create("DEXChangingLabel", bottom)

			if !table.HasValue(GAMEMODE.SkillModifiersNonMulOnly, i) then
				c = (c*100).."%"
			end
			if (skillmodifiers[i] or 0) >= 0 then
				c = "+"..c
			end
			local colorred = table.HasValue(GAMEMODE.SkillModifiersBadOnly, i) and Color(71,231,119) or Color(238,37,37)
			local colorgreen = table.HasValue(GAMEMODE.SkillModifiersBadOnly, i) and Color(238,37,37) or Color(71,231,119)
			d:SetChangeFunction(function()
				return translate.Format("skillmod_n"..i,c)
			end, true)
			d:SetChangedFunction(function()
				if (skillmodifiers[i] or 0) < 0 then
					d:SetTextColor(colorred)
				elseif (skillmodifiers[i] or 0) > 0 then
					d:SetTextColor(colorgreen)
				else
					d:SetTextColor(Color(255,255,255))
				end
			end)

			d:SetFont("DefaultFont")
			list:AddItem(d)
		end

		local d = vgui.Create("DEXChangingLabel", bottom)
		d:SetText("")
		list:AddItem(d)

	end

	UpdateList(changedonly, skillsonly)

	refresh_button(button)
	button.DoClick = function()
		list:Clear()
		changedonly = !changedonly
		UpdateList(changedonly, skillsonly)
		refresh_button(button)
	end

	if MySelf:Team() ~= TEAM_UNDEAD then
		refresh_skillonly_vgui(skillonly_vgui)
		skillonly_vgui.DoClick = function()
			list:Clear()
			skillsonly = !skillsonly
			UpdateList(changedonly, skillsonly)
			refresh_skillonly_vgui(skillonly_vgui)
		end
	end

--EasyLabel(parent, text, font, textcolor)
	Window:SetAlpha(0)
	Window:AlphaTo(255, 0.15, 0)
	Window:MakePopup()
	return Window
end
