AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'제우스' DMR"
	SWEP.Description = "강력한 탄환들을 빠른 속도로 발사하는 지정사수 소총이다."
	SWEP.Slot = 3
	SWEP.SlotPos = 0

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "v_weapon.g3sg1_Parent"
	SWEP.HUD3DPos = Vector(-2, -5, -6)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.03
end

sound.Add(
{
	name = "Weapon_Zeus.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	soundlevel = 100,
	sound = "weapons/g3sg1/g3sg1-1.wav"
})

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = Model( "models/weapons/cstrike/c_snip_g3sg1.mdl" )
SWEP.WorldModel = Model( "models/weapons/w_snip_g3sg1.mdl" )
SWEP.UseHands = true

SWEP.ReloadSound = Sound("Weapon_G3SG1.ClipOut")
SWEP.Primary.Sound = Sound("Weapon_Zeus.Single")
SWEP.Primary.Damage = 80
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.38
SWEP.ReloadDelay = SWEP.Primary.Delay
SWEP.Primary.Recoil = 10

SWEP.Primary.ClipSize = 10
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "357"
SWEP.Primary.DefaultClip = 30
SWEP.Primary.KnockbackScale = 0.1

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN

SWEP.ConeMax = 0.452
SWEP.ConeMin = 0.0001
SWEP.IronSightsPos = Vector(5.015, -4, 2.52)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.WalkSpeed = SPEED_SLOWER

SWEP.TracerName = "Tracer"

function SWEP:IsScoped()
	return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.25 <= CurTime()
end


function SWEP:SendWeaponAnimation()
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
end

if CLIENT then
	SWEP.IronsightsMultiplier = 0.25

	function SWEP:GetViewModelPosition(pos, ang)
		if self:IsScoped() then
			return pos + ang:Up() * 256, ang
		end

		return self.BaseClass.GetViewModelPosition(self, pos, ang)
	end

	local matScope = Material("zombiesurvival/scope")
	function SWEP:DrawHUDBackground()
		if self:IsScoped() then
			local scrw, scrh = ScrW(), ScrH()
			local size = math.min(scrw, scrh)
			surface.SetMaterial(matScope)
			surface.SetDrawColor(255, 255, 255, 255)
			surface.DrawTexturedRect((scrw - size) * 0.5, (scrh - size) * 0.5, size, size)
			surface.SetDrawColor(0, 0, 0, 255)
			if scrw > size then
				local extra = (scrw - size) * 0.5
				surface.DrawRect(0, 0, extra, scrh)
				surface.DrawRect(scrw - extra, 0, extra, scrh)
			end
			if scrh > size then
				local extra = (scrh - size) * 0.5
				surface.DrawRect(0, 0, scrw, extra)
				surface.DrawRect(0, scrh - extra, scrw, extra)
			end
		end
	end
end
