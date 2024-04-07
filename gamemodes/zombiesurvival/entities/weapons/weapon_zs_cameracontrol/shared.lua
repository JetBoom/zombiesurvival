AddCSLuaFile()

SWEP.Base = "weapon_zs_base"

SWEP.PrintName = "Camera Viewer"
SWEP.Slot = 4
SWEP.SlotPos = 0

SWEP.ViewModel = "models/weapons/c_slam.mdl"
SWEP.WorldModel = "models/weapons/w_slam.mdl"
SWEP.UseHands = true

SWEP.Primary.Delay = 0
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.Delay = 20
SWEP.Secondary.Heal = 10

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.WalkSpeed = SPEED_FAST

SWEP.NoMagazine = true
SWEP.Undroppable = true
SWEP.NoDismantle = true
SWEP.AllowQualityWeapons = false
SWEP.NoPickupNotification = true

SWEP.HoldType = "camera"

SWEP.NoDeploySpeedChange = true
SWEP.NoTransfer = true
SWEP.AutoSwitchFrom	= false

SWEP.IdleActivity = ACT_SLAM_THROW_DETONATE

AccessorFuncDT(SWEP, "Camera", "Entity", 0)

function SWEP:PrimaryAttack(reverse)
	if IsFirstTimePredicted() then
		self:SendWeaponAnim(ACT_SLAM_TRIPMINE_ATTACH)
		self.IdleAnimation = CurTime() + 0.33

		if SERVER then
			self:CycleCamera(reverse)
		end

		if CLIENT then
			MySelf:EmitSound("buttons/button17.wav", 0)
		end
	end
end

function SWEP:SecondaryAttack(reverse)
	self:PrimaryAttack(true)
end

function SWEP:Reload()
	return false
end

function SWEP:Think()
	if self.IdleAnimation and self.IdleAnimation <= CurTime() then
		self.IdleAnimation = nil
		self:SendWeaponAnim(self.IdleActivity)
	end

	if SERVER then
		if not self:GetCamera():IsValid() then
			self:CycleCamera()
		end

		for _, ent in pairs(ents.FindByClass("prop_camera")) do
			if ent:GetObjectOwner() == self:GetOwner() then
				return
			end
		end

		self:GetOwner():StripWeapon(self:GetClass())
	end
end

function SWEP:Deploy()
	self.BaseClass.Deploy(self)

	gamemode.Call("WeaponDeployed", self:GetOwner(), self)

	self.IdleAnimation = math.huge
	self:SendWeaponAnim(self.IdleActivity)

	if SERVER then
		hook.Add("SetupPlayerVisibility", self, self.SetupPlayerVisibility)
	end

	if CLIENT then
		hook.Add("RenderScene", self, self.RenderScene)
	end

	return true
end

function SWEP:Holster()
	self.BaseClass.Holster(self)

	if SERVER then
		hook.Remove("SetupPlayerVisibility", self)
	end

	if CLIENT then
		hook.Remove("RenderScene", self)
	end

	return true
end
