AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'Hunter' Rifle"
	SWEP.Description = "Fires special large caliber rounds. The reloading time is slow but it packs a powerful punch."
	SWEP.Slot = 3
	SWEP.SlotPos = 0

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "v_weapon.awm_parent"
	SWEP.HUD3DPos = Vector(-1.25, -3.5, -16)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.02
end

sound.Add(
{
	name = "Weapon_Hunter.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	soundlevel = 100,
	pitchstart = 134,
	pitchend = 10,
	sound = "weapons/awp/awp1.wav"
})

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/cstrike/c_snip_awp.mdl"
SWEP.WorldModel = "models/weapons/w_snip_awp.mdl"
SWEP.UseHands = true

SWEP.ReloadSound = Sound("Weapon_AWP.ClipOut")
SWEP.Primary.Sound = Sound("Weapon_Hunter.Single")
SWEP.Primary.Damage = 115
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 1.5
SWEP.ReloadDelay = SWEP.Primary.Delay

SWEP.Primary.ClipSize = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "357"
SWEP.Primary.DefaultClip = 15

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN

SWEP.ConeMax = 0.115
SWEP.ConeMin = 0

SWEP.IronSightsPos = Vector(-7.5, -12.5, 2.4)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.HasScope = true

SWEP.UnscopedPos = SWEP.IronSightsPos
SWEP.ScopedPos = Vector(-7.5, -10, -5)
SWEP.UnscopedFOV = SWEP.ViewModelFOV
SWEP.ScopedFOV = 100

SWEP.WalkSpeed = SPEED_SLOWER

SWEP.TracerName = "AR2Tracer"

function SWEP:IsScoped()
	return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.25 <= CurTime()
end

--[[function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound, 85, 80)
end]]

function SWEP:SendWeaponAnimation()
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local effectdata = EffectData()
		effectdata:SetOrigin(tr.HitPos)
		effectdata:SetNormal(tr.HitNormal)
	util.Effect("hit_hunter", effectdata)

	GenericBulletCallback(attacker, tr, dmginfo)
end

if CLIENT then
	SWEP.IronsightsMultiplier = 0.25

	function SWEP:GetViewModelPosition(pos, ang)
		if self:IsScoped() then
			return pos + ang:Up() * 256, ang
		end

		return self.BaseClass.GetViewModelPosition(self, pos, ang)
	end
end
