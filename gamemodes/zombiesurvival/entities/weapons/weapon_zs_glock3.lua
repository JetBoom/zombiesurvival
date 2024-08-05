AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'Crossfire' 글록 3"
	SWEP.Slot = 1
	SWEP.SlotPos = 0

	SWEP.ViewModelFOV = 50
	SWEP.ViewModelFlip = false

	SWEP.HUD3DBone = "v_weapon.Glock_Slide"
	SWEP.HUD3DPos = Vector(5, 0.25, -0.8)
	SWEP.HUD3DAng = Angle(90, 0, 0)
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "pistol"

SWEP.ViewModel = "models/weapons/cstrike/c_pist_glock18.mdl"
SWEP.WorldModel = "models/weapons/w_pist_glock18.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("Weapon_Glock.Single")
SWEP.Primary.Damage = 17
SWEP.Primary.NumShots = 0
SWEP.Primary.Delay = 0.3
SWEP.Primary.Recoil = 3.8

SWEP.Primary.ClipSize = 7
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 1.254
SWEP.ConeMin = 0.254

SWEP.IronSightsPos = Vector(-5.75, 10, 2.7)

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	self:TakeAmmo()
	
	for i = 0, 2 do
		timer.Simple(0.07 * i, function()
		self:EmitFireSound()
			self:ShootBullets(self.Primary.Damage, 1, self:GetCone())
			self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		end)
	end
	self.IdleAnimation = CurTime() + self:SequenceDuration()
end

function SWEP:ShootBullets(dmg, numbul, cone)
	local owner = self.Owner
	--owner:MuzzleFlash()
	self:SendWeaponAnimation()
	owner:DoAttackEvent()

	self:StartBulletKnockback()
	
	self:DoRecoil()
	if SERVER then
		owner:FireBullets({Num = numbul, Src = owner:GetShootPos(), Dir = owner:GetAimVector() + Vector(math.Rand(-cone, cone), math.Rand(-cone, cone), 0), Spread = Vector(cone, cone, 0), Tracer = 1, TracerName = self.TracerName, Force = dmg * 0.1, Damage = dmg, Callback = self.BulletCallback})
	end
	self:DoBulletKnockback(self.Primary.KnockbackScale * 0.05)
	self:EndBulletKnockback()
	
	self.LastFired = CurTime()
end

function SWEP:Think()
	if CLIENT then
		if self:GetIronsights() and not self.Owner:KeyDown(IN_ATTACK2) then
			self:SetIronsights(false)
		end
		if self.LastFired + self.ConeResetDelay > CurTime() then
			local multiplier = 1
			multiplier = multiplier + (self.ConeMax * 10) * ((self.LastFired + self.ConeResetDelay - CurTime()) / self.ConeResetDelay)
			self.ConeMul = math.min(multiplier, 1)
		end
	else
		if self.IdleAnimation and self.IdleAnimation <= CurTime() then
			self.IdleAnimation = nil
			self:SendWeaponAnim(ACT_VM_IDLE)
		end
		if self:GetIronsights() and not self.Owner:KeyDown(IN_ATTACK2) then
			self:SetIronsights(false)
		end
		
		if self.LastFired + self.ConeResetDelay > CurTime() then
			local multiplier = 1
			multiplier = multiplier + (self.ConeMax * 10) * ((self.LastFired + self.ConeResetDelay - CurTime()) / self.ConeResetDelay)
			self.ConeMul = math.min(multiplier, 1)
		end
	end
end
