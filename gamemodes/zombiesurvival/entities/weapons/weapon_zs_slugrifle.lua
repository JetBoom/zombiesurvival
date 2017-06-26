AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'Tiny' Slug Rifle"
	SWEP.Description = "This powerful rifle instantly kills any zombie with a head shot."
	SWEP.Slot = 3
	SWEP.SlotPos = 0

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 50

	SWEP.HUD3DBone = "v_weapon.xm1014_Bolt"
	SWEP.HUD3DPos = Vector(-1, 0, 0)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.02

	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/props_phx/construct/metal_plate_curve360x2.mdl", bone = "v_weapon.xm1014_Parent", rel = "", pos = Vector(0, -6, -9), angle = Angle(0, 0, 0), size = Vector(0.014, 0.014, 0.094), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base2"] = { type = "Model", model = "models/props/de_nuke/IndustrialLight01.mdl", bone = "v_weapon.xm1014_Parent", rel = "base", pos = Vector(0, 0, 7.6), angle = Angle(0, 0, 180), size = Vector(0.045, 0.045, 0.045), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_models/snip_awp/v_awp_scope", skin = 0, bodygroup = {} }
		--Using a light prop from CS:S as the scope because it's the right shape and the AWP scope texture fits on it perfectly, a less detailed or custom model would be a better fix.
	}

	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/props_phx/construct/metal_plate_curve360x2.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(13, 1, -7), angle = Angle(80, 0, 0), size = Vector(0.014, 0.014, 0.094), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base2"] = { type = "Model", model = "models/props_phx/construct/metal_angle360.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0, 0, 8.7), angle = Angle(0, 0, 0), size = Vector(0.014, 0.014, 0.014), color = Color(0, 0, 0, 255), surpresslightning = false, material = "phoenix_storms/mrref2", skin = 0, bodygroup = {} },
		["base3"] = { type = "Model", model = "models/props_phx/construct/metal_angle360.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0, 0, 0.5), angle = Angle(0, 0, 0), size = Vector(0.014, 0.014, 0.014), color = Color(0, 0, 0, 255), surpresslightning = false, material = "phoenix_storms/mrref2", skin = 0, bodygroup = {} }
		--Base 2 and 3 are two black circles to cover each end of the scope. Material used is just a solid color.
	}
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/cstrike/c_shot_xm1014.mdl"
SWEP.WorldModel = "models/weapons/w_shot_xm1014.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("Weapon_AWP.Single")
SWEP.Primary.Damage = 135
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 1.5
SWEP.ReloadDelay = SWEP.Primary.Delay

SWEP.Primary.ClipSize = 2
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "357"
SWEP.Primary.DefaultClip = 10

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN

SWEP.ConeMax = 0.12
SWEP.ConeMin = 0.005

SWEP.IronSightsPos = Vector() --Vector(-7.3, 9, 2.3)
SWEP.IronSightsAng = Vector(0, -1, 0)

SWEP.WalkSpeed = SPEED_SLOWER

function SWEP:IsScoped()
	return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.25 <= CurTime()
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

SWEP.NextReload = 0
function SWEP:Reload()
	if CurTime() < self.NextReload then return end

	self.NextReload = CurTime() + self.ReloadDelay

	local owner = self.Owner

	if self:Clip1() < self.Primary.ClipSize and 0 < owner:GetAmmoCount(self.Primary.Ammo) then
		self:DefaultReload(ACT_VM_RELOAD)
		owner:DoReloadEvent()
		self:SetNextPrimaryFire(CurTime() + self.ReloadDelay)

		timer.Simple(0.25, function()
			if self:IsValid() and IsValid(owner) then
				self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
			end
		end)
	end
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	if tr.HitGroup == HITGROUP_HEAD then
		local ent = tr.Entity
		if ent:IsValid() and ent:IsPlayer() then
			if ent:Team() == TEAM_UNDEAD and ent:GetZombieClassTable().Boss then
				GenericBulletCallback(attacker, tr, dmginfo)
				return
			end

			ent.Gibbed = CurTime()
		end

		if gamemode.Call("PlayerShouldTakeDamage", ent, attacker) then
			INFDAMAGEFLOATER = true
			ent:SetHealth(math.max(ent:Health() - 400, 1))
		end
	end

	GenericBulletCallback(attacker, tr, dmginfo)
end
