AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'Reaper' UMP"
	SWEP.Slot = 2
	SWEP.SlotPos = 0
	SWEP.Description = "정조준시 버스트 모드가 작동하여 연사 속도가 65% 증가한다."

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "v_weapon.ump45_Release"
	SWEP.HUD3DPos = Vector(-1.1, -3, 2)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.02
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/cstrike/c_smg_ump45.mdl"
SWEP.WorldModel = "models/weapons/w_smg_ump45.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("Weapon_UMP45.Single")
SWEP.Primary.Damage = 24
SWEP.Primary.DefaultDamage = 24
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.13
SWEP.Primary.DefaultDelay = 0.13

SWEP.Primary.ClipSize = 25
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.Primary.Recoil = 2.88
SWEP.Primary.DefaultRecoil = 2.88
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_AR2

SWEP.ConeMax = 0.272
SWEP.ConeMin = 0.1124

SWEP.WalkSpeed = SPEED_SLOW

SWEP.IronSightsPos = Vector(-5.3, -3, 4.4)
SWEP.IronSightsAng = Vector(-1, 0.2, 2.55)

function SWEP:SetIronsights(b)
	if self:GetIronsights() ~= b then
		if b then
			self.Primary.Delay = self.Primary.DefaultDelay * 0.35
			
			self.Primary.Recoil = self.Primary.DefaultRecoil * 2.9
			
			self.Primary.Damage = self.Primary.DefaultDamage * 1.4

			self:EmitSound("npc/scanner/scanner_scan4.wav", 40)
		else
			self.Primary.Delay = self.Primary.DefaultDelay
			
			self.Primary.Recoil = self.Primary.DefaultRecoil
			
			self.Primary.Damage = self.Primary.DefaultDamage

			self:EmitSound("npc/scanner/scanner_scan2.wav", 40)
		end
	end

	self.BaseClass.SetIronsights(self, b)
end