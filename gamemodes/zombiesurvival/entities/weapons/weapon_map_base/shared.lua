SWEP.PrintName = "Item"

SWEP.AnimPrefix = "none"
SWEP.HoldType = "normal"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.DrawCrosshair = false
SWEP.Primary.Sound = Sound("")

SWEP.WorldModel	= "models/weapons/w_crowbar.mdl"

SWEP.WalkSpeed = SPEED_NORMAL

function SWEP:Initialize()
end

function SWEP:Equip()
	local owner = self:GetOwner()
	local children = self:GetChildren()

	if GAMEMODE.ZombieEscape then
		if #children > 0 then
			GAMEMODE:CenterNotifyAll(COLOR_GREEN, owner:GetName() .. " has picked up a ZE Weapon. ("..children[math.random(#children)]:GetName()..")")
			PrintMessage(HUD_PRINTTALK, owner:GetName() .. " has picked up a ZE Weapon. ("..children[math.random(#children)]:GetName()..")")
			if SERVER then
				gamemode.Call("OnZEWeaponPickup", owner, self)
			end
		end
	end
end

function SWEP:SetWeaponHoldType()
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end

function SWEP:Deploy()
	if SERVER then
		local owner = self:GetOwner()

		if GAMEMODE.ZombieEscape then
			owner:SelectWeapon("weapon_zs_zeknife")
		else
			owner:SelectWeapon("weapon_zs_fists")
		end
	end
	return true
end

function SWEP:CanPrimaryAttack()
	return false
end

function SWEP:CanSecondaryAttack()
	return false
end
