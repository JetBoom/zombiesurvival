SWEP.PrintName = "'Aegis' Barricade Kit"
SWEP.Description = "A ready-to-go, all-in-one board deployer.\nIt automatically deploys the board and then firmly attaches it to almost any surface.\nUse PRIMARY FIRE to deploy boards.\nUse SECONADRY FIRE and RELOAD to rotate the board.\nA ghost of the board shows you if placement is valid or not."
SWEP.Slot = 4
SWEP.SlotPos = 0

SWEP.ViewModel = "models/weapons/c_rpg.mdl"
SWEP.WorldModel = "models/weapons/w_rocket_launcher.mdl"

SWEP.Primary.ClipSize = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "SniperRound"
SWEP.Primary.Delay = 1.25
SWEP.Primary.DefaultClip = 5

SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Ammo = "dummy"
SWEP.Secondary.Automatic = false

SWEP.UseHands = true

SWEP.MaxStock = 5

if CLIENT then
	SWEP.ViewModelFOV = 60
end

SWEP.WalkSpeed = SPEED_SLOWEST

function SWEP:Initialize()
	self:SetWeaponHoldType("rpg")
	GAMEMODE:DoChangeDeploySpeed(self)
end

function SWEP:Deploy()
	GAMEMODE:DoChangeDeploySpeed(self)

	return true
end

function SWEP:CanPrimaryAttack()
	local owner = self:GetOwner()

	if owner:IsHolding() or owner:GetBarricadeGhosting() then return false end

	if self:GetPrimaryAmmoCount() <= 0 then
		self:EmitSound("Weapon_Shotgun.Empty")
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		return false
	end

	return true
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end

util.PrecacheModel("models/props_debris/wood_board05a.mdl")
util.PrecacheSound("npc/dog/dog_servo12.wav")
