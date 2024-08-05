AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'Stalker' M4"
	SWEP.Description = "정조준 시 40% 더 강력한 특수탄을 향상된 정확도로 발사한다. 단, 발사 속도는 현저히 줄어든다."
	SWEP.Slot = 2
	SWEP.SlotPos = 0

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "v_weapon.m4_Parent"
	SWEP.HUD3DPos = Vector(-0.5, -5, -1.2)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.015
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "smg"

SWEP.ViewModel = "models/weapons/cstrike/c_rif_m4a1.mdl"
SWEP.WorldModel = "models/weapons/w_rif_m4a1.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("Weapon_m4a1.Single")
SWEP.Primary.Damage = 21
SWEP.Primary.DefaultDamage = 21
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.08
SWEP.Primary.DefaultDelay = 0.08
SWEP.Primary.Recoil = 4.75
SWEP.Primary.DefaultRecoil = 4.75
SWEP.Primary.ClipSize = 30
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SMG1

SWEP.ConeMax = 0.31
SWEP.DefaultConeMax = 0.31
SWEP.ConeMin = 0.242
SWEP.DefaultConeMin= 0.242
SWEP.WalkSpeed = SPEED_SLOW

SWEP.IronSightsPos = Vector(-3, 0, 2)

-- function SWEP:GetAuraRange()
	-- return 512
-- end
function SWEP:SetIronsights(b)
	if self:GetIronsights() ~= b then
		if b then
			self.Primary.Delay = self.Primary.DefaultDelay * 2
			
			self.Primary.Automatic = false
			
			self.Primary.Damage = self.Primary.DefaultDamage * 1.4
			self.ConeMax = 0.05
			self.ConeMin = 0.01
			self:EmitSound("npc/scanner/scanner_scan4.wav", 40)
		else
			self.Primary.Delay = self.Primary.DefaultDelay
			
			self.Primary.Automatic = true
			self.ConeMax = self.DefaultConeMax
			self.ConeMin = self.DefaultConeMin 
			self.Primary.Damage = self.Primary.DefaultDamage

			self:EmitSound("npc/scanner/scanner_scan2.wav", 40)
		end
	end

	self.BaseClass.SetIronsights(self, b)
end