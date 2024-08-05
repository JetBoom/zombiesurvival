AddCSLuaFile()
SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "crossbow"

if CLIENT then
	SWEP.PrintName = "'헤비 레인' M249"
	SWEP.Description = "강력한 분대 지원 화기로, 앉아서 쏠 시 발사속도가 늘어난다."
	SWEP.Slot = 2
	SWEP.SlotPos = 0

	SWEP.HUD3DBone = "v_weapon.m249"
	SWEP.HUD3DPos = Vector(1.5, 0.5, 11)
	SWEP.HUD3DScale = 0.025
end

SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 62
SWEP.ViewModel			= "models/weapons/cstrike/c_mach_m249para.mdl"
SWEP.WorldModel			= "models/weapons/w_mach_m249para.mdl"

SWEP.UseHands = true

SWEP.ReloadSound = Sound("M60.Boxout")
SWEP.Primary.Sound = Sound("Weapon_M249.Single")
SWEP.Primary.SoundLevel = 50
SWEP.Primary.Damage = 8
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.04
SWEP.Primary.Recoil = 10
SWEP.Primary.KnockbackScale = 10

SWEP.Primary.ClipSize = 200
SWEP.Primary.ClipMultiplier = 3 / GAMEMODE.SurvivalClips
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "gravity"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 0.35
SWEP.ConeMin = 0.1

SWEP.WalkSpeed = 100

SWEP.IronSightsPos = Vector(0, 10, 0)
SWEP.IronSightsAng = Vector(1, 2, 0)

function SWEP:Think()
	if self.Owner:Crouching() then
		self.Primary.Delay = 0.04
	else
		self.Primary.Delay = 0.06
	end
	
	self.BaseClass.Think(self)
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	if tr.Hit then
		local ent = tr.Entity
		if ent:IsPlayer() and ent:Team() ~= attacker:Team() then
			ent:AddLegDamage(10)
		end
	end
	GenericBulletCallback(attacker, tr, dmginfo)
end