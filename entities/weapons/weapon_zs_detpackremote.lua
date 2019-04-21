AddCSLuaFile()

SWEP.PrintName = "Detonation Pack Remote"
SWEP.Description = "Allows the user to remotely detonate their detonation packs."
SWEP.Slot = 4
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFOV = 50
	SWEP.BobScale = 0.5
	SWEP.SwayScale = 0.5
end

SWEP.ViewModel = "models/weapons/c_slam.mdl"
SWEP.WorldModel = "models/weapons/w_slam.mdl"
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.WalkSpeed = SPEED_NORMAL

SWEP.NoMagazine = true
SWEP.Undroppable = true
SWEP.NoPickupNotification = true

SWEP.HoldType = "slam"

SWEP.NoDeploySpeedChange = true

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
end

if SERVER then
function SWEP:Think()
	for _, ent in pairs(ents.FindByClass("prop_detpack")) do
		if ent:GetOwner() == self:GetOwner() then
			return
		end
	end

	self:GetOwner():StripWeapon(self:GetClass())
end
end

function SWEP:PrimaryAttack()
	self:SendWeaponAnim(ACT_SLAM_DETONATOR_DETONATE)

	if CLIENT then return end

	for _, ent in pairs(ents.FindByClass("prop_detpack")) do
		if ent:GetOwner() == self:GetOwner() and ent:GetExplodeTime() == 0 then
			ent:SetExplodeTime(CurTime() + ent.ExplosionDelay)
		end
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
	return false
end

function SWEP:Deploy()
	gamemode.Call("WeaponDeployed", self:GetOwner(), self)

	self:SendWeaponAnim(ACT_SLAM_DETONATOR_IDLE)

	return true
end

function SWEP:Holster()
	return true
end

if not CLIENT then return end

function SWEP:DrawWeaponSelection(x, y, w, h, alpha)
	self:BaseDrawWeaponSelection(x, y, w, h, alpha)
end

function SWEP:Think()
end
