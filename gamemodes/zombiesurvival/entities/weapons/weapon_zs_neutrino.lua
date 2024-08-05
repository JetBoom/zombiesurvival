AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'Neutrino' 펄스 LMG"
	SWEP.Description = "탄창이 없는 신식 무기로 공격을 거듭할수록 발사속도가 빨라진다."
	SWEP.Slot = 2
	SWEP.SlotPos = 0

	SWEP.HUD3DBone = "Base"
	SWEP.HUD3DPos = Vector(7.791, -2.597, -7.792)
	SWEP.HUD3DScale = 0.04
	SWEP.VElements = {
		["handle"] = { type = "Model", model = "models/props_lab/teleplatform.mdl", bone = "Base", rel = "", pos = Vector(2.562, 4.382, -7.264), angle = Angle(0, -106.975, -90), size = Vector(0.052, 0.018, 0.131), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["backcover+"] = { type = "Model", model = "models/props_combine/combine_booth_short01a.mdl", bone = "Base", rel = "", pos = Vector(0, 3.743, -4.172), angle = Angle(-90, 0, -90), size = Vector(0.064, 0.054, 0.112), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["top++"] = { type = "Model", model = "models/props_combine/combine_train02a.mdl", bone = "Base", rel = "", pos = Vector(-4, 3.4, 8.822), angle = Angle(0, 110, -90), size = Vector(0.064, 0.054, 0.054), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["ring"] = { type = "Model", model = "models/props_lab/teleportring.mdl", bone = "Base", rel = "", pos = Vector(0, 0, 0.83), angle = Angle(0, 0, 0), size = Vector(0.238, 0.238, 0.617), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["backcover"] = { type = "Model", model = "models/props_combine/breenconsole.mdl", bone = "Base", rel = "", pos = Vector(0, 8.26, -10.254), angle = Angle(180, 0, -90), size = Vector(0.259, 0.303, 0.18), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["top+"] = { type = "Model", model = "models/props_combine/combine_train02a.mdl", bone = "Base", rel = "", pos = Vector(4, 3.4, 8.822), angle = Angle(0, -110, -90), size = Vector(0.064, 0.054, 0.054), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["ring+"] = { type = "Model", model = "models/props_lab/teleportring.mdl", bone = "Base", rel = "", pos = Vector(0, 0, 9.887), angle = Angle(0, 0, 0), size = Vector(0.238, 0.238, 0.617), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["backcover++"] = { type = "Model", model = "models/props_combine/combine_core_ring01.mdl", bone = "Base", rel = "", pos = Vector(5.085, 5.119, -4.666), angle = Angle(10.803, 90, -90), size = Vector(0.09, 0.128, 0.064), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["nozzle"] = { type = "Model", model = "models/props_junk/terracotta01.mdl", bone = "Base", rel = "", pos = Vector(0, 0, 21.715), angle = Angle(0, 0, 0), size = Vector(0.583, 0.583, 0.583), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["top"] = { type = "Model", model = "models/props_combine/combine_train02a.mdl", bone = "Base", rel = "", pos = Vector(0, -1.769, 9.48), angle = Angle(0, 0, -90), size = Vector(0.064, 0.054, 0.054), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["top++"] = { type = "Model", model = "models/props_combine/combine_train02a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(18.836, 1.134, -3.421), angle = Angle(-60, -75, 12), size = Vector(0.034, 0.034, 0.034), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["top"] = { type = "Model", model = "models/props_combine/combine_train02a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(18.747, -2.422, -8.268), angle = Angle(180, -79.387, 0), size = Vector(0.034, 0.034, 0.034), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["nozzle"] = { type = "Model", model = "models/props_junk/terracotta01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(27.541, -3.258, -4.519), angle = Angle(-90, 3.944, 0), size = Vector(0.194, 0.194, 0.194), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["top+"] = { type = "Model", model = "models/props_combine/combine_train02a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(17.674, -4.555, -2.25), angle = Angle(60, -75, -1.015), size = Vector(0.034, 0.034, 0.034), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["nozzle+"] = { type = "Model", model = "models/props_junk/metal_paintcan001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(18.461, -2.402, -6.15), angle = Angle(-89.82, 10.119, 0), size = Vector(0.762, 0.762, 0.762), color = Color(255, 255, 255, 255), surpresslightning = false, material = "metal6", skin = 0, bodygroup = {} }
	}
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

SWEP.ViewModel = Model( "models/weapons/c_physcannon.mdl" )
SWEP.WorldModel = Model( "models/weapons/w_physics.mdl" )
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = true

SWEP.ReloadDelay = 0.15

SWEP.ViewModelBoneMods = {
	["Base"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

sound.Add( {
	name = "Loop_Neutrino_Charging",
	channel = CHAN_VOICE,
	volume = 1,
	level = 90,
	pitch = 110,
	sound = "weapons/gauss/chargeloop.wav"
} )

SWEP.ReloadSound = Sound("weapons/ar2/ar2_reload_push.wav")
SWEP.Primary.Sound = Sound("Weapon_pulselmg.Single")
SWEP.Primary.Recoil = 3
SWEP.Primary.Damage = 16
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.4

SWEP.Primary.ClipSize = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "pulse"
SWEP.Primary.DefaultClip = 100

SWEP.ConeMax = 2
SWEP.ConeMin = 0.9

SWEP.WalkSpeed = SPEED_SLOWEST
SWEP.TracerName = "AirboatGunHeavyTracer"
SWEP.PlayCharge = nil
function SWEP:SetIronsights()
end

local function BulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity
	

	local e = EffectData()
		e:SetOrigin(tr.HitPos)
		e:SetNormal(tr.HitNormal)
		e:SetRadius(3)
		e:SetMagnitude(1)
		e:SetScale(1)
	util.Effect("AR2Impact", e)
	GenericBulletCallback(attacker, tr, dmginfo)
end
SWEP.BulletCallback = BulletCallback

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
		self.Owner:RemoveAmmo( self.Primary.NumShots*((self:GetDTInt(4) >= 40) and 2 or (self:GetDTInt(4) >= 80) and 3 or 1), self.Weapon:GetPrimaryAmmoType() )
		self.IdleAnimation = CurTime() + self:SequenceDuration()
		local combo = self:GetDTInt(4)
		self:SetNextPrimaryFire(CurTime() + math.max(0.04, self.Primary.Delay * (1 - combo / 120)))
		self:SetDTInt(4, combo + 1)
	end
end

function SWEP:Think()
	local owner = self.Owner
	if owner:KeyDown(IN_ATTACK) and self:CanPrimaryAttack() then 
		if self:Ammo1()<=0 then return end
		
		if not self.PlayCharge then
			owner:EmitSound("Loop_Neutrino_Charging")
			self.PlayCharge = true
		end
		if CLIENT then
			self.VElements["ring"].angle.y = math.Approach(self.VElements["ring"].angle.y, self.VElements["ring"].angle.y+2, FrameTime()*80)
			self.VElements["ring+"].angle.y = math.Approach(self.VElements["ring+"].angle.y, self.VElements["ring+"].angle.y+3, FrameTime()*80)
		end
	elseif CLIENT then
		self.VElements["ring"].angle.y = math.Approach(self.VElements["ring"].angle.y, math.ceil(self.VElements["ring"].angle.y/360)*360, FrameTime()*100)
        self.VElements["ring+"].angle.y = math.Approach(self.VElements["ring+"].angle.y, math.ceil(self.VElements["ring+"].angle.y/360)*360, FrameTime()*100)
	elseif not owner:KeyDown(IN_ATTACK) then
		self:SetDTInt(4, 0)
		if self.PlayCharge then
			owner:StopSound("Loop_Neutrino_Charging")
			self.PlayCharge = nil
		end
	end
	if owner:KeyReleased(IN_ATTACK) then
		owner:EmitSound("weapons/slam/mine_mode.wav")
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