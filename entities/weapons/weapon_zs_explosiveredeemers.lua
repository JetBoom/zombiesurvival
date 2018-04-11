AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = translate.Get("wn_explosiveredeemers")

SWEP.VElements = {
	["element_name+"] = { type = "Model", model = "models/props_c17/oildrum001_explosive.mdl", bone = "v_weapon.elite_right", rel = "", pos = Vector(0.279, -2.597, 0.518), angle = Angle(0, 0, 0), size = Vector(0.039, 0.039, 0.039), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["element_name"] = { type = "Model", model = "models/props_c17/oildrum001_explosive.mdl", bone = "v_weapon.elite_left", rel = "", pos = Vector(-0.203, -2.757, 0.598), angle = Angle(0, 0, 0), size = Vector(0.037, 0.037, 0.037), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

	SWEP.Slot = 1
	SWEP.SlotPos = 0

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 50

	SWEP.HUD3DBone = "v_weapon.slide_right"
	SWEP.HUD3DPos = Vector(1, 0.1, -1)
	SWEP.HUD3DScale = 0.015
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "duel"

SWEP.ViewModel = "models/weapons/cstrike/c_pist_elite.mdl"
SWEP.WorldModel = "models/weapons/w_pist_elite.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("vehicles/v8/vehicle_impact_heavy"..math.random(4)..".wav", 80, math.Rand(5, 105))
SWEP.Primary.Damage = 50
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.30
SWEP.Secondary.Damage = 100
SWEP.Secondary.Numshots = 1
SWEP.Secondary.Delay = 0.15

SWEP.Primary.ClipSize = 32
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "pistol"
SWEP.Primary.DefaultClip = 100

SWEP.ConeMax = 0.055
SWEP.ConeMin = 0.05

function SWEP:SecondaryAttack()
end

function SWEP:SendWeaponAnimation()
	self:SendWeaponAnim(self:Clip1() % 2 == 0 and ACT_VM_PRIMARYATTACK or ACT_VM_SECONDARYATTACK)
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	if not attacker:IsValid() or not attacker:IsPlayer() then return end

	local e = EffectData()
		e:SetOrigin(tr.HitPos)
		e:SetNormal(tr.HitNormal)
		e:SetRadius(50)
		e:SetMagnitude(20)
		e:SetScale(10)
	util.Effect("HelicopterMegaBomb", e)

	util.BlastDamage2(self, attacker, tr.HitPos, 200, 70)

	GenericBulletCallback(attacker, tr, dmginfo)
end
