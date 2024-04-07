AddCSLuaFile()

SWEP.Base = "weapon_zs_baseshotgun"

SWEP.PrintName = "'Annabelle' Rifle"
SWEP.Description = "This rifle loads rounds individually, at the cost of being not perfectly accurate."

if CLIENT then
	SWEP.ViewModelFlip = false

	SWEP.IronSightsPos = Vector(-8.8, 10, 4.32)
	SWEP.IronSightsAng = Vector(1.4, 0.1, 5)

	SWEP.HUD3DBone = "ValveBiped.Gun"
	SWEP.HUD3DPos = Vector(1.75, 1, -5)
	SWEP.HUD3DAng = Angle(180, 0, 0)
	SWEP.HUD3DScale = 0.015
end

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/c_annabelle.mdl"
SWEP.WorldModel = "models/weapons/w_annabelle.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.Primary.Sound = Sound("Weapon_Shotgun.Single")
SWEP.Primary.Damage = 74
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.9

SWEP.ReloadDelay = 0.4

SWEP.Primary.ClipSize = 5
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "357"
SWEP.Primary.DefaultClip = 25

SWEP.ConeMax = 4
SWEP.ConeMin = 0.25

SWEP.ReloadSound = Sound("Weapon_Shotgun.Reload")
SWEP.PumpSound = Sound("Weapon_Shotgun.Special1")

SWEP.WalkSpeed = SPEED_SLOW

SWEP.Tier = 2

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.5, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.05, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.1, 1)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, "'Annabelle' Birdshot Rifle", "Fires a spread of less accurate shots that deal more total damage", function(wept)
	wept.Primary.Damage = wept.Primary.Damage / 5
	wept.Primary.NumShots = 6
	wept.ConeMin = wept.ConeMin * 8
	wept.ConeMax = wept.ConeMax * 2
end)

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound, 75, math.random(95, 103), 0.8)
	self:EmitSound("weapons/shotgun/shotgun_fire6.wav", 75, math.random(78, 81), 0.65, CHAN_WEAPON + 20)
end

function SWEP:SecondaryAttack()
	if self:GetNextSecondaryFire() <= CurTime() and not self:GetOwner():IsHolding() and self:GetReloadFinish() == 0 then
		self:SetIronsights(true)
	end
end

function SWEP:Think()
	if self:GetIronsights() and not self:GetOwner():KeyDown(IN_ATTACK2) then
		self:SetIronsights(false)
	end

	self.BaseClass.Think(self)
end
