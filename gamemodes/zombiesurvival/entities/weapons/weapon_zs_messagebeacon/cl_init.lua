include("shared.lua")

SWEP.PrintName = "Message Beacon"
SWEP.Description = "This beacon allows you to display messages to all other humans in range.\nPress SECONDARY ATTACK to select different messages.\nPress PRIMARY ATTACK to deploy.\nPress SPRINT on a deployed message beacon that you own to pick it up."
SWEP.DrawCrosshair = false

SWEP.Slot = 4
SWEP.SlotPos = 0

function SWEP:Deploy()
	gamemode.Call("WeaponDeployed", self.Owner, self)

	return true
end

function SWEP:DrawHUD()
	if GetConVarNumber("crosshair") ~= 1 then return end
	self:DrawCrosshairDot()
end

function SWEP:PrimaryAttack()
end

function SWEP:DrawWeaponSelection(...)
	return self:BaseDrawWeaponSelection(...)
end

function SWEP:Think()
end

local function okclick(self)
	RunConsoleCommand("setmessagebeaconmessage", self:GetParent().Choice)
	self:GetParent():Close()
end

local function onselect(self, index, value, data)
	self:GetParent().Choice = data
end

local Menu
function SWEP:SecondaryAttack()
	if Menu and Menu:Valid() then
		Menu:SetVisible(true)
		return
	end

	Menu = vgui.Create("DFrame")
	Menu:SetDeleteOnClose(false)
	Menu:SetSize(200, 100)
	Menu:SetTitle("Select a message")
	Menu:Center()
	Menu.Choice = 1

	local choice = vgui.Create("DComboBox", Menu)
	for k, v in ipairs(GAMEMODE.ValidBeaconMessages) do
		choice:AddChoice(translate.Get(v), k)
	end
	choice:ChooseOption(GAMEMODE.ValidBeaconMessages[1], 1)
	choice:SizeToContents()
	choice:SetWide(Menu:GetWide() - 16)
	choice:Center()
	choice.OnSelect = onselect

	local ok = EasyButton(Menu, "OK", 8, 4)
	ok:AlignBottom(8)
	ok:CenterHorizontal()
	ok.DoClick = okclick

	Menu:MakePopup()
end
