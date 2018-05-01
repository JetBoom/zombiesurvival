AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = "'Terminus' SCAR-L"
SWEP.Description = "A powerful assault rifle that gets more accurate for every shot that hits in a clip."

SWEP.Slot = 2
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.ViewModelFlip = false
	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false

	SWEP.HUD3DBone = "v_weapon.sg550_Parent"
	SWEP.HUD3DPos = Vector(-1.3, -5.56, -2)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.02

	SWEP.VElements = {
		["base+++++"] = { type = "Model", model = "models/props_trainstation/trainstation_column001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "base", pos = Vector(-0.399, -10.077, 0.458), angle = Angle(0, 0, -90), size = Vector(0.09, 0.09, 0.041), color = Color(200, 200, 200, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base++++++++++++"] = { type = "Model", model = "models/props_phx/trains/tracks/track_2x.mdl", bone = "v_weapon.sg550_Parent", rel = "base", pos = Vector(-1.147, -5.325, 0.579), angle = Angle(0, 90, 90), size = Vector(0.019, 0.008, 0.029), color = Color(80, 80, 80, 255), surpresslightning = false, material = "phoenix_storms/concrete2", skin = 0, bodygroup = {} },
		["base++++++++++++++"] = { type = "Model", model = "models/hunter/blocks/cube025x2x025.mdl", bone = "v_weapon.sg550_Parent", rel = "base", pos = Vector(0.133, -6.993, -0.058), angle = Angle(0, 0, 0), size = Vector(0.093, 0.067, 0.109), color = Color(80, 80, 80, 255), surpresslightning = false, material = "phoenix_storms/concrete2", skin = 0, bodygroup = {} },
		["base++++"] = { type = "Model", model = "models/props_phx/trains/tracks/track_2x.mdl", bone = "v_weapon.sg550_Parent", rel = "base", pos = Vector(-0.431, -3.07, -1.063), angle = Angle(0, 90, 0), size = Vector(0.029, 0.004, 0.029), color = Color(80, 80, 80, 255), surpresslightning = false, material = "phoenix_storms/concrete2", skin = 0, bodygroup = {} },
		["mag"] = { type = "Model", model = "models/hunter/blocks/cube1x1x1.mdl", bone = "v_weapon.sg550_Clip", rel = "", pos = Vector(-0.03, 2.838, -0.187), angle = Angle(0, 0, 11.232), size = Vector(0.017, 0.14, 0.068), color = Color(80, 80, 80, 255), surpresslightning = false, material = "phoenix_storms/concrete2", skin = 0, bodygroup = {} },
		["base+++++++++++"] = { type = "Model", model = "models/hunter/blocks/cube1x1x025.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "base", pos = Vector(-0.401, 18.51, -1.601), angle = Angle(92.424, -90, 0), size = Vector(0.129, 0.028, 0.054), color = Color(80, 80, 80, 255), surpresslightning = false, material = "phoenix_storms/concrete1", skin = 0, bodygroup = {} },
		["base+++"] = { type = "Model", model = "models/hunter/blocks/cube025x2x025.mdl", bone = "v_weapon.sg550_Parent", rel = "base", pos = Vector(0, -5.474, -0.886), angle = Angle(0, 0, 0), size = Vector(0.074, 0.097, 0.078), color = Color(80, 80, 80, 255), surpresslightning = false, material = "phoenix_storms/concrete2", skin = 0, bodygroup = {} },
		["base++++++++++++++++"] = { type = "Model", model = "models/props_pipes/concrete_pipe001a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "base", pos = Vector(-0.429, -10.79, 3.95), angle = Angle(-180, 90, 0), size = Vector(0.004, 0.009, 0.009), color = Color(80, 80, 80, 255), surpresslightning = false, material = "phoenix_storms/concrete2", skin = 0, bodygroup = {} },
		["base++"] = { type = "Model", model = "models/props_phx/trains/tracks/track_8x.mdl", bone = "v_weapon.sg550_Parent", rel = "base", pos = Vector(-0.431, -3.901, 2.5), angle = Angle(180, 90, 0), size = Vector(0.017, 0.004, 0.029), color = Color(80, 80, 80, 255), surpresslightning = false, material = "phoenix_storms/concrete1", skin = 0, bodygroup = {} },
		["base+++++++"] = { type = "Model", model = "models/weapons/w_pist_glock18.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "base", pos = Vector(-0.452, 7.76, -6.605), angle = Angle(0.172, 90, 0), size = Vector(1.18, 0.879, 1.059), color = Color(80, 80, 80, 255), surpresslightning = false, material = "phoenix_storms/concrete0", skin = 0, bodygroup = {} },
		["base+"] = { type = "Model", model = "models/hunter/blocks/cube025x2x025.mdl", bone = "v_weapon.sg550_Parent", rel = "base", pos = Vector(-0.11, 0, 1.697), angle = Angle(0, 0, 0), size = Vector(0.054, 0.214, 0.056), color = Color(80, 80, 80, 255), surpresslightning = false, material = "phoenix_storms/concrete2", skin = 0, bodygroup = {} },
		["base+++++++++++++++"] = { type = "Model", model = "models/props_combine/combinethumper002.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "base", pos = Vector(-0.581, 9.357, 2.319), angle = Angle(0, 0, 0), size = Vector(0.014, 0.012, 0.006), color = Color(80, 80, 80, 255), surpresslightning = false, material = "phoenix_storms/concrete2", skin = 0, bodygroup = {} },
		["base+++++++++++++++++"] = { type = "Model", model = "models/props_pipes/concrete_pipe001a.mdl", bone = "v_weapon.sg550_Chamber", rel = "", pos = Vector(-0.633, -0.877, -4.751), angle = Angle(-180, 0, 0), size = Vector(0.008, 0.004, 0.004), color = Color(80, 80, 80, 255), surpresslightning = false, material = "phoenix_storms/concrete2", skin = 0, bodygroup = {} },
		["base++++++"] = { type = "Model", model = "models/props_combine/combine_binocular01.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "base", pos = Vector(-0.429, -10.709, 2.403), angle = Angle(-180, 90, 0), size = Vector(0.104, 0.076, 0.054), color = Color(80, 80, 80, 255), surpresslightning = false, material = "phoenix_storms/concrete2", skin = 0, bodygroup = {} },
		["base"] = { type = "Model", model = "models/hunter/blocks/cube025x2x025.mdl", bone = "v_weapon.sg550_Parent", rel = "", pos = Vector(0.398, -4.837, -6.283), angle = Angle(0, 0, -90), size = Vector(0.074, 0.214, 0.142), color = Color(80, 80, 80, 255), surpresslightning = false, material = "phoenix_storms/concrete1", skin = 0, bodygroup = {} },
		["base+++++++++"] = { type = "Model", model = "models/Gibs/helicopter_brokenpiece_03.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "base", pos = Vector(-0.464, 12.635, -0.173), angle = Angle(13.321, 85.75, -18.448), size = Vector(0.123, 0.065, 0.14), color = Color(80, 80, 80, 255), surpresslightning = false, material = "phoenix_storms/concrete2", skin = 0, bodygroup = {} },
		["base++++++++"] = { type = "Model", model = "models/hunter/blocks/cube025x1x025.mdl", bone = "v_weapon.sg550_Parent", rel = "base", pos = Vector(0.05, 1.534, -2.869), angle = Angle(0, 0, 9.149), size = Vector(0.079, 0.082, 0.207), color = Color(80, 80, 80, 255), surpresslightning = false, material = "phoenix_storms/concrete0", skin = 0, bodygroup = {} },
		["base++++++++++"] = { type = "Model", model = "models/hunter/triangles/trapezium3x3x1c.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "base", pos = Vector(-0.401, 16.805, -1.68), angle = Angle(92.424, -90, 0), size = Vector(0.063, 0.027, 0.059), color = Color(80, 80, 80, 255), surpresslightning = false, material = "phoenix_storms/concrete1", skin = 0, bodygroup = {} },
		["base++++++++++++++++++"] = { type = "Model", model = "models/hunter/blocks/cube025x2x025.mdl", bone = "v_weapon.sg550_Parent", rel = "base", pos = Vector(-0.565, 1.32, 1.84), angle = Angle(0, 0, 0), size = Vector(0.02, 0.052, 0.029), color = Color(80, 80, 80, 255), surpresslightning = false, material = "phoenix_storms/concrete2", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["base+++++"] = { type = "Model", model = "models/props_trainstation/trainstation_column001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-0.399, -10.077, 0.458), angle = Angle(0, 0, -90), size = Vector(0.09, 0.09, 0.041), color = Color(200, 200, 200, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base+++++++++++++"] = { type = "Model", model = "models/props_phx/trains/tracks/track_2x.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0.282, -5.325, 0.579), angle = Angle(0, 90, -90), size = Vector(0.019, 0.008, 0.029), color = Color(80, 80, 80, 255), surpresslightning = false, material = "phoenix_storms/concrete2", skin = 0, bodygroup = {} },
		["base++++++++++++"] = { type = "Model", model = "models/props_phx/trains/tracks/track_2x.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-1.147, -5.325, 0.579), angle = Angle(0, 90, 90), size = Vector(0.019, 0.008, 0.029), color = Color(80, 80, 80, 255), surpresslightning = false, material = "phoenix_storms/concrete2", skin = 0, bodygroup = {} },
		["base++++++++++++++"] = { type = "Model", model = "models/hunter/blocks/cube025x2x025.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0.133, -6.993, -0.058), angle = Angle(0, 0, 0), size = Vector(0.093, 0.067, 0.109), color = Color(80, 80, 80, 255), surpresslightning = false, material = "phoenix_storms/concrete2", skin = 0, bodygroup = {} },
		["base++++"] = { type = "Model", model = "models/props_phx/trains/tracks/track_2x.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-0.431, -3.07, -1.063), angle = Angle(0, 90, 0), size = Vector(0.029, 0.004, 0.029), color = Color(80, 80, 80, 255), surpresslightning = false, material = "phoenix_storms/concrete2", skin = 0, bodygroup = {} },
		["base+++++++++++"] = { type = "Model", model = "models/hunter/blocks/cube1x1x025.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-0.401, 18.51, -1.601), angle = Angle(92.424, -90, 0), size = Vector(0.129, 0.028, 0.054), color = Color(80, 80, 80, 255), surpresslightning = false, material = "phoenix_storms/concrete1", skin = 0, bodygroup = {} },
		["base+++"] = { type = "Model", model = "models/hunter/blocks/cube025x2x025.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0, -5.474, -0.886), angle = Angle(0, 0, 0), size = Vector(0.074, 0.097, 0.078), color = Color(80, 80, 80, 255), surpresslightning = false, material = "phoenix_storms/concrete2", skin = 0, bodygroup = {} },
		["base++++++++++++++++"] = { type = "Model", model = "models/props_pipes/concrete_pipe001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-0.429, -10.79, 3.95), angle = Angle(-180, 90, 0), size = Vector(0.004, 0.009, 0.009), color = Color(80, 80, 80, 255), surpresslightning = false, material = "phoenix_storms/concrete2", skin = 0, bodygroup = {} },
		["base++"] = { type = "Model", model = "models/props_phx/trains/tracks/track_8x.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-0.431, -3.901, 2.5), angle = Angle(180, 90, 0), size = Vector(0.017, 0.004, 0.029), color = Color(80, 80, 80, 255), surpresslightning = false, material = "phoenix_storms/concrete1", skin = 0, bodygroup = {} },
		["base+++++++"] = { type = "Model", model = "models/weapons/w_pist_glock18.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-0.452, 7.76, -6.605), angle = Angle(0.172, 90, 0), size = Vector(1.18, 0.879, 1.059), color = Color(80, 80, 80, 255), surpresslightning = false, material = "phoenix_storms/concrete0", skin = 0, bodygroup = {} },
		["base+"] = { type = "Model", model = "models/hunter/blocks/cube025x2x025.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-0.11, 0, 1.697), angle = Angle(0, 0, 0), size = Vector(0.054, 0.214, 0.056), color = Color(80, 80, 80, 255), surpresslightning = false, material = "phoenix_storms/concrete2", skin = 0, bodygroup = {} },
		["base+++++++++++++++"] = { type = "Model", model = "models/props_combine/combinethumper002.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-0.581, 9.357, 2.319), angle = Angle(0, 0, 0), size = Vector(0.014, 0.012, 0.006), color = Color(80, 80, 80, 255), surpresslightning = false, material = "phoenix_storms/concrete2", skin = 0, bodygroup = {} },
		["base"] = { type = "Model", model = "models/hunter/blocks/cube025x2x025.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(11.472, 0.644, -4.957), angle = Angle(-180, -84.611, 9.975), size = Vector(0.074, 0.214, 0.142), color = Color(80, 80, 80, 255), surpresslightning = false, material = "phoenix_storms/concrete1", skin = 0, bodygroup = {} },
		["base++++++"] = { type = "Model", model = "models/props_combine/combine_binocular01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-0.429, -10.709, 2.403), angle = Angle(-180, 90, 0), size = Vector(0.104, 0.076, 0.054), color = Color(80, 80, 80, 255), surpresslightning = false, material = "phoenix_storms/concrete2", skin = 0, bodygroup = {} },
		["mag"] = { type = "Model", model = "models/hunter/blocks/cube1x1x1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-0.408, 1.106, -5.235), angle = Angle(0, 0, 102.095), size = Vector(0.017, 0.14, 0.068), color = Color(80, 80, 80, 255), surpresslightning = false, material = "phoenix_storms/concrete2", skin = 0, bodygroup = {} },
		["base+++++++++"] = { type = "Model", model = "models/Gibs/helicopter_brokenpiece_03.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-0.464, 12.635, -0.173), angle = Angle(13.321, 85.75, -18.448), size = Vector(0.123, 0.065, 0.14), color = Color(80, 80, 80, 255), surpresslightning = false, material = "phoenix_storms/concrete2", skin = 0, bodygroup = {} },
		["base++++++++"] = { type = "Model", model = "models/hunter/blocks/cube025x1x025.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0.05, 1.534, -2.869), angle = Angle(0, 0, 9.149), size = Vector(0.079, 0.082, 0.207), color = Color(80, 80, 80, 255), surpresslightning = false, material = "phoenix_storms/concrete0", skin = 0, bodygroup = {} },
		["base++++++++++"] = { type = "Model", model = "models/hunter/triangles/trapezium3x3x1c.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-0.401, 16.805, -1.68), angle = Angle(92.424, -90, 0), size = Vector(0.063, 0.027, 0.059), color = Color(80, 80, 80, 255), surpresslightning = false, material = "phoenix_storms/concrete1", skin = 0, bodygroup = {} },
		["base++++++++++++++++++"] = { type = "Model", model = "models/hunter/blocks/cube025x2x025.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-0.565, 1.32, 1.84), angle = Angle(0, 0, 0), size = Vector(0.02, 0.052, 0.029), color = Color(80, 80, 80, 255), surpresslightning = false, material = "phoenix_storms/concrete2", skin = 0, bodygroup = {} }
	}
end

sound.Add(
{
	name = "Weapon_Scar.Single",
	channel = CHAN_WEAPON,
	volume = 1,
	level = 85,
	pitch = {85,90},
	sound = {"weapons/zs_scar/scar_fire1.ogg"}
})

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/cstrike/c_snip_sg550.mdl"
SWEP.WorldModel = "models/weapons/w_snip_sg550.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("Weapon_Scar.Single")
SWEP.Primary.Damage = 27.5
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.1

SWEP.Primary.ClipSize = 30
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_AR2

SWEP.ConeMax = 3.5
SWEP.ConeMin = 1.4

SWEP.WalkSpeed = SPEED_SLOW

SWEP.Tier = 5
SWEP.MaxStock = 2

SWEP.FireAnimSpeed = 0.65

SWEP.IronSightsPos = Vector(-7.361, 0, 0.62)

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 3)

function SWEP:SetHitStacks(stacks)
	self:SetDTInt(9, stacks)
end

function SWEP:GetHitStacks()
	return self:GetDTInt(9)
end

function SWEP:FinishReload()
	self:SetHitStacks(0)
	BaseClass.FinishReload(self)
end

function SWEP:GetCone()
	return BaseClass.GetCone(self) * (1 - self:GetHitStacks()/35)
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity
	if SERVER then
		local wep = attacker:GetActiveWeapon()
		if ent:IsValidZombie() then
			wep:SetHitStacks(wep:GetHitStacks() + 1)
		end
	end
end
