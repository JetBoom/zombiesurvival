DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = "'ASMD' Shock Rifle"

SWEP.Slot = 3
SWEP.SlotPos = 0

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/cstrike/c_snip_awp.mdl"
SWEP.WorldModel = "models/weapons/w_shot_m3super90.mdl"
SWEP.UseHands = true

SWEP.Primary.Damage = 53.5
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.45

SWEP.Primary.ClipSize = 28
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pulse"
SWEP.Primary.DefaultClip = 25

SWEP.ConeMax = 0.65
SWEP.ConeMin = 0.5

SWEP.WalkSpeed = SPEED_SLOW

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.03)

SWEP.Tier = 5
SWEP.ASMD = true

SWEP.TracerName = "tracer_cosmos"

function SWEP:SendWeaponAnimation()
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed * 0.35)

	timer.Simple(0.2, function()
		if IsValid(self) then
			self:SendWeaponAnim(ACT_VM_DRAW)
			self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed * 10.5)
		end
	end)
end

function SWEP:CanPrimaryAttack()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() or self:GetReloadFinish() > 0 then return false end

	if self:Clip1() < 2 then
		self:EmitSound(self.DryFireSound)
		self:SetNextPrimaryFire(CurTime() + math.max(0.25, self.Primary.Delay))
		return false
	end

	return self:GetNextPrimaryFire() <= CurTime()
end

function SWEP:EmitFireSound(secondary)
	self:EmitSound(secondary and "weapons/zs_asmd/secondary2.wav" or "weapons/zs_asmd/main3.wav", 75, math.random(105, 110))
	self:EmitSound("weapons/zs_inner/innershot.ogg", 72, 231, 0.45, CHAN_AUTO)
end

function SWEP:TakeAmmo(secondary)
	self:TakePrimaryAmmo(secondary and 5 or 2)
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	dmginfo:SetDamageType(DMG_GENERIC)
	return {impact = false}
end

function SWEP:SecondaryAttack()
	if self:Clip1() < 5 or not self:CanPrimaryAttack() then return end

	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay() * 1.35)
	self:EmitFireSound(true)
	self:TakeAmmo(true)

	if SERVER then
		self:ShootSecondary(self.Primary.Damage * 1.67, 1, self:GetCone()/3)
	end

	self.IdleAnimation = CurTime() + self:SequenceDuration()
end
