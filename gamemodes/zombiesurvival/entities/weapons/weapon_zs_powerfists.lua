AddCSLuaFile()

SWEP.Base = "weapon_zs_fists"

SWEP.PrintName = "Power Fists"
SWEP.Description = "A pair of power fists. They are slower than conventional fist combat, but pack a hefty pulse powered punch."

if CLIENT then
	SWEP.ViewModelFOV = 65
	SWEP.ViewModelFlip = false

	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false

	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/props_c17/TrapPropeller_Engine.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1.129, 0.087, -1), angle = Angle(0, 90.421, 90.749), size = Vector(0.18, 0.18, 0.3), color = Color(105, 75, 65, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["base++"] = { type = "Model", model = "models/props_c17/TrapPropeller_Engine.mdl", bone = "ValveBiped.Bip01_R_Finger2", rel = "base", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.28, 0.21, 0.15), color = Color(135, 115, 95, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
		["base+"] = { type = "Model", model = "models/props_c17/TrapPropeller_Engine.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(1.129, -1.087, 2), angle = Angle(230, 90, 90), size = Vector(0.18, 0.18, 0.3), color = Color(105, 75, 65, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["base+++"] = { type = "Model", model = "models/props_c17/TrapPropeller_Engine.mdl", bone = "ValveBiped.Bip01_R_Finger2", rel = "base+", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.28, 0.21, 0.15), color = Color(135, 115, 95, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
	}

	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/props_c17/TrapPropeller_Engine.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.129, -1.087, 0), angle = Angle(0, 90.421, 90.749), size = Vector(0.18, 0.18, 0.3), color = Color(105, 75, 65, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["base++"] = { type = "Model", model = "models/props_c17/TrapPropeller_Engine.mdl", bone = "ValveBiped.Bip01_R_Finger2", rel = "base", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.28, 0.21, 0.15), color = Color(135, 115, 95, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
		["base+"] = { type = "Model", model = "models/props_c17/TrapPropeller_Engine.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(3.129, -1.087, 0), angle = Angle(230, 90, 90), size = Vector(0.18, 0.18, 0.3), color = Color(105, 75, 65, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["base+++"] = { type = "Model", model = "models/props_c17/TrapPropeller_Engine.mdl", bone = "ValveBiped.Bip01_R_Finger2", rel = "base+", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.28, 0.21, 0.15), color = Color(135, 115, 95, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
	}
end

SWEP.WalkSpeed = SPEED_FAST
SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/c_arms_hev.mdl"
SWEP.WorldModel	= "models/weapons/w_grenade.mdl"

SWEP.Weight = 4

SWEP.MeleeDamage = 86
SWEP.LegDamage = 17

SWEP.Unarmed = false

SWEP.Undroppable = false
SWEP.NoPickupNotification = false
SWEP.NoDismantle = false

SWEP.NoGlassWeapons = false

SWEP.AllowQualityWeapons = true
SWEP.SwingSound = Sound( "weapons/zs_power/power1.ogg" )
SWEP.HitSound = Sound( "weapons/zs_power/power4.wav" )

SWEP.FistKnockback = true
SWEP.MeleeKnockBack = 200

SWEP.Primary.Delay = 0.65

SWEP.Tier = 4

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.07, 1)

function SWEP:OnMeleeHit(hitent, hitflesh, tr)
	if hitent:IsValid() then
		util.CreatePulseImpactEffect(tr.HitPos, tr.HitNormal)

		if hitent:IsPlayer() then
			hitent:AddLegDamageExt(self.LegDamage, self:GetOwner(), self, SLOWTYPE_PULSE)
			hitent:EmitSound("Weapon_StunStick.Melee_Hit")
		end
	end
end
