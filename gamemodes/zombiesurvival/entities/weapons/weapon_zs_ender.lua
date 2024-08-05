AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'Ender' 자동 샷건"
	SWEP.Slot = 3
	SWEP.SlotPos = 0

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "v_weapon.galil"
	SWEP.HUD3DPos = Vector(1, 0, 6)
	SWEP.HUD3DScale = 0.015
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "shotgun"

SWEP.ViewModel = "models/weapons/cstrike/c_rif_galil.mdl"
SWEP.WorldModel = "models/weapons/w_rif_galil.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("Weapon_Galil.Single")
SWEP.Primary.Damage = 21
SWEP.Primary.NumShots = 4
SWEP.Primary.Delay = 0.4
SWEP.Primary.Recoil = 50

SWEP.Primary.ClipSize = 8
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "buckshot"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 1.958
SWEP.ConeMin = 1.121

SWEP.WalkSpeed = SPEED_SLOWER

function SWEP:SecondaryAttack()
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
