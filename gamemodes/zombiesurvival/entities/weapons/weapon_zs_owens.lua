AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'Owens' 권총"
	SWEP.Slot = 1
	SWEP.SlotPos = 0
	
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "ValveBiped.square"
	SWEP.HUD3DPos = Vector(1.1, 0.25, -2)
	SWEP.HUD3DScale = 0.015
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "pistol"

SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.ReloadSound = Sound("Weapon_Pistol.Reload")
SWEP.Primary.Sound = Sound("Weapon_Pistol.NPC_Single")
SWEP.Primary.Damage = 12
SWEP.Primary.NumShots = 2
SWEP.Primary.Delay = 0.2
SWEP.Primary.Recoil = 2.65

SWEP.Primary.ClipSize = 12
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 1.3424
SWEP.ConeMin = 0.985

SWEP.IronSightsPos = Vector(-5.95, 3, 2.75)
SWEP.IronSightsAng = Vector(-0.15, -1, 2)

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
