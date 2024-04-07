SWEP.PrintName = "'Ripper' Discblade Launcher"
SWEP.Description = "An unusual weapon capable of launching sharp discs which bounce and that can headshot zombies."

SWEP.Base = "weapon_zs_baseproj"

SWEP.HoldType = "crossbow"

SWEP.ViewModel = "models/weapons/cstrike/c_pist_glock18.mdl"
SWEP.WorldModel = "models/weapons/w_smg_ump45.mdl"

SWEP.UseHands = false

SWEP.CSMuzzleFlashes = false

SWEP.Primary.Sound = Sound("Weapon_Crossbow.Single")
SWEP.Primary.Delay = 15/33
SWEP.Primary.Automatic = true
SWEP.Primary.Damage = 62

SWEP.Primary.ClipSize = 8
SWEP.Primary.Ammo = "XBowBolt"
SWEP.Primary.DefaultClip = 15

SWEP.WalkSpeed = SPEED_SLOWER

SWEP.Tier = 4

SWEP.ConeMax = 1.35
SWEP.ConeMin = 0.95

SWEP.HeadshotMulti = 2.2

SWEP.ReloadSpeed = 0.72

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.04)

function SWEP:EmitFireSound(secondary)
	self:EmitSound("npc/roller/blade_cut.wav", 75, secondary and 56 or 66, 0.73)
	self:EmitSound("weapons/m249/m249-1.wav", 75, secondary and 86 or 146, 0.67, CHAN_AUTO+20)
end

function SWEP:EmitReloadSound()
	if IsFirstTimePredicted() then
		self:EmitSound("weapons/357/357_reload1.wav", 75, 65, 1, CHAN_WEAPON + 21)
		self:EmitSound("weapons/ar2/ar2_reload_push.wav", 70, 67, 0.85, CHAN_WEAPON + 22)
	end
end

function SWEP:EmitReloadFinishSound()
	if IsFirstTimePredicted() then
		self:EmitSound("weapons/galil/galil_boltpull.wav", 70, 110)
	end
end

function SWEP:SetLastFired(float)
	self:SetDTFloat(8, float)
end

function SWEP:GetLastFired()
	return self:GetDTFloat(8)
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
	self:SetLastFired(CurTime())

	self:EmitFireSound()
	self:TakeAmmo()
	self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())
	self.IdleAnimation = CurTime() + self:SequenceDuration()
end
