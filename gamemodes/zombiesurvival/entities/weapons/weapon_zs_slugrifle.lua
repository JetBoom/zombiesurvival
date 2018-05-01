AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_baseshotgun")

SWEP.PrintName = "'Tiny' Slug Rifle"
SWEP.Description = "This powerful rifle deals massive damage on a head shot."
SWEP.Slot = 3
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "v_weapon.xm1014_Bolt"
	SWEP.HUD3DPos = Vector(-1, 0, 0)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.02

	SWEP.VElements = {
		["scopemid"] = { type = "Model", model = "models/xqm/rails/funnel.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "scopebeginning", pos = Vector(4.645, 0, 0), angle = Angle(90, 0, 0), size = Vector(0.02, 0.02, 0.075), color = Color(95, 95, 95, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
		["scopebeginning"] = { type = "Model", model = "models/XQM/deg360.mdl", bone = "v_weapon.xm1014_Parent", rel = "", pos = Vector(0.079, -6.515, -0.695), angle = Angle(-90, 0, 0), size = Vector(0.019, 0.041, 0.041), color = Color(105, 105, 105, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
		["knobs+"] = { type = "Model", model = "models/XQM/cylinderx1.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "scopebeginning", pos = Vector(5.763, -0.769, 0), angle = Angle(180, 90, 98.054), size = Vector(0.079, 0.079, 0.079), color = Color(105, 105, 105, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
		["mount"] = { type = "Model", model = "models/XQM/CoasterTrack/track_guide.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "scopebeginning", pos = Vector(6.022, 1.996, 0), angle = Angle(90, -90, 0), size = Vector(0.037, 0.041, 0.056), color = Color(105, 105, 105, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
		["scopemid+"] = { type = "Model", model = "models/xqm/rails/funnel.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "scopebeginning", pos = Vector(8.166, 0, 0), angle = Angle(-90, 0, 0), size = Vector(0.02, 0.02, 0.014), color = Color(105, 105, 105, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
		["scopebeginning+++"] = { type = "Model", model = "models/XQM/deg360.mdl", bone = "v_weapon.xm1014_Parent", rel = "scopebeginning", pos = Vector(9.295, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.014, 0.041, 0.041), color = Color(105, 105, 105, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
		["midsection"] = { type = "Model", model = "models/props_phx/misc/smallcannonball.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "scopebeginning", pos = Vector(5.747, -0.026, -0.81), angle = Angle(-90, 0, 0), size = Vector(0.114, 0.114, 0.114), color = Color(105, 105, 105, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
		["scopebeginning++"] = { type = "Model", model = "models/XQM/deg360.mdl", bone = "v_weapon.xm1014_Parent", rel = "scopebeginning", pos = Vector(7.31, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.043, 0.019, 0.017), color = Color(105, 105, 105, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
		["scopebeginning+"] = { type = "Model", model = "models/XQM/deg360.mdl", bone = "v_weapon.xm1014_Parent", rel = "scopebeginning", pos = Vector(4.828, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.028, 0.019, 0.014), color = Color(105, 105, 105, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
		["glass"] = { type = "Model", model = "models/XQM/panel360.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "scopebeginning", pos = Vector(-0.238, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.039, 0.039, 0.039), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/dome_side", skin = 0, bodygroup = {} },
		["knobs"] = { type = "Model", model = "models/XQM/cylinderx1.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "scopebeginning", pos = Vector(5.763, 0, 0), angle = Angle(90, 0, 0), size = Vector(0.159, 0.079, 0.079), color = Color(105, 105, 105, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["scopemid"] = { type = "Model", model = "models/xqm/rails/funnel.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "scopebeginning", pos = Vector(4.645, 0, -0.04), angle = Angle(90, 0, 0), size = Vector(0.02, 0.02, 0.075), color = Color(95, 95, 95, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
		["scopebeginning"] = { type = "Model", model = "models/XQM/deg360.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.928, 0.908, -5.581), angle = Angle(-10, 0, -90), size = Vector(0.019, 0.041, 0.041), color = Color(105, 105, 105, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
		["knobs+"] = { type = "Model", model = "models/XQM/cylinderx1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "scopebeginning", pos = Vector(5.763, -0.769, 0), angle = Angle(180, 90, 98.054), size = Vector(0.079, 0.079, 0.079), color = Color(105, 105, 105, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
		["glass+"] = { type = "Model", model = "models/XQM/panel360.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "scopebeginning", pos = Vector(9.529, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.039, 0.039, 0.039), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/dome_side", skin = 0, bodygroup = {} },
		["mount"] = { type = "Model", model = "models/XQM/CoasterTrack/track_guide.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "scopebeginning", pos = Vector(6.022, 1.996, 0), angle = Angle(90, -90, 0), size = Vector(0.037, 0.041, 0.056), color = Color(105, 105, 105, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
		["glass"] = { type = "Model", model = "models/XQM/panel360.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "scopebeginning", pos = Vector(-0.238, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.039, 0.039, 0.039), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/dome_side", skin = 0, bodygroup = {} },
		["scopebeginning+++"] = { type = "Model", model = "models/XQM/deg360.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "scopebeginning", pos = Vector(9.274, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.014, 0.041, 0.041), color = Color(105, 105, 105, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
		["scopebeginning++"] = { type = "Model", model = "models/XQM/deg360.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "scopebeginning", pos = Vector(7.31, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.043, 0.019, 0.017), color = Color(105, 105, 105, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
		["scopemid+"] = { type = "Model", model = "models/xqm/rails/funnel.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "scopebeginning", pos = Vector(8.166, 0, 0.05), angle = Angle(-90, 0, 0), size = Vector(0.02, 0.02, 0.014), color = Color(105, 105, 105, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
		["scopebeginning+"] = { type = "Model", model = "models/XQM/deg360.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "scopebeginning", pos = Vector(4.828, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.028, 0.019, 0.014), color = Color(105, 105, 105, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
		["midsection"] = { type = "Model", model = "models/props_phx/misc/smallcannonball.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "scopebeginning", pos = Vector(5.747, -0.026, -0.81), angle = Angle(-90, 0, 0), size = Vector(0.114, 0.114, 0.114), color = Color(105, 105, 105, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
		["knobs"] = { type = "Model", model = "models/XQM/cylinderx1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "scopebeginning", pos = Vector(5.763, 0, 0), angle = Angle(90, 0, 0), size = Vector(0.159, 0.079, 0.079), color = Color(105, 105, 105, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_baseshotgun"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/cstrike/c_shot_xm1014.mdl"
SWEP.WorldModel = "models/weapons/w_shot_xm1014.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("Weapon_AWP.Single")
SWEP.Primary.Damage = 118
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 1.3
SWEP.ReloadDelay = 0.6

SWEP.Primary.ClipSize = 4
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "357"
SWEP.Primary.DefaultClip = 10

SWEP.HeadshotMulti = 2.5

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN

SWEP.ConeMax = 6
SWEP.ConeMin = 0.25

SWEP.Tier = 4
SWEP.MaxStock = 3

SWEP.IronSightsPos = Vector(0, 0, 0)
SWEP.IronSightsAng = Vector(0, -1, 0)

SWEP.WalkSpeed = SPEED_SLOWER

GAMEMODE:SetPrimaryWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.135)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.09, 1)

function SWEP:IsScoped()
	return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.25 <= CurTime()
end

function SWEP:SecondaryAttack()
	return BaseClass.BaseClass.SecondaryAttack(self)
end

function SWEP:Think()
	if self:GetIronsights() and not self:GetOwner():KeyDown(IN_ATTACK2) then
		self:SetIronsights(false)
	end

	BaseClass.Think(self)
end

if CLIENT then
	SWEP.IronsightsMultiplier = 0.25

	function SWEP:GetViewModelPosition(pos, ang)
		if GAMEMODE.DisableScopes then return end

		if self:IsScoped() then
			return pos + ang:Up() * 256, ang
		end

		return BaseClass.GetViewModelPosition(self, pos, ang)
	end

	function SWEP:DrawHUDBackground()
		if GAMEMODE.DisableScopes then return end

		if self:IsScoped() then
			self:DrawRegularScope()
		end
	end
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	if tr.HitGroup == HITGROUP_HEAD then
		local ent = tr.Entity
		if ent:IsValidLivingZombie() and ent:GetZombieClassTable().Boss then
			return
		end

		if gamemode.Call("PlayerShouldTakeDamage", ent, attacker) then
			dmginfo:SetDamageType(DMG_DIRECT)
			dmginfo:SetDamage(dmginfo:GetDamage() + ent:GetMaxHealthEx() * 0.55)
		end
	end
end
