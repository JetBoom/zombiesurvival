include("shared.lua")

SWEP.PrintName = "Remote Detonation Pack"
SWEP.Description = "A pack of explosives that can be placed on surfaces and detonated remotely.\nPress PRIMARY ATTACK to deploy.\nPress PRIMARY ATTACK again to detonate.\nPress SPRINT on a deployed detonation pack to disarm and retrieve it."
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
