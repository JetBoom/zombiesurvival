AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'Crackler' 돌격 소총"
	SWEP.Slot = 2
	SWEP.SlotPos = 0

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "v_weapon.famas"
	SWEP.HUD3DPos = Vector(1.1, -3.5, 10)
	SWEP.HUD3DScale = 0.02
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/cstrike/c_rif_famas.mdl"
SWEP.WorldModel = "models/weapons/w_rif_famas.mdl"
SWEP.UseHands = true

SWEP.ReloadSound = Sound("Weapon_FAMAS.Clipout")
SWEP.Primary.Sound = Sound("Weapon_FAMAS.Single")
SWEP.Primary.Damage = 12
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.3
SWEP.Primary.Recoil = 3.2

SWEP.Primary.ClipSize = 24
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 0.28
SWEP.ConeMin = 0.15

SWEP.WalkSpeed = SPEED_SLOW

SWEP.IronSightsPos = Vector(-3, 3, 2)

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	for i = 0, 2 do
		timer.Create("cracler" .. self:EntIndex() .. CurTime() .. i, 0.05 * i, 1, function()
			self:EmitFireSound()
			self:TakeAmmo()
			if self:Clip1() > 0 then
				self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())
			end
		end)
	end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.IdleAnimation = CurTime() + self:SequenceDuration()
end
