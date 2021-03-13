AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = "KRISS Vector"
SWEP.Description = "Great for giving multiple zombies bad haircuts"
SWEP.Slot = 2
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = true
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "v_weapon.p90_Release"
	SWEP.HUD3DPos = Vector(-1.35, -0.5, -6.5)
	SWEP.HUD3DAng = Angle(0, 0, 0)
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "smg"

SWEP.ViewModel = "models/weapons/kriss/v_smg_ump45.mdl"
SWEP.WorldModel = "models/weapons/kriss/w_smg_ump45.mdl"
SWEP.ShowWorldModel = false

SWEP.WElements = {
	["element_name"] = { type = "Model", model = "models/weapons/kriss/w_smg_ump45.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-0.9, 1, 2), angle = Angle(-20, 0, -168), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.UseHands = true

SWEP.Primary.Sound = Sound("weapons/kriss/ump45-1.wav")
SWEP.Primary.Damage = 16
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.05
SWEP.Recoil = 0.5
SWEP.ReloadSpeed = 1.0
SWEP.FireAnimSpeed = 1.0
SWEP.Primary.KnockbackScale = 1

SWEP.Primary.ClipSize = 30
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 5 -- smgs use max range as conemax, then / 2 for min
SWEP.ConeMin = 2.5

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SMG1

SWEP.WalkSpeed = SPEED_NORMAL

SWEP.Tier = 4
SWEP.MaxStock = 3

SWEP.IronSightsPos = Vector(3.85, 0, 1.35)
SWEP.IronSightsAng = Vector(0, 0, 0)

--GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.1)

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	local ironsights = self:GetIronsights()

	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay() * (ironsights and 1.3333 or 1))

	self:EmitFireSound()
	self:TakeAmmo()
	self:ShootBullets(self.Primary.Damage * (ironsights and 0.6666 or 1), self.Primary.NumShots * (ironsights and 2 or 1), self:GetCone())
	self.IdleAnimation = CurTime() + self:SequenceDuration()
end