function MakepRedeemMenu(silent)
 if frame then if ispanel(frame) then frame:Remove() end end

 
  --local MainMenu

-- timer.Simple(3, function() surface.PlaySound("vo/npc/Barney/ba_hurryup.wav") end)


	MainMenu = vgui.Create("DEXRoundedPanel")
	MainMenu:SetCurve(false)
	MainMenu:SetColor(color_black_alpha220)
	MainMenu:Dock(FILL)
	MainMenu:DockPadding(0, 0, 0, 0)
	MainMenu:DockMargin(0, 0, 0, 0)


	local creditbar = vgui.Create("DEXRoundedPanel", MainMenu)
	creditbar:SetCurve(false)
	creditbar:SetColor(color_black_alpha220)
	creditbar:SetTall(40)
	creditbar:Dock(BOTTOM)
	creditbar:DockPadding(0, 8, 8, 8)

	local credittext = vgui.Create("DLabel", creditbar)
	credittext:SetFont("ZSScoreBoardSubTitle")
	credittext:SetTextColor(COLOR_LIGHTGRAY)
	credittext:SetText(translate.Get("redeemer_credit"))
	credittext:SetContentAlignment(6)
	credittext:Dock(FILL)

	banditImage = vgui.Create("DImage", myParent)
--  banditImage:SetImage( "zombiesurvival/bandit.png" )
	banditImage:Center()
	banditImage:SetTall(40)
	banditImage:SizeToContents()
	banditImage:DockMargin(0, 0, 0, 0)
	banditImage:DockPadding(0, 0, 0, 0)

	-- Tooltip section...

	button = vgui.Create("ZSMenuButton", MainMenu)
	button:SetText(translate.Get("redeemer_save"))
	button:SizeToContents()
	button:Dock(BOTTOM)
	button:DockMargin(90, 8, 0, 220)
	button.DoClick = function()
	local ply = LocalPlayer()
        if ply and ply:IsValid() then
	RunConsoleCommand( "zs_bandit" )
    MainMenu:Remove()
	banditImage:Remove()
	end
	end
	
	local button = vgui.Create("ZSMenuButton", MainMenu)
	button:SetText(translate.Get("redeemer_kill"))
	button:SizeToContents()
	button:Dock(BOTTOM)
	button:DockMargin(30, 8, 0, 0)
    button.DoClick = function()
    MainMenu:Remove()
	banditImage:Remove()
	-- timer.Simple(20, function() surface.PlaySound("buttons/button10.wav") MainMenu:Remove() myImage:Remove() end)
        end
	MainMenu:MakePopup()
end

local PANEL = {}

function PANEL:Init()
	self:SetContentAlignment(4)
	self:SetFont("ZSHUDFontSmall")
end

function PANEL:Paint()
end

vgui.Register("ZSMenuButton", PANEL, "Button")
 
function GM:BuildHelpMenu(window, propertysheet)
end