SWEP.Primary.Sound = Sound("Weapon_Pistol.Single")
SWEP.DryFireSound = Sound("Weapon_Pistol.Empty")
SWEP.Primary.Damage = 30
SWEP.Primary.KnockbackScale = 1
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.15

SWEP.ConeMax = 1.5
SWEP.ConeMin = 0.5
SWEP.ConeRamp = 2

SWEP.CSMuzzleFlashes = true

SWEP.Primary.ClipSize = 8
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
SWEP.RequiredClip = 1

SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "dummy"

SWEP.WalkSpeed = SPEED_NORMAL

SWEP.HoldType = "pistol"
SWEP.IronSightsHoldType = "ar2"

SWEP.IronSightsPos = Vector(0, 0, 0)

SWEP.EmptyWhenPurchased = true
SWEP.AllowQualityWeapons = true

SWEP.Recoil = 0

SWEP.ReloadSpeed = 1.0
SWEP.FireAnimSpeed = 1.0

SWEP.IdleActivity = ACT_VM_IDLE

SWEP.Weight = 5

function SWEP:Initialize()
	if not self:IsValid() then return end --???

	self:SetWeaponHoldType(self.HoldType)
	GAMEMODE:DoChangeDeploySpeed(self)

	-- Higher tier guns auto swap to with a higher priority than low tier ones.
	if self.Weight and self.Tier then
		self.Weight = self.Weight + self.Tier
	end

	-- Maybe we didn't want to convert the weapon to the new system...
	if self.Cone then
		self.ConeMin = self.ConeIronCrouching
		self.ConeMax = self.ConeMoving
		self.ConeRamp = 2
	end

	if CLIENT then
		self:CheckCustomIronSights()
		self:Anim_Initialize()
	end
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())

	self:EmitFireSound()
	self:TakeAmmo()
	self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())
	self.IdleAnimation = CurTime() + self:SequenceDuration()
end

function SWEP:SecondaryAttack()
	if self:GetNextSecondaryFire() <= CurTime() and not self:GetOwner():IsHolding() and self:GetReloadFinish() == 0 then
		self:SetIronsights(true)
	end
end

function SWEP:Reload()
	local owner = self:GetOwner()
	if owner:IsHolding() then return end

	if self:GetIronsights() then
		self:SetIronsights(false)
	end

	-- Custom reload function to change reload speed.
	if self:CanReload() then
		self.IdleAnimation = CurTime() + self:SequenceDuration()
		self:SetNextReload(self.IdleAnimation)
		self:SetReloadStart(CurTime())

		self:SendReloadAnimation()
		self:ProcessReloadEndTime()

		owner:DoReloadEvent()

		self:EmitReloadSound()
	end
end

function SWEP:GetPrimaryClipSize()
	local owner = self:GetOwner()
	local multi = self.Primary.ClipSize/self.RequiredClip >= 8 and owner:HasTrinket("extendedmag") and 1.15 or 1

	return math.floor(self:GetMaxClip1() * multi)
end

function SWEP:FinishReload()
	self:SendWeaponAnim(ACT_VM_IDLE)
	self:SetNextReload(0)
	self:SetReloadStart(0)
	self:SetReloadFinish(0)
	self:EmitReloadFinishSound()

	local owner = self:GetOwner()
	if not owner:IsValid() then return end

	local max1 = self:GetPrimaryClipSize()
	local max2 = self:GetMaxClip2()

	if max1 > 0 then
		local ammotype = self:GetPrimaryAmmoType()
		local spare = owner:GetAmmoCount(ammotype)
		local current = self:Clip1()
		local needed = max1 - current

		needed = math.min(spare, needed)

		self:SetClip1(current + needed)
		if SERVER then
			owner:RemoveAmmo(needed, ammotype)
		end
	end

	if max2 > 0 then
		local ammotype = self:GetSecondaryAmmoType()
		local spare = owner:GetAmmoCount(ammotype)
		local current = self:Clip2()
		local needed = max2 - current

		needed = math.min(spare, needed)

		self:SetClip2(current + needed)
		if SERVER then
			owner:RemoveAmmo(needed, ammotype)
		end
	end
end

function SWEP:GetCone()
	local owner = self:GetOwner()

	local basecone = self.ConeMin
	local conedelta = self.ConeMax - basecone

	local orphic = not owner.Orphic and 1 or self:GetIronsights() and 0.9 or 1.1
	local tiervalid = (self.Tier or 1) <= 3
	local spreadmul = (owner.AimSpreadMul or 1) - ((tiervalid and owner:HasTrinket("refinedsub")) and 0.27 or 0)

	if owner.TrueWooism then
		return (basecone + conedelta * 0.5 ^ self.ConeRamp) * spreadmul * orphic
	end

	if not owner:OnGround() or self.ConeMax == basecone then return self.ConeMax end

	local multiplier = math.min(owner:GetVelocity():Length() / self.WalkSpeed, 1) * 0.5

	local ironsightmul = 0.25 * (owner.IronsightEffMul or 1)
	local ironsightdiff = 0.25 - ironsightmul
	multiplier = multiplier + ironsightdiff

	if not owner:Crouching() then multiplier = multiplier + 0.25 end
	if not self:GetIronsights() then multiplier = multiplier + ironsightmul end

	return (basecone + conedelta * (self.FixedAccuracy and 0.6 or multiplier) ^ self.ConeRamp) * spreadmul * orphic
end

function SWEP:GetWalkSpeed()
	local owner = self:GetOwner()
	if self:GetIronsights() then
		return math.min(self.WalkSpeed, math.max(90, self.WalkSpeed * (owner.Wooism and 0.75 or 0.5)))
	end

	return self.WalkSpeed
end

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound)
end

function SWEP:SetIronsights(b)
	self:SetDTBool(0, b)

	if self.IronSightsHoldType then
		if b then
			self:SetWeaponHoldType(self.IronSightsHoldType)
		else
			self:SetWeaponHoldType(self.HoldType)
		end
	end

	gamemode.Call("WeaponDeployed", self:GetOwner(), self)
end

function SWEP:Deploy()
	self:SetNextReload(0)
	self:SetReloadFinish(0)

	gamemode.Call("WeaponDeployed", self:GetOwner(), self)

	self:SetIronsights(false)

	self.IdleAnimation = CurTime() + self:SequenceDuration()

	if CLIENT then
		self:CheckCustomIronSights()
	end

	return true
end

function SWEP:Holster()
	if CLIENT then
		self:Anim_Holster()
	end

	return true
end

SWEP.AU = 0
function SWEP:TakeAmmo()
	if self.AmmoUse then
		self.AU = self.AU + self.AmmoUse
		if self.AU >= 1 then
			local use = math.floor(self.AU)
			self:TakePrimaryAmmo(use)
			self.AU = self.AU - use
		end
	else
		self:TakePrimaryAmmo(self.RequiredClip)
	end
end

function SWEP:EmitReloadSound()
	if self.ReloadSound and IsFirstTimePredicted() then
		self:EmitSound(self.ReloadSound, 75, 100, 1, CHAN_WEAPON + 21)
	end
end

function SWEP:EmitReloadFinishSound()
	if self.ReloadFinishSound and IsFirstTimePredicted() then
		self:EmitSound(self.ReloadFinishSound, 75, 100, 1, CHAN_WEAPON + 21)
	end
end

function SWEP:CanReload()
	return self:GetNextReload() <= CurTime() and self:GetReloadFinish() == 0 and
		(
			self:GetMaxClip1() > 0 and self:Clip1() < self:GetPrimaryClipSize() and self:ValidPrimaryAmmo() and self:GetOwner():GetAmmoCount(self:GetPrimaryAmmoType()) > 0
			or self:GetMaxClip2() > 0 and self:Clip1() < self:GetMaxClip2() and self:ValidSecondaryAmmo() and self:GetOwner():GetAmmoCount(self:GetSecondaryAmmoType()) > 0
		)
end

function SWEP:GetIronsights()
	return self:GetDTBool(0)
end

function SWEP:CanPrimaryAttack()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() or self:GetReloadFinish() > 0 then return false end

	if self:Clip1() < self.RequiredClip then
		self:EmitSound(self.DryFireSound)
		self:SetNextPrimaryFire(CurTime() + math.max(0.25, self.Primary.Delay))
		return false
	end

	return self:GetNextPrimaryFire() <= CurTime()
end

function SWEP:OnRestore()
	self:SetIronsights(false)
end

function SWEP:SendWeaponAnimation()
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed)
end

function SWEP:SendReloadAnimation()
	self:SendWeaponAnim(ACT_VM_RELOAD)
end

function SWEP:GetReloadSpeedMultiplier()
	local owner = self:GetOwner()
	local primstring = self:GetPrimaryAmmoTypeString()
	local reloadspecmulti = primstring and "ReloadSpeedMultiplier" .. string.upper(primstring) or nil

	local extramulti = 1
	if owner:HasTrinket("supasm") and (self.Tier or 1) <= 2 and not self.PrimaryRemantleModifier and self.QualityTier then
		extramulti = GAMEMODE.WeaponQualities[self.QualityTier][2]
	end

	return self:GetOwner():GetTotalAdditiveModifier("ReloadSpeedMultiplier", reloadspecmulti) * (owner:GetStatus("frost") and 0.7 or 1) * extramulti
end

function SWEP:ProcessReloadEndTime()
	local reloadspeed = self.ReloadSpeed * self:GetReloadSpeedMultiplier()

	self:SetReloadFinish(CurTime() + self:SequenceDuration() / reloadspeed)
	if not self.DontScaleReloadSpeed then
		self:GetOwner():GetViewModel():SetPlaybackRate(reloadspeed)
	end
end

function SWEP:GetFireDelay()
	local owner = self:GetOwner()
	return self.Primary.Delay / (owner:GetStatus("frost") and 0.7 or 1)
end

function SWEP:ShootBullets(dmg, numbul, cone)
	local owner = self:GetOwner()
	self:SendWeaponAnimation()
	owner:DoAttackEvent()
	if self.Recoil > 0 then
		local r = math.Rand(0.8, 1)
		owner:ViewPunch(Angle(r * -self.Recoil, 0, (1 - r) * (math.random(2) == 1 and -1 or 1) * self.Recoil))
	end

	if self.PointsMultiplier then
		POINTSMULTIPLIER = self.PointsMultiplier
	end

	owner:LagCompensation(true)
	owner:FireBulletsLua(owner:GetShootPos(), owner:GetAimVector(), cone, numbul, dmg, nil, self.Primary.KnockbackScale, self.TracerName, self.BulletCallback, self.Primary.HullSize, nil, self.Primary.MaxDistance, nil, self)
	owner:LagCompensation(false)

	if self.PointsMultiplier then
		POINTSMULTIPLIER = nil
	end
end

local ActIndex = {
	[ "pistol" ] 		= ACT_HL2MP_IDLE_PISTOL,
	[ "smg" ] 			= ACT_HL2MP_IDLE_SMG1,
	[ "grenade" ] 		= ACT_HL2MP_IDLE_GRENADE,
	[ "ar2" ] 			= ACT_HL2MP_IDLE_AR2,
	[ "shotgun" ] 		= ACT_HL2MP_IDLE_SHOTGUN,
	[ "rpg" ]	 		= ACT_HL2MP_IDLE_RPG,
	[ "physgun" ] 		= ACT_HL2MP_IDLE_PHYSGUN,
	[ "crossbow" ] 		= ACT_HL2MP_IDLE_CROSSBOW,
	[ "melee" ] 		= ACT_HL2MP_IDLE_MELEE,
	[ "slam" ] 			= ACT_HL2MP_IDLE_SLAM,
	[ "normal" ]		= ACT_HL2MP_IDLE,
	[ "fist" ]			= ACT_HL2MP_IDLE_FIST,
	[ "melee2" ]		= ACT_HL2MP_IDLE_MELEE2,
	[ "passive" ]		= ACT_HL2MP_IDLE_PASSIVE,
	[ "knife" ]			= ACT_HL2MP_IDLE_KNIFE,
	[ "duel" ]      	= ACT_HL2MP_IDLE_DUEL,
	[ "revolver" ]		= ACT_HL2MP_IDLE_REVOLVER,
	[ "camera" ]		= ACT_HL2MP_IDLE_CAMERA
}

function SWEP:SetWeaponHoldType( t )

	t = string.lower( t )
	local index = ActIndex[ t ]

	if ( index == nil ) then
		Msg( "SWEP:SetWeaponHoldType - ActIndex[ \""..t.."\" ] isn't set! (defaulting to normal) (from "..self:GetClass()..")\n" )
		t = "normal"
		index = ActIndex[ t ]
	end

	self.ActivityTranslate = {}
	self.ActivityTranslate [ ACT_MP_STAND_IDLE ] 				= index
	self.ActivityTranslate [ ACT_MP_WALK ] 						= index+1
	self.ActivityTranslate [ ACT_MP_RUN ] 						= index+2
	self.ActivityTranslate [ ACT_MP_CROUCH_IDLE ] 				= index+3
	self.ActivityTranslate [ ACT_MP_CROUCHWALK ] 				= index+4
	self.ActivityTranslate [ ACT_MP_ATTACK_STAND_PRIMARYFIRE ] 	= index+5
	self.ActivityTranslate [ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ] = index+5
	self.ActivityTranslate [ ACT_MP_RELOAD_STAND ]		 		= index+6
	self.ActivityTranslate [ ACT_MP_RELOAD_CROUCH ]		 		= index+6
	self.ActivityTranslate [ ACT_MP_JUMP ] 						= index+7
	self.ActivityTranslate [ ACT_RANGE_ATTACK1 ] 				= index+8
	self.ActivityTranslate [ ACT_MP_SWIM_IDLE ] 				= index+8
	self.ActivityTranslate [ ACT_MP_SWIM ] 						= index+9

	-- "normal" jump animation doesn't exist
	if t == "normal" then
		self.ActivityTranslate [ ACT_MP_JUMP ] = ACT_HL2MP_JUMP_SLAM
	end

	-- these two aren't defined in ACTs for whatever reason
	if t == "knife" or t == "melee2" then
		self.ActivityTranslate [ ACT_MP_CROUCH_IDLE ] = nil
	end
end

SWEP:SetWeaponHoldType("pistol")

function SWEP:TranslateActivity(act)
	if self:GetIronsights() and self.ActivityTranslateIronSights then
		return self.ActivityTranslateIronSights[act] or -1
	end

	return self.ActivityTranslate and self.ActivityTranslate[act] or -1
end
