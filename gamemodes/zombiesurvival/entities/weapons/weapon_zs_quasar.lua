AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = "'Quasar' Pulse Rifle"
SWEP.Description = "A scoped pulse rifle that slows targets. Uses 4 pulse per shot."

if CLIENT then
	SWEP.Slot = 3
	SWEP.SlotPos = 0

	SWEP.ViewModelFlip = false
	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false

	SWEP.VElements = {
		["base+++"] = { type = "Model", model = Model("models/props_combine/combinecrane002.mdl"), bone = "v_weapon.awm_parent", rel = "base", pos = Vector(-19.8, -0.774, 2.871), angle = Angle(90, 90, 90), size = Vector(0.026, 0.017, 0.059), color = Color(200, 228, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base++"] = { type = "Model", model = Model("models/props_combine/combinecrane002.mdl"), bone = "v_weapon.awm_parent", rel = "base", pos = Vector(-19.8, 0.518, 0.902), angle = Angle(-90, 90, 90), size = Vector(0.026, 0.017, 0.059), color = Color(194, 228, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base+++++++"] = { type = "Model", model = Model("models/props_combine/combine_binocular01.mdl"), bone = "v_weapon.awm_parent", rel = "base", pos = Vector(4.922, 0.052, 1.103), angle = Angle(-9.115, 0, 0), size = Vector(0.246, 0.261, 0.115), color = Color(143, 195, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base+"] = { type = "Model", model = Model("models/props_combine/combinethumper002.mdl"), bone = "v_weapon.awm_parent", rel = "base", pos = Vector(-3.194, -0.471, 2.769), angle = Angle(-180, 90, -90), size = Vector(0.034, 0.052, 0.068), color = Color(165, 214, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base++++"] = { type = "Model", model = Model("models/props_combine/combine_light002a.mdl"), bone = "v_weapon.awm_parent", rel = "base", pos = Vector(6.977, 0, 4.546), angle = Angle(-90, -90, 90), size = Vector(0.167, 0.196, 0.273), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base++++++"] = { type = "Model", model = Model("models/props_combine/combine_barricade_bracket01a.mdl"), bone = "v_weapon.awm_parent", rel = "base", pos = Vector(11.1, -0.592, 2.599), angle = Angle(166.227, 0, 90), size = Vector(0.423, 0.317, 0.291), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["bolt"] = { type = "Model", model = Model("models/props_combine/combinecamera001.mdl"), bone = "v_weapon.awm_bolt_action", rel = "", pos = Vector(-2.214, 0.8, -1.382), angle = Angle(-7.282, -6.264, 1.56), size = Vector(0.104, 0.184, 0.209), color = Color(200, 228, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base"] = { type = "Model", model = Model("models/props_combine/combinetrain01a.mdl"), bone = "v_weapon.awm_parent", rel = "", pos = Vector(0.082, -2.309, -5.773), angle = Angle(90, -90, 0), size = Vector(0.02, 0.017, 0.014), color = Color(150, 206, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base++++++++"] = { type = "Model", model = Model("models/props_c17/light_decklight01_on.mdl"), bone = "v_weapon.awm_parent", rel = "base", pos = Vector(6.581, 0, 5.449), angle = Angle(0, 0, 90), size = Vector(0.029, 0.039, 0.029), color = Color(150, 200, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["mag"] = { type = "Model", model = Model("models/Items/combine_rifle_cartridge01.mdl"), bone = "v_weapon.awm_clip", rel = "", pos = Vector(0.1, 0.294, -0.501), angle = Angle(127.601, -90, 0), size = Vector(0.321, 0.605, 0.337), color = Color(200, 228, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base+++++"] = { type = "Model", model = Model("models/props_combine/combine_barricade_bracket01b.mdl"), bone = "v_weapon.awm_parent", rel = "base", pos = Vector(10.55, -0.592, -3.32), angle = Angle(-172.286, 0, 90), size = Vector(0.423, 0.23, 0.291), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["base+++"] = { type = "Model", model = Model("models/props_combine/combinecrane002.mdl"), bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-19.8, -0.774, 2.871), angle = Angle(90, 90, 90), size = Vector(0.026, 0.017, 0.059), color = Color(200, 228, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base++"] = { type = "Model", model = Model("models/props_combine/combinecrane002.mdl"), bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-19.8, 0.518, 0.902), angle = Angle(-90, 90, 90), size = Vector(0.026, 0.017, 0.059), color = Color(194, 228, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base+++++++"] = { type = "Model", model = Model("models/props_combine/combine_binocular01.mdl"), bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(4.922, 0.052, 1.103), angle = Angle(-9.115, 0, 0), size = Vector(0.246, 0.261, 0.115), color = Color(143, 195, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base+"] = { type = "Model", model = Model("models/props_combine/combinethumper002.mdl"), bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-3.194, -0.471, 2.769), angle = Angle(-180, 90, -90), size = Vector(0.034, 0.052, 0.068), color = Color(165, 214, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base++++"] = { type = "Model", model = Model("models/props_combine/combine_light002a.mdl"), bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(6.977, 0, 4.546), angle = Angle(-90, -90, 90), size = Vector(0.167, 0.196, 0.273), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base++++++"] = { type = "Model", model = Model("models/props_combine/combine_barricade_bracket01a.mdl"), bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(11.1, -0.592, 2.599), angle = Angle(166.227, 0, 90), size = Vector(0.423, 0.317, 0.291), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["bolt"] = { type = "Model", model = Model("models/props_combine/combinecamera001.mdl"), bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(1.754, 2.461, 1.468), angle = Angle(-7.752, 89.405, 92.916), size = Vector(0.104, 0.184, 0.209), color = Color(200, 228, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base"] = { type = "Model", model = Model("models/props_combine/combinetrain01a.mdl"), bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(10.618, 1.266, -2.902), angle = Angle(169.628, 0, 0), size = Vector(0.02, 0.017, 0.014), color = Color(150, 206, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base+++++"] = { type = "Model", model = Model("models/props_combine/combine_barricade_bracket01b.mdl"), bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(10.55, -0.592, -3.32), angle = Angle(-172.286, 0, 90), size = Vector(0.423, 0.23, 0.291), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["mag"] = { type = "Model", model = Model("models/Items/combine_rifle_cartridge01.mdl"), bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0.837, 0, -0.113), angle = Angle(62.376, 0, 0), size = Vector(0.321, 0.605, 0.337), color = Color(200, 228, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base++++++++"] = { type = "Model", model = Model("models/props_c17/light_decklight01_on.mdl"), bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(6.581, 0, 5.449), angle = Angle(0, 0, 90), size = Vector(0.029, 0.039, 0.029), color = Color(150, 200, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.HUD3DBone = "v_weapon.awm_parent"
	SWEP.HUD3DPos = Vector(-1.4, -5.35, -2.5)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.015
end

sound.Add(
{
	name = "Weapon_Quasar.Single",
	channel = CHAN_AUTO,
	volume = 1,
	soundlevel = 100,
	pitch = {105,115},
	sound = {"npc/sniper/sniper1.wav"}
})

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/cstrike/c_snip_awp.mdl"
SWEP.WorldModel = "models/weapons/w_snip_awp.mdl"
SWEP.UseHands = true

SWEP.ReloadSound = Sound("Weapon_AWP.ClipOut")
SWEP.Primary.Sound = Sound("Weapon_Quasar.Single")
SWEP.Primary.Damage = 110
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 1.05
SWEP.ReloadDelay = SWEP.Primary.Delay
SWEP.RequiredClip = 4

SWEP.Primary.ClipSize = 24
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pulse"
SWEP.Primary.DefaultClip = 25

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN

SWEP.ConeMax = 3
SWEP.ConeMin = 0
SWEP.IronSightsPos = Vector(5.015, -8, 2.52)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.WalkSpeed = SPEED_SLOW

SWEP.TracerName = "AR2Tracer"

SWEP.FireAnimSpeed = 1.3

SWEP.Tier = 4
SWEP.MaxStock = 3

SWEP.PointsMultiplier = GAMEMODE.PulsePointsMultiplier

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 4)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, "'Blazar' Pulse Tri-Rifle", "Shoots 3 pulse shots in a spread out line with more total damage", function(wept)
	wept.Primary.NumShots = 3
	wept.Primary.Damage = wept.Primary.Damage * 1.2/3

	wept.ConeMax = 5
	wept.ConeMin = 4
	wept.ShootBullets = function(self, dmg, numbul, cone)
		local owner = self:GetOwner()

		self:SendWeaponAnimation()
		owner:DoAttackEvent()

		owner:LagCompensation(true)
		for i = 1, numbul do
			local angle = owner:GetAimVector():Angle()
			angle:RotateAroundAxis(angle:Up(), (i - math.ceil(3/2)) * 2.75*cone/6)

			owner:FireBulletsLua(owner:GetShootPos(), angle:Forward(), cone/2, 1, dmg, nil, self.Primary.KnockbackScale, self.TracerName, self.BulletCallback, self.Primary.HullSize, nil, self.Primary.MaxDistance, nil, self)
		end
		owner:LagCompensation(false)
	end

	wept.EmitFireSound = function(self)
		self:EmitSound(self.Primary.Sound)
		self:EmitSound("weapons/flaregun/fire.wav", 70, math.random(95, 105), 1, CHAN_WEAPON)
		self:EmitSound("weapons/physcannon/superphys_launch1.wav", 72, 158, 0.75, CHAN_WEAPON + 1)
	end
end)

function SWEP:IsScoped()
	return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.25 <= CurTime()
end

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound)
	self:EmitSound("weapons/flaregun/fire.wav", 70, math.random(95, 105), 1, CHAN_WEAPON)
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity
	if ent:IsValid() and ent:IsPlayer() and ent:Team() == TEAM_UNDEAD then
		ent:AddLegDamageExt(8, attacker, attacker:GetActiveWeapon(), SLOWTYPE_PULSE)
	end

	if IsFirstTimePredicted() then
		util.CreatePulseImpactEffect(tr.HitPos, tr.HitNormal)
	end
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
		if not self:IsScoped() then return end

		self:DrawFuturisticScope()
	end
end
