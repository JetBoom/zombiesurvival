INC_CLIENT()

SWEP.ViewModelFOV = 75

function SWEP:DrawHUD()
	if GetGlobalBool("classicmode") then return end

	local screenscale = BetterScreenScale()

	surface.SetFont("ZSHUDFont")
	local nails = self:GetPrimaryAmmoCount()
	local text = translate.Format("nails_x", nails)
	local nTEXW, nTEXH = surface.GetTextSize(text)

	draw.SimpleTextBlurry(text, "ZSHUDFont", ScrW() - nTEXW * 0.75 - 32 * screenscale, ScrH() - nTEXH * 1.5, nails > 0 and COLOR_LIMEGREEN or COLOR_RED, TEXT_ALIGN_CENTER)

	if GetConVar("crosshair"):GetInt() ~= 1 then return end
	self:DrawCrosshairDot()
end
