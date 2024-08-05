AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'Bullet Storm' SMG"
	SWEP.Description = "보조 공격 버튼을 눌러 Storm firing 모드로 사격한다.\n해당 모드를 사용하는 동안 격발 딜레이가 60% 증가하지만 한 번에 두 개의 탄환이 발사된다."
	SWEP.Slot = 2
	SWEP.SlotPos = 0

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 50

	SWEP.HUD3DBone = "v_weapon.p90_Release"
	SWEP.HUD3DPos = Vector(-1.35, -0.5, -6.5)
	SWEP.HUD3DAng = Angle(0, 0, 0)
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "smg"

SWEP.ViewModel = "models/weapons/cstrike/c_smg_p90.mdl"
SWEP.WorldModel = "models/weapons/w_smg_p90.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("Weapon_p90.Single")
SWEP.Primary.Damage = 12
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.05
SWEP.Primary.Recoil = 4

SWEP.Primary.ClipSize = 50
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 0.25
SWEP.ConeMin = 0.1

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SMG1

SWEP.WalkSpeed = SPEED_SLOW

SWEP.IronSightsPos = Vector(-2, 6, 3)
SWEP.IronSightsAng = Vector(0, 2, 0)

SWEP.Primary.DefaultNumShots = SWEP.Primary.NumShots
SWEP.Primary.DefaultDelay = SWEP.Primary.Delay
SWEP.Primary.IronsightsNumShots = SWEP.Primary.NumShots * 3
SWEP.Primary.IronsightsDelay = SWEP.Primary.Delay * 1.8

function SWEP:SetIronsights(b)
	if self:GetIronsights() ~= b then
		if b then
			self.Primary.NumShots = self.Primary.IronsightsNumShots
			self.Primary.Delay = self.Primary.IronsightsDelay

			self:EmitSound("npc/scanner/scanner_scan4.wav", 40)
		else
			self.Primary.NumShots = self.Primary.DefaultNumShots
			self.Primary.Delay = self.Primary.DefaultDelay

			self:EmitSound("npc/scanner/scanner_scan2.wav", 40)
		end
	end

	self.BaseClass.SetIronsights(self, b)
end

function SWEP:CanPrimaryAttack()
	if self:GetIronsights() and self:Clip1() == 1 then
		self:SetIronsights(false)
	end

	return self.BaseClass.CanPrimaryAttack(self)
end

function SWEP:TakeAmmo()
	if self:GetIronsights() then
		if self:Clip1() < 3 then
			self:TakePrimaryAmmo(self:Clip1())
		else
			self:TakePrimaryAmmo(4)
		end
	else
		self.BaseClass.TakeAmmo(self)
	end
end

util.PrecacheSound("npc/scanner/scanner_scan4.wav")
util.PrecacheSound("npc/scanner/scanner_scan2.wav")
