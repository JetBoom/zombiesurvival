AddCSLuaFile()

SWEP.Slot = 3
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "shotgun"

SWEP.ViewModel = "models/weapons/c_shotgun.mdl"
SWEP.WorldModel = "models/weapons/w_shotgun.mdl"
SWEP.UseHands = true

SWEP.ReloadDelay = 0.45

SWEP.Primary.Sound = Sound("Weapon_M3.Single")
SWEP.Primary.Damage = 8
SWEP.Primary.NumShots = 6
SWEP.Primary.Delay = 1

SWEP.Primary.ClipSize = 6
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "buckshot"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 7
SWEP.ConeMin = 5.25

SWEP.WalkSpeed = SPEED_SLOW

SWEP.ReloadActivity = ACT_VM_RELOAD
SWEP.PumpActivity = ACT_SHOTGUN_RELOAD_FINISH
SWEP.ReloadStartActivity = ACT_SHOTGUN_RELOAD_START
SWEP.ReloadStartGesture = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
	if not self:IsReloading() and self:CanReload() then
		self:StartReloading()
	end
end

function SWEP:Think()
	if self:ShouldDoReload() then
		self:DoReload()
	end

	self:NextThink(CurTime())
	return true
end

function SWEP:StartReloading()
	local delay = self:GetReloadDelay()
	self:SetDTFloat(3, CurTime() + delay)
	self:SetDTBool(2, true) -- force one shell load
	self:SetNextPrimaryFire(CurTime() + math.max(self.Primary.Delay, delay))

	self:GetOwner():DoReloadEvent()

	if self.ReloadStartActivity then
		self:SendWeaponAnim(self.ReloadStartActivity)
		self:ProcessReloadAnim()
	end
end

function SWEP:StopReloading()
	self:SetDTFloat(3, 0)
	self:SetDTBool(2, false)
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay * 0.75)

	-- do the pump stuff if we need to
	if self:Clip1() > 0 then
		if self.PumpSound then
			self:EmitSound(self.PumpSound)
		end
		if self.PumpActivity then
			self:SendWeaponAnim(self.PumpActivity)
			self:ProcessReloadAnim()
		end
	end
end

function SWEP:DoReload()
	if not self:CanReload() or self:GetOwner():KeyDown(IN_ATTACK) or not self:GetDTBool(2) and not self:GetOwner():KeyDown(IN_RELOAD) then
		self:StopReloading()
		return
	end

	local delay = self:GetReloadDelay()
	if self.ReloadActivity then
		self:SendWeaponAnim(self.ReloadActivity)
		self:ProcessReloadAnim()
	end
	if self.ReloadSound then
		self:EmitSound(self.ReloadSound)
	end

	self:GetOwner():RemoveAmmo(1, self.Primary.Ammo, false)
	self:SetClip1(self:Clip1() + 1)

	self:SetDTBool(2, false)
	-- We always wanna call the reload function one more time. Forces a pump to take place.
	self:SetDTFloat(3, CurTime() + delay)

	self:SetNextPrimaryFire(CurTime() + math.max(self.Primary.Delay, delay))
end

function SWEP:ProcessReloadAnim()
	local reloadspeed = self.ReloadSpeed * self:GetReloadSpeedMultiplier()
	if not self.DontScaleReloadSpeed then
		self:GetOwner():GetViewModel():SetPlaybackRate(reloadspeed)
	end
end

function SWEP:GetReloadDelay()
	local reloadspeed = self.ReloadSpeed * self:GetReloadSpeedMultiplier()
	return self.ReloadDelay / reloadspeed
end

function SWEP:ShouldDoReload()
	return self:GetDTFloat(3) > 0 and CurTime() >= self:GetDTFloat(3)
end

function SWEP:IsReloading()
	return self:GetDTFloat(3) > 0
end

function SWEP:CanReload()
	return self:Clip1() < self.Primary.ClipSize and 0 < self:GetOwner():GetAmmoCount(self.Primary.Ammo)
end

function SWEP:CanPrimaryAttack()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() then return false end

	if self:Clip1() < self.RequiredClip then
		self:EmitSound("Weapon_Shotgun.Empty")
		self:SetNextPrimaryFire(CurTime() + 0.25)

		return false
	end

	if self:IsReloading() then
		self:StopReloading()
		return false
	end

	return self:GetNextPrimaryFire() <= CurTime()
end
