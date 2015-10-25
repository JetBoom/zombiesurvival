AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'Peashooter' Handgun"
	SWEP.Slot = 1
	SWEP.SlotPos = 0

	SWEP.ViewModelFOV = 60
	SWEP.ViewModelFlip = false

	SWEP.HUD3DBone = "v_weapon.p228_Slide"
	SWEP.HUD3DPos = Vector(-0.88, 0.35, 1)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.015
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "pistol"

SWEP.ViewModel = "models/weapons/cstrike/c_pist_p228.mdl"
SWEP.WorldModel = "models/weapons/w_pist_p228.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("Weapon_P228.Single")
SWEP.Primary.Damage = 16
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.1

SWEP.Primary.ClipSize = 18
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 0.08
SWEP.ConeMin = 0.015

SWEP.IronSightsPos = Vector(-6, -1, 2.25)

function SWEP:CanPrimaryAttack()
	if self:Clip1() <= 0 then
		self:EmitSound("Weapon_Pistol.Empty")
		return false
	end
	
	if self:GetNextPrimaryFire() + self.Primary.Delay > CurTime() then
		--return false to prevent firing
		return false
	else
		--return true to allow firing
		return true
	end
end
