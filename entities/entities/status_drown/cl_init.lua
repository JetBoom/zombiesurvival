include("shared.lua")

function ENT:Draw()
  local drown = self:GetOwner().status_drown
  if drown and drown:IsValid() then
    surface.SetDrawColor(0, 0, 0, 60)
    surface.DrawRect(ScrW() * 0.4, ScrH() * 0.35, ScrW() * 0.2, 12)
    surface.SetDrawColor(30, 30, 230, 180)
    surface.DrawOutlinedRect(ScrW() * 0.4, ScrH() * 0.35, ScrW() * 0.2, 12)
    surface.DrawRect(ScrW() * 0.4, ScrH() * 0.35, ScrW() * 0.2 * (1 - drown:GetDrown()), 12)
    draw.SimpleTextBlurry(translate.Get("breath").." ", "ZSHUDFontSmall", ScrW() * 0.4, ScrH() * 0.35 + 6, COLOR_BLUE, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
  end
end
