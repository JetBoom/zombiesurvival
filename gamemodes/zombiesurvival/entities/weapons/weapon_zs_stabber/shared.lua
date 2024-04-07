DEFINE_BASECLASS("weapon_zs_base")
local BaseClassMelee = baseclass.Get("weapon_zs_basemelee")

SWEP.PrintName = "'Stabber' M1 Garand"

SWEP.Slot = 3
SWEP.SlotPos = 0

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/cstrike/c_snip_g3sg1.mdl"
SWEP.WorldModel = "models/weapons/w_snip_scout.mdl"
SWEP.UseHands = true

SWEP.Primary.Damage = 65
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.36

SWEP.Primary.ClipSize = 8
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "357"
SWEP.Primary.DefaultClip = 25

SWEP.MeleeDamage = 45
SWEP.MeleeRange = 72
SWEP.MeleeSize = 0.95
SWEP.MeleeKnockBack = 0

SWEP.DamageType = DMG_SLASH

SWEP.BloodDecal = "Blood"

SWEP.SwingTime = 0.35
SWEP.SwingRotation = Angle(-8, -20, 0)
SWEP.SwingOffset = Vector(0, -30, 0)

SWEP.Secondary.Automatic = true
SWEP.Secondary.Delay = 1.3

SWEP.ConeMax = 2.75
SWEP.ConeMin = 1.25

SWEP.WalkSpeed = SPEED_SLOW

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.03, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.5, 1)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, "'Puncturer' M1 Garand", "Additional damage to targets stabbed with the bayonet recently, reduced bullet damage", function(wept)
	wept.Primary.Damage = wept.Primary.Damage * 0.85
	wept.BulletCallback = function(attacker, tr, dmginfo)
		local ent = tr.Entity
		if SERVER and ent:IsValidLivingZombie() and ent.PuncStabbed and ent.PuncStabbed > CurTime() then
			dmginfo:SetDamage(dmginfo:GetDamage() * 1.7)
		end
	end
	wept.MeleeHitEntity = function(self, tr, hitent, damagemultiplier)
		hitent.PuncStabbed = CurTime() + 3
		BaseClassMelee.MeleeHitEntity(self, tr, hitent, damagemultiplier)
	end
end)

SWEP.ReloadSpeed = 1.3
SWEP.MeleeFlagged = true

SWEP.Tier = 2

function SWEP:EmitFireSound()
	self:EmitSound("weapons/ak47/ak47-1.wav", 75, 76, 0.53)
	self:EmitSound("weapons/scout/scout_fire-1.wav", 75, 86, 0.67, CHAN_AUTO+20)
end

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
end

function SWEP:PlayStartSwingSound()
end

function SWEP:PlayHitSound()
	self:EmitSound("weapons/melee/golf club/golf_hit-0"..math.random(4)..".ogg")
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("weapons/knife/knife_stab.wav", 70, math.random(95, 105), 1, CHAN_AUTO+20)
end

function SWEP:ShootBullets(dmg, numbul, cone)
	if self:Clip1() == 0 then
		self:EmitSound("npc/roller/blade_out.wav", 70, math.random(80, 84), 0.5, CHAN_AUTO+21)
		self:EmitSound("physics/metal/metal_solid_impact_bullet4.wav", 70, 100, 0.5, CHAN_AUTO+22)
	end

	BaseClass.ShootBullets(self, dmg, numbul, cone)
end

function SWEP:Think()
	if self:IsSwinging() and self:GetSwingEnd() <= CurTime() then
		self:StopSwinging()

		BaseClassMelee.MeleeSwing(self)
	end

	BaseClass.Think(self)
end

function SWEP:CanSecondaryAttack()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() or self:GetReloadFinish() > 0 then return false end

	return self:GetNextSecondaryFire() <= CurTime() and not self:IsSwinging()
end

function SWEP:SecondaryAttack()
	if not self:CanSecondaryAttack() then return end
	self:SetNextAttack()

	if self.SwingTime == 0 then
		BaseClassMelee.MeleeSwing(self)
	else
		BaseClassMelee.StartSwinging(self)
	end
end

function SWEP:DoMeleeAttackAnim()
	self:GetOwner():DoAnimationEvent(ACT_HL2MP_GESTURE_RANGE_ATTACK_SLAM)
end

function SWEP:SetNextAttack()
	local owner = self:GetOwner()
	local armdelay = owner:GetMeleeSpeedMul()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay + self.SwingTime * armdelay)
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay * armdelay)
end

function SWEP:Holster()
	return BaseClassMelee.Holster(self)
end

function SWEP:MeleeHitEntity(tr, hitent, damagemultiplier)
	BaseClassMelee.MeleeHitEntity(self, tr, hitent, damagemultiplier)
end

function SWEP:PlayerHitUtil(owner, damage, hitent, dmginfo)
	BaseClassMelee.PlayerHitUtil(self, owner, damage, hitent, dmginfo)
end

function SWEP:PostHitUtil(owner, hitent, dmginfo, tr, vel)
	BaseClassMelee.PostHitUtil(self, owner, hitent, dmginfo, tr, vel)
end

function SWEP:SetupDataTables()
	BaseClassMelee.SetupDataTables(self)
end

function SWEP:StopSwinging()
	BaseClassMelee.StopSwinging(self)
end

function SWEP:IsSwinging()
	return BaseClassMelee.IsSwinging(self)
end

function SWEP:SetSwingEnd(swingend)
	self:SetDTFloat(3, swingend)
end

function SWEP:GetSwingEnd()
	return self:GetDTFloat(3)
end
