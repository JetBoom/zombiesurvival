include("shared.lua")

SWEP.PrintName = "목수의 망치"
SWEP.Description = "간편하고 아주 유용한 도구. 못을 박아 바리케이드를 만들 수 있다.\n보조 공격 버튼: 못 박기\n재장전 버튼: 못 빼기 / 회수\n주 공격 버튼: 좀비의 머리통 으깨기 / 바리케이드 보수\n바리케이드를 보수하면 포인트를 얻고, 다른 이의 못을 빼면 포인트를 잃는다."

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
