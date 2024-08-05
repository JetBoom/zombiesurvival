AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'오버차지' 펄스 방출기"
	SWEP.Description = "좀비 대재앙 이전, 블랙 메사의 무기개발부서가 개발한 무기로, 최대 20개까지의 펄스 배터리를 저장한 후 발사할 수 있다."
	SWEP.Slot = 3
	SWEP.SlotPos = 0

	SWEP.HUD3DBone = "Base"
	SWEP.HUD3DPos = Vector(7.791, -2.597, -7.792)
	SWEP.HUD3DScale = 0.04
	
	SWEP.ViewModelFlip = false
end

sound.Add(
{
	name = "Weapon_pulseboom.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	soundlevel = 100,
	sound = "weapons/gauss/fire1.wav"
})

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/v_physcannon.mdl"
SWEP.WorldModel = "models/weapons/w_physics.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.ReloadDelay = 0.15

SWEP.ReloadSound = Sound("weapons/ar2/ar2_relaod_push.wav")
SWEP.Primary.Sound = Sound("Weapon_pulseboom.Single")
SWEP.Primary.Recoil = 8.5
SWEP.Primary.Damage = 8
SWEP.Primary.NumShots = math.random(2)
SWEP.Primary.Delay = 1.5

SWEP.Primary.ClipSize = 20
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pulse"
SWEP.Primary.DefaultClip = 20

SWEP.ConeMax = 0.20
SWEP.ConeMin = 0.05

SWEP.WalkSpeed = SPEED_SLOWEST
SWEP.TracerName = "AirboatGunHeavyTracer"

function SWEP:SetIronsights()
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	GenericBulletCallback(attacker, tr, dmginfo)
	local e = EffectData()
		e:SetOrigin(tr.HitPos)
		e:SetNormal(tr.HitNormal)
		e:SetRadius(3)
		e:SetMagnitude(1)
		e:SetScale(1)
	util.Effect("cball_bounce", e)
end

SWEP.reloadtimer = 0
SWEP.nextreloadfinish = 0

function SWEP:Reload()
	if self.reloading then return end

	if self:GetNextReload() <= CurTime() and self:Clip1() < self.Primary.ClipSize and 0 < self.Owner:GetAmmoCount(self.Primary.Ammo) then
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		self.reloading = true
		self.reloadtimer = CurTime() + self.ReloadDelay
		self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)
		self.Owner:DoReloadEvent()
		self:SetNextReload(CurTime() + self:SequenceDuration())
	end
end

function SWEP:PrimaryAttack()
	if self:CanPrimaryAttack() then
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		self:EmitSound(self.Primary.Sound)

		local clip = self:Clip1()

		self:ShootBullets(self.Primary.Damage, self.Primary.NumShots * clip, self:GetCone())

		self:TakePrimaryAmmo(clip)
		self.Owner:ViewPunch(clip * 0.5 * self.Primary.Recoil * Angle(math.Rand(-0.1, -0.1), math.Rand(-0.1, 0.1), 0))

		self.Owner:SetGroundEntity(NULL)
		self.Owner:SetVelocity(-10 * clip * self.Owner:GetAimVector())

		self.IdleAnimation = CurTime() + self:SequenceDuration()
	end
end

function SWEP:Think()
	if self.reloading and self.reloadtimer < CurTime() then
		self.reloadtimer = CurTime() + self.ReloadDelay
		self:SendWeaponAnim(ACT_VM_RELOAD)

		self.Owner:RemoveAmmo(1, self.Primary.Ammo, false)
		self:SetClip1(self:Clip1() + 1)
		self:EmitSound("weapons/physcannon/superphys_hold_loop.wav")

		if self.Primary.ClipSize <= self:Clip1() or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 or not self.Owner:KeyDown(IN_RELOAD) then
			self.nextreloadfinish = CurTime() + self.ReloadDelay
			self.reloading = false
			self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		end
	end

	local nextreloadfinish = self.nextreloadfinish
	if nextreloadfinish ~= 0 and nextreloadfinish < CurTime() then
		self:SendWeaponAnim(ACT_SHOTGUN_PUMP)
		self:EmitSound("npc/scanner/combat_scan3.wav")
		self.nextreloadfinish = 0
	end

	if self.IdleAnimation and self.IdleAnimation <= CurTime() then
		self.IdleAnimation = nil
		self:SendWeaponAnim(ACT_VM_IDLE)
	end

	if self:GetIronsights() and not self.Owner:KeyDown(IN_ATTACK2) then
		self:SetIronsights(false)
	end
end

function SWEP:CanPrimaryAttack()
	if self.Owner:IsHolding() or self.Owner:GetBarricadeGhosting() then return false end

	if self:Clip1() <= 0 then
		self:EmitSound("buttons/combine_button_locked.wav")
		self:SetNextPrimaryFire(CurTime() + 0.25)
		return false
	end

	if self.reloading then
		if self:Clip1() < self.Primary.ClipSize then
			self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
		else
			self:SendWeaponAnim(ACT_SHOTGUN_PUMP)
			self:EmitSound("npc/scanner/scanner_nearmiss2.wav")
		end
		self.reloading = false
		self:SetNextPrimaryFire(CurTime() + 0.25)
		return false
	end

	return self:GetNextPrimaryFire() <= CurTime()
end
