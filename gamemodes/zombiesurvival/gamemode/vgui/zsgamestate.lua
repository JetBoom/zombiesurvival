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
	self:SetTextFont("ZSHUDFontTiny")

	self.m_Text1.Paint = self.Text1Paint
	self.m_Text2.Paint = self.Text2Paint
	self.m_Text3.Paint = self.Text3Paint

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

function PANEL:PerformLayout()
	local hs = self:GetTall() * 0.5
	self.m_HumanCount:SetSize(hs, hs)
	self.m_ZombieCount:SetSize(hs, hs)
	self.m_ZombieCount:AlignTop(hs)

	self.m_Text1:SetWide(self:GetWide())
	self.m_Text1:SizeToContentsY()
	self.m_Text1:MoveRightOf(self.m_HumanCount, 12)
	self.m_Text1:AlignTop(4)
	self.m_Text2:SetWide(self:GetWide())
	self.m_Text2:SizeToContentsY()
	self.m_Text2:MoveRightOf(self.m_HumanCount, 12)
	self.m_Text2:CenterVertical()
	self.m_Text3:SetWide(self:GetWide())
	self.m_Text3:SizeToContentsY()
	self.m_Text3:MoveRightOf(self.m_HumanCount, 12)
	self.m_Text3:AlignBottom(4)
end

function PANEL:Text1Paint()
	local text
	local override = MySelf:IsValid() and GetGlobalString("hudoverride"..MySelf:Team(), "")

	if override and #override > 0 then
		text = override
	else
		local wave = GAMEMODE:GetWave()
		if GAMEMODE:IsEscapeSequence() then
			text = translate.Get(MySelf:IsValid() and MySelf:Team() == TEAM_UNDEAD and "prop_obj_exit_z" or "prop_obj_exit_h")
		elseif wave <= 0 then
			text = translate.Get("prepare_yourself")
		elseif GAMEMODE.ZombieEscape then
			text = translate.Get("zombie_escape")

			-- I'm gonna leave this as 2 for now, since it is 2 on NoX.
			--if GAMEMODE.RoundLimit > 0 then
				round = GAMEMODE.CurrentRound
				text = text .. " - " .. translate.Format("round_x_of_y", round, 2)
			--end
		else
			local maxwaves = GAMEMODE:GetNumberOfWaves()
			if maxwaves ~= -1 then
				text = translate.Format("wave_x_of_y", wave, maxwaves)
				if not GAMEMODE:GetWaveActive() then
					text = translate.Get("intermission").." - "..text
				end
			elseif not GAMEMODE:GetWaveActive() then
				text = translate.Get("intermission")
			end
		end
	end

	if text then
		draw.SimpleText(text, self.Font, 0, 0, COLOR_GRAY)
	end

	return true
end

function PANEL:Text2Paint()
	if GAMEMODE:GetWave() <= 0 then
		local col
		local timeleft = math.max(0, GAMEMODE:GetWaveStart() - CurTime())
		if timeleft < 10 then
			local glow = math.sin(RealTime() * 8) * 200 + 255
			col = Color(255, glow, glow)
		else
			col = COLOR_GRAY
		end

		draw.SimpleText(translate.Format("zombie_invasion_in_x", util.ToMinutesSecondsCD(timeleft)), self.Font, 0, 0, col)
	elseif GAMEMODE:GetWaveActive() then
		local waveend = GAMEMODE:GetWaveEnd()
		if waveend ~= -1 then
			local timeleft = math.max(0, waveend - CurTime())
			draw.SimpleText(translate.Format("wave_ends_in_x", util.ToMinutesSecondsCD(timeleft)), self.Font, 0, 0, 10 < timeleft and COLOR_GRAY or Color(255, 0, 0, math.abs(math.sin(RealTime() * 8)) * 180 + 40))
		end
	else
		local wavestart = GAMEMODE:GetWaveStart()
		if wavestart ~= -1 then
			local timeleft = math.max(0, wavestart - CurTime())
			draw.SimpleText(translate.Format("next_wave_in_x", util.ToMinutesSecondsCD(timeleft)), self.Font, 0, 0, 10 < timeleft and COLOR_GRAY or Color(255, 0, 0, math.abs(math.sin(RealTime() * 8)) * 180 + 40))
		end
	end

	return true
end

function PANEL:Text3Paint()
	if MySelf:IsValid() then
		if MySelf:Team() == TEAM_UNDEAD then
			local toredeem = GAMEMODE:GetRedeemBrains()
			if toredeem > 0 then
				draw.SimpleText(translate.Format("brains_eaten_x", MySelf:Frags().." / "..toredeem), self.Font, 0, 0, COLOR_SOFTRED)
			else
				draw.SimpleText(translate.Format("brains_eaten_x", MySelf:Frags()), self.Font, 0, 0, COLOR_SOFTRED)
			end
		else
			--draw.SimpleText(translate.Format("points_x", MySelf:GetPoints().." / "..MySelf:Frags()), self.Font, 0, 0, COLOR_DARKRED)
			draw.SimpleText("Points: "..MySelf:GetPoints().."  Score: "..MySelf:Frags(), self.Font, 0, 0, COLOR_SOFTRED)
		end
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
