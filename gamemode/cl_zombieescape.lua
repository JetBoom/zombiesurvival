include("sh_zombieescape.lua")

if not GM.ZombieEscape then return end

hook.Add("HUDPaint", "zombieescape", function()
	if not MySelf:IsValid() then return end

	if GAMEMODE:GetWave() == 0 and not GAMEMODE:GetWaveActive() and (MySelf:Team() == TEAM_UNDEAD or CurTime() < GAMEMODE:GetWaveStart() - GAMEMODE.ZE_FreezeTime) then
		draw.SimpleTextBlur(translate.Format("ze_humans_are_frozen_until_x", GAMEMODE.ZE_FreezeTime), "ZSHUDFontSmall", ScrW() / 2, ScrH() / 2, COLOR_DARKRED, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end)
