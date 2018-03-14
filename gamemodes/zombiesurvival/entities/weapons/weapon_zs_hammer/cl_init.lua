include("shared.lua")

SWEP.PrintName = translate.Get("worth_hammer")
SWEP.Description = translate.Get("carpenderhm_desk")

SWEP.ViewModelFOV = 75

function SWEP:DrawHUD()
	if GetGlobalBool("classicmode") then return end

	surface.SetFont("ZSHUDFontSmall")
	local text = translate.Get("right_click_to_hammer_nail")
	local nails = self:GetPrimaryAmmoCount()
	local nTEXW, nTEXH = surface.GetTextSize(text)

	draw.SimpleTextBlurry(translate.Format("nails_x", nails), "ZSHUDFontSmall", ScrW() - nTEXW * 0.5 - 24, ScrH() - nTEXH * 3, nails > 0 and COLOR_LIMEGREEN or COLOR_RED, TEXT_ALIGN_CENTER)

	draw.SimpleTextBlurry(text, "ZSHUDFontSmall", ScrW() - nTEXW * 0.5 - 24, ScrH() - nTEXH * 2, COLOR_LIMEGREEN, TEXT_ALIGN_CENTER)

	if GetConVarNumber("crosshair") ~= 1 then return end
	self:DrawCrosshairDot()
end
