function GM:Stats()
	if pMakepStats and pMakepStats:IsValid() then
		pMakepStats:Remove()
	end
	MakepStats()
end

function MakepStats()
	if MySelf:Team() == TEAM_UNDEAD then
		GAMEMODE:CenterNotify(COLOR_RED, "You cannot check your character stats at the time!")
		surface.PlaySound("buttons/button10.wav")
		return
	end

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
	list:SetSize(wide - 24, tall - y - 12)
	list:SetPos(12, y)
	list:SetPadding(8)
	list:SetSpacing(4)
	local updatetbl = table.ToAssoc(MySelf:GetActiveSkills())
	for i = 1,#GAMEMODE.SkillModifierFunctions do
		local i = i or 1
		local skillmodifiers = {}
		local gm_modifiers = GAMEMODE.SkillModifiers
		for skillid in pairs(updatetbl)  do
			modifiers = gm_modifiers[skillid]
			if modifiers then
				for modid, amount in pairs(modifiers) do
					skillmodifiers[modid] = (skillmodifiers[modid] or 0) + amount
				end
			end
		end

		local d = vgui.Create("DEXChangingLabel", bottom)
		local c = skillmodifiers[i] or 0

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
		local notbl = {}
--		local notbl = {10,107,71,75,82,86,87}
		d:SetFont("DefaultFont")
		if !table.HasValue(notbl,i) then
			list:AddItem(d) 
		end
		if table.HasValue(notbl,i) then
			d:Remove()
		end
	end
--EasyLabel(parent, text, font, textcolor)
	Window:SetAlpha(0)
	Window:AlphaTo(255, 0.15, 0)
	Window:MakePopup()
	return Window
end
