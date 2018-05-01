SWEP.PrintName = "Remote Detonation Pack"
SWEP.Description = "A pack of explosives that can be placed on surfaces and detonated remotely, to deal large explosive damage.\nPress PRIMARY ATTACK to deploy.\nPress PRIMARY ATTACK again to detonate.\nPress SPRINT on a deployed detonation pack to disarm and retrieve it."

SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = Model("models/weapons/w_c4_planted.mdl")

SWEP.AmmoIfHas = true

SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Ammo = "sniperpenetratedround"
SWEP.Primary.Delay = 0.1
SWEP.Primary.Automatic = true

SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Ammo = "dummy"

SWEP.MaxStock = 8

SWEP.WalkSpeed = SPEED_NORMAL
SWEP.FullWalkSpeed = SPEED_SLOW

SWEP.NoDeploySpeedChange = true

function SWEP:Initialize()
	self:SetWeaponHoldType("slam")
	GAMEMODE:DoChangeDeploySpeed(self)
	self:HideViewAndWorldModel()
end

function SWEP:SetReplicatedAmmo(count)
	self:SetDTInt(0, count)
end

function SWEP:GetReplicatedAmmo()
	return self:GetDTInt(0)
end

function SWEP:GetWalkSpeed()
	if self:GetPrimaryAmmoCount() > 0 then
		return self.FullWalkSpeed
	end
end

function SWEP:Reload()
end

function SWEP:CanPrimaryAttack()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() then return false end

	if self:GetPrimaryAmmoCount() <= 0 then
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		return false
	end

	return true
end

function SWEP:CanSecondaryAttack()
	return false
end

function SWEP:Deploy()
	gamemode.Call("WeaponDeployed", self:GetOwner(), self)

	return true
end

function SWEP:Holster()
	return true
end
