AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = translate.Get("craft_dualboomstick")
	SWEP.Description = translate.Get("craft_dualboomstickdesk")
	SWEP.Slot = 3
	SWEP.SlotPos = 0

	SWEP.HUD3DBone = "ValveBiped.Gun"
	SWEP.HUD3DPos = Vector(1.65, 0, -8)
	SWEP.HUD3DScale = 0.025
	
	SWEP.ViewModelFlip = false
end

SWEP.Base = "weapon_zs_base"


SWEP.HoldType = "duel"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.UseHands = false
SWEP.ViewModel = "models/weapons/c_shotgun.mdl"
SWEP.WorldModel = "models/weapons/w_shotgun.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
SWEP.ViewModelBoneMods = {}

SWEP.VElements = {
	["element_name"] = { type = "Model", model = "models/weapons/w_shotgun.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(-19.225, 7.282, -0.394), angle = Angle(-32.424, 163.067, -112.931), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["element_name"] = { type = "Model", model = "models/weapons/w_shotgun.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(15.609, 6.46, 3.328), angle = Angle(-12.54, 161.391, 0), size = Vector(1.001, 1.001, 1.001), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}


SWEP.CSMuzzleFlashes = false

SWEP.ReloadDelay = 0.4 SWEP.Primary.Sound = Sound("weapons/shotgun/shotgun_dbl_fire.wav")
SWEP.Primary.Recoil = 12.5
SWEP.Primary.Damage = 36
SWEP.Primary.NumShots = 8 SWEP.Primary.Delay = 1.5

SWEP.Primary.ClipSize = 8
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "buckshot"
SWEP.Primary.DefaultClip = 28

SWEP.ConeMax = 0.23
SWEP.ConeMin = 0.2

SWEP.WalkSpeed = SPEED_SLOW

function SWEP:SetIronsights()
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

		self:ShootBullets(self.Primary.Damage, self.Primary.NumShots * clip/2, self:GetCone())

		self:TakePrimaryAmmo(clip/2)
		self.Owner:ViewPunch(clip * 0.5 * self.Primary.Recoil * Angle(math.Rand(-0.1, -0.1), math.Rand(-0.1, 0.1), 0))

		self.Owner:SetGroundEntity(NULL)
		self.Owner:SetVelocity(-80 * clip * self.Owner:GetAimVector())

		self.IdleAnimation = CurTime() + self:SequenceDuration()
	end
end

function SWEP:Think()
	if self.reloading and self.reloadtimer < CurTime() then
		self.reloadtimer = CurTime() + self.ReloadDelay
		self:SendWeaponAnim(ACT_VM_RELOAD)

		self.Owner:RemoveAmmo(1, self.Primary.Ammo, false)
		self:SetClip1(self:Clip1() + 1)
		self:EmitSound("Weapon_Shotgun.Reload")

		if self.Primary.ClipSize <= self:Clip1() or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 or not self.Owner:KeyDown(IN_RELOAD) then
			self.nextreloadfinish = CurTime() + self.ReloadDelay
			self.reloading = false
			self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		end
	end

	local nextreloadfinish = self.nextreloadfinish
	if nextreloadfinish ~= 0 and nextreloadfinish < CurTime() then
		self:SendWeaponAnim(ACT_SHOTGUN_PUMP)
		self:EmitSound("Weapon_Shotgun.Special1")
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
		self:EmitSound("Weapon_Shotgun.Empty")
		self:SetNextPrimaryFire(CurTime() + 1)
		return false
	end

	if self.reloading then
		if self:Clip1() < self.Primary.ClipSize then
			self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
		else
			self:SendWeaponAnim(ACT_SHOTGUN_PUMP)
			self:EmitSound("Weapon_Shotgun.Special1")
		end
		self.reloading = false
		self:SetNextPrimaryFire(CurTime() + 1.25)
		return false
	end

	return self:GetNextPrimaryFire() <= CurTime()
end


function SWEP:CanSecondaryAttack()
	if self.Owner:IsHolding() or self.Owner:GetBarricadeGhosting() then return false end

	if self:Clip1() <= 0 then
		self:EmitSound("Weapon_Shotgun.Empty")
		self:SetNextPrimaryFire(CurTime() + 1)
		return false
	end

	if self.reloading then
		if self:Clip1() < self.Primary.ClipSize then
			self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
		else
			self:SendWeaponAnim(ACT_SHOTGUN_PUMP)
			self:EmitSound("Weapon_Shotgun.Special1")
		end
		self.reloading = false
		self:SetNextPrimaryFire(CurTime() + 0.25)
		return false
	end

	return self:GetNextPrimaryFire() <= CurTime()
end

function SWEP:SecondaryAttack()
	if self:CanPrimaryAttack() then
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		self:EmitSound(self.Primary.Sound)

		local clip = self:Clip1()

		self:ShootBullets(self.Primary.Damage, self.Primary.NumShots * 2, self:GetCone())

		self:TakePrimaryAmmo(2)
		self.Owner:ViewPunch(2 * 0.5 * self.Primary.Recoil * Angle(math.Rand(-0.1, -0.1), math.Rand(-0.1, 0.1), 0))

		self.Owner:SetGroundEntity(NULL)
		self.Owner:SetVelocity(-25 * 2 * self.Owner:GetAimVector())

		self.IdleAnimation = CurTime() + self:SequenceDuration()
	end
end

SWEP.Secondary.Delay = 1