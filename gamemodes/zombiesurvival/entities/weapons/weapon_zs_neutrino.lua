AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'뉴트리노' 펄스 LMG"
	SWEP.Description = "탄창이 없는 신식 무기로 공격을 거듭할수록 발사속도가 빨라진다."
	SWEP.Slot = 2
	SWEP.SlotPos = 0

	SWEP.HUD3DBone = "Base"
	SWEP.HUD3DPos = Vector(7.791, -2.597, -7.792)
	SWEP.HUD3DScale = 0.04
	
	SWEP.ViewModelFlip = false
end

sound.Add(
{
	name = "Weapon_pulselmg.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	soundlevel = 100,
	sound = "weapons/ar2/fire1.wav"
})

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/v_physcannon.mdl"
SWEP.WorldModel = "models/weapons/w_physics.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.ReloadDelay = 0.15

SWEP.ViewModelBoneMods = {
	["Base"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.ReloadSound = Sound("weapons/ar2/ar2_relaod_push.wav")
SWEP.Primary.Sound = Sound("Weapon_pulselmg.Single")
SWEP.Primary.Recoil = 0
SWEP.Primary.Damage = 8
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.4

SWEP.Primary.ClipSize = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "pulse"
SWEP.Primary.DefaultClip = 100

SWEP.ConeMax = 0.05
SWEP.ConeMin = 0.01

SWEP.WalkSpeed = SPEED_SLOWEST
SWEP.TracerName = "AirboatGunHeavyTracer"

function SWEP:SetIronsights()
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	GenericBulletCallback(attacker, tr, dmginfo)
	local e = EffectData()
		e:SetOrigin(tr.HitPos)
		e:SetNormal(tr.HitNormal)
		e:SetRadius(3)
		e:SetMagnitude(1)
		e:SetScale(1)
	util.Effect("AR2Impact", e)
end

function SWEP:Reload()
end

function SWEP:PrimaryAttack()
	if self:CanPrimaryAttack() then
		if ( self.Weapon:Ammo1() <= 0 ) then 
			self:EmitSound("buttons/combine_button_locked.wav")
			self:SetNextPrimaryFire(CurTime() + 0.5)
			self:SetDTInt(4, 0)
		return end
		self:EmitSound(self.Primary.Sound)
		self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())
		self.Owner:RemoveAmmo( self.Primary.NumShots, self.Weapon:GetPrimaryAmmoType() )
		self.IdleAnimation = CurTime() + self:SequenceDuration()
		local combo = self:GetDTInt(4)
		self:SetNextPrimaryFire(CurTime() + math.max(0.035, self.Primary.Delay * (1 - combo / 75)))
		self:SetDTInt(4, combo + 1)
	end
end

function SWEP:Think()
	if not self.Owner:KeyDown(IN_ATTACK)then
		self:SetDTInt(4, 0)
	end
end

function SWEP:CanPrimaryAttack()
	return true
end
if CLIENT then
local colBG = Color(16, 16, 16, 90)
local colRed = Color(220, 0, 0, 230)
local colYellow = Color(220, 220, 0, 230)
local colWhite = Color(220, 220, 220, 230)
local colAmmo = Color(255, 255, 255, 230)
function SWEP:Draw3DHUD(vm, pos, ang)
	local wid, hei = 180, 100
	local x, y = wid * -0.6, hei * -0.6
	local clip = self:Clip1()
	local spare = self.Owner:GetAmmoCount(self:GetPrimaryAmmoType())
	local maxclip = self.Primary.ClipSize

	if self.RequiredClip ~= 1 then
		clip = math.floor(clip / self.RequiredClip)
		spare = math.floor(spare / self.RequiredClip)
		maxclip = math.ceil(maxclip / self.RequiredClip)
	end

	cam.Start3D2D(pos, ang, self.HUD3DScale / 2)
		draw.RoundedBoxEx(32, x, y, wid, hei, colBG, true, false, true, false)
		draw.SimpleTextBlurry(spare, spare >= 1000 and "ZS3D2DFontSmall" or "ZS3D2DFont", x + wid * 0.5, y + hei * 0.5, spare == 0 and colRed or spare <= 100 and colYellow or colWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()
end

function SWEP:Draw2DHUD()
	local screenscale = BetterScreenScale()

	local wid, hei = 180 * screenscale, 64 * screenscale
	local x, y = ScrW() - wid - screenscale * 128, ScrH() - hei - screenscale * 72
	local spare = self.Owner:GetAmmoCount(self:GetPrimaryAmmoType())

	draw.RoundedBox(16, x, y, wid, hei, colBG)
	draw.SimpleTextBlurry(spare, spare >= 1000 and "ZSHUDFontSmall" or "ZSHUDFont", x + wid * 0.5, y + hei * 0.5, spare == 0 and colRed or spare <= 100 and colYellow or colWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end
end