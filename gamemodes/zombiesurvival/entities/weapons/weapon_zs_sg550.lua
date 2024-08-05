AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'Helvetica' DMR"
	SWEP.Description = "피격 지점이 사용자에게서 멀어질수록 추가적인 피해를 입힌다."
	SWEP.Slot = 2
	SWEP.SlotPos = 0

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "v_weapon.sg550_Parent"
	SWEP.HUD3DPos = Vector(-1.558, -5, -2.1)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.04
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/cstrike/c_snip_sg550.mdl"
SWEP.WorldModel = "models/weapons/w_snip_sg550.mdl"
SWEP.UseHands = true

SWEP.ReloadSound = Sound("Weapon_AWP.ClipOut")
SWEP.Primary.Sound = Sound("Weapon_SG550.Single")
SWEP.Primary.Damage = 30
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.25
SWEP.Primary.Recoil = 10

SWEP.Primary.ClipSize = 20
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
SWEP.Primary.DefaultClip = 20

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN

SWEP.ConeMax = 0.05
SWEP.ConeMin = 0.02

SWEP.IronSightsPos = Vector(5.559, -8.633, 0)
SWEP.IronSightsAng = Vector(0, 0, 0)


SWEP.WalkSpeed = SPEED_SLOW

SWEP.TracerName = "Tracer"

function SWEP:IsScoped()
	return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.25 <= CurTime()
end
function SWEP:Think()
	if self.Owner:Crouching() then
		self.Primary.Recoil = 0.8
	else
		self.Primary.Recoil = 10
	end
	
	self.BaseClass.Think(self)
end
function BulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity
	if ent:IsPlayer() and ent:Team() == TEAM_UNDEAD and tr.HitPos:Distance(attacker:GetPos()) > 300 then
		dmginfo:AddDamage(math.min(math.floor(tr.HitPos:Distance(attacker:GetPos())/50),100))
	end
	GenericBulletCallback(attacker, tr, dmginfo)
end
SWEP.BulletCallback = BulletCallback
if CLIENT then
	SWEP.IronsightsMultiplier = 0.1

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
