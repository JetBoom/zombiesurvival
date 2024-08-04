include("shared.lua")

SWEP.PrintName = "목수의 망치"
SWEP.Description = "보기에는 별것 없어 보이지만, 생존에 꼭 필요한 도구.\n공격 2:시야에 있는 프롭 두개를 못으로 고정.\n재장전:못 회수.\n공격 1: 프롭 수리.\n다른 사람의 못을 빼면 벌을 받고, 수리를 하면 포인트를 받는다."

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
