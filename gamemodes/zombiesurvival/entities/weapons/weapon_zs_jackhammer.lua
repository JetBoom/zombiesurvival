AddCSLuaFile()

SWEP.PrintName = "'Jackhammer' Drum Shotgun"
SWEP.Description = "An automatic drum shotgun with a large clip size."

if CLIENT then
	SWEP.Slot = 3
	SWEP.SlotPos = 0

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 59

	SWEP.HUD3DBone = "v_weapon.galil"
	SWEP.HUD3DPos = Vector(1.3, -0.3, 2)
	SWEP.HUD3DScale = 0.018

	SWEP.VElements = {
		["t4_shot_part+++++++"] = { type = "Model", model = Model("models/props_pipes/concrete_pipe001a.mdl"), bone = "ValveBiped.Bip01_R_Hand", rel = "t4_shot_part+", pos = Vector(0, 11, 1.5), angle = Angle(90, 0, 0), size = Vector(0.032, 0.009, 0.009), color = Color(30, 30, 30, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
		["t4_shot_part++++++"] = { type = "Model", model = Model("models/props_pipes/pipe02_straight01_long.mdl"), bone = "ValveBiped.Bip01_R_Hand", rel = "t4_shot_part+", pos = Vector(0, 13, -0.801), angle = Angle(0, 0, 0), size = Vector(0.17, 0.55, 0.17), color = Color(40, 40, 40, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
		["t4_shot_part++++"] = { type = "Model", model = Model("models/props_wasteland/controlroom_filecabinet002a.mdl"), bone = "ValveBiped.Bip01_R_Hand", rel = "t4_shot_part+", pos = Vector(0, -13, 0.618), angle = Angle(0, 0, 100), size = Vector(0.039, 0.15, 0.009), color = Color(60, 60, 60, 255), surpresslightning = false, material = "phoenix_storms/metalfloor_2-3", skin = 0, bodygroup = {} },
		["t4_shot_part+++"] = { type = "Model", model = Model("models/props_junk/ibeam01a_cluster01.mdl"), bone = "ValveBiped.Bip01_R_Hand", rel = "t4_shot_part+", pos = Vector(0, -7.301, 0.66), angle = Angle(180, -90, 0), size = Vector(0.059, 0.029, 0.039), color = Color(47, 22, 1, 255), surpresslightning = false, material = "models/props_pipes/pipemetal004a", skin = 0, bodygroup = {} },
		["t4_shot_part++"] = { type = "Model", model = Model("models/props_combine/combine_interface003.mdl"), bone = "ValveBiped.Bip01_R_Hand", rel = "t4_shot_part+", pos = Vector(0, -6.301, 2.799), angle = Angle(180, -90, 0), size = Vector(0.059, 0.022, 0.059), color = Color(79, 100, 135, 255), surpresslightning = false, material = "models/props_pipes/pipeset_metal", skin = 0, bodygroup = {} },
		["t4_shot_part+++++"] = { type = "Model", model = Model("models/props_wasteland/laundry_washer001a.mdl"), bone = "v_weapon.magazine", rel = "", pos = Vector(0, -0.801, 3), angle = Angle(0, 0, 0), size = Vector(0.054, 0.054, 0.07), color = Color(50, 50, 50, 255), surpresslightning = false, material = "models/props_canal/canal_bridge_railing_01c", skin = 0, bodygroup = {} },
		["t4_shot_part+"] = { type = "Model", model = Model("models/props_combine/combine_train02a.mdl"), bone = "ValveBiped.Bip01_R_Hand", rel = "t4_shot_part", pos = Vector(24.5, 4.38, -4.1), angle = Angle(180, 90, 0), size = Vector(0.013, 0.024, 0.009), color = Color(60, 60, 60, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
		["t4_shot_part"] = { type = "Model", model = Model("models/weapons/c_pistol.mdl"), bone = "v_weapon.galil", rel = "", pos = Vector(4.4, -5, -19.8), angle = Angle(90, 0, -90), size = Vector(0.8, 0.8, 1.21), color = Color(60, 60, 60, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["t4_shot_part++++++"] = { type = "Model", model = Model("models/props_pipes/pipe02_straight01_long.mdl"), bone = "ValveBiped.Bip01_R_Hand", rel = "t4_shot_part+", pos = Vector(0, 13, -0.801), angle = Angle(0, 0, 0), size = Vector(0.17, 0.3, 0.17), color = Color(30, 30, 30, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
		["t4_shot_part+++++++"] = { type = "Model", model = Model("models/props_pipes/concrete_pipe001a.mdl"), bone = "ValveBiped.Bip01_R_Hand", rel = "t4_shot_part+", pos = Vector(0, 11, 1.5), angle = Angle(90, 0, 0), size = Vector(0.032, 0.009, 0.009), color = Color(30, 30, 30, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
		["t4_shot_part++++"] = { type = "Model", model = Model("models/props_wasteland/controlroom_filecabinet002a.mdl"), bone = "ValveBiped.Bip01_R_Hand", rel = "t4_shot_part+", pos = Vector(0, -13, 0.618), angle = Angle(0, 0, 100), size = Vector(0.039, 0.15, 0.009), color = Color(60, 60, 60, 255), surpresslightning = false, material = "phoenix_storms/metalfloor_2-3", skin = 0, bodygroup = {} },
		["t4_shot_part+++"] = { type = "Model", model = Model("models/props_junk/ibeam01a_cluster01.mdl"), bone = "ValveBiped.Bip01_R_Hand", rel = "t4_shot_part+", pos = Vector(0, -7.301, 0.66), angle = Angle(180, -90, 0), size = Vector(0.059, 0.029, 0.039), color = Color(47, 22, 1, 255), surpresslightning = false, material = "models/props_pipes/pipemetal004a", skin = 0, bodygroup = {} },
		["t4_shot_part++"] = { type = "Model", model = Model("models/props_combine/combine_interface003.mdl"), bone = "ValveBiped.Bip01_R_Hand", rel = "t4_shot_part+", pos = Vector(0, -6.301, 2.799), angle = Angle(180, -90, 0), size = Vector(0.059, 0.029, 0.059), color = Color(79, 100, 135, 255), surpresslightning = false, material = "models/props_pipes/pipeset_metal", skin = 0, bodygroup = {} },
		["t4_shot_part+++++"] = { type = "Model", model = Model("models/props_wasteland/laundry_washer001a.mdl"), bone = "ValveBiped.Bip01_R_Hand", rel = "t4_shot_part+", pos = Vector(0, 5, 2), angle = Angle(0, 0, 90), size = Vector(0.054, 0.054, 0.07), color = Color(50, 50, 50, 255), surpresslightning = false, material = "models/props_canal/canal_bridge_railing_01c", skin = 0, bodygroup = {} },
		["t4_shot_part+"] = { type = "Model", model = Model("models/props_combine/combine_train02a.mdl"), bone = "ValveBiped.Bip01_R_Hand", rel = "t4_shot_part", pos = Vector(-3.636, 0, 0.699), angle = Angle(0, 90, 180), size = Vector(0.013, 0.024, 0.009), color = Color(50, 50, 50, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
		["t4_shot_part"] = { type = "Model", model = Model("models/weapons/w_pistol.mdl"), bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 1, -4.5), angle = Angle(0, 180, 180), size = Vector(0.8, 0.8, 1.21), color = Color(50, 50, 50, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} }
	}

	SWEP.ViewModelBoneMods = {
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 21) }
	}
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "shotgun"

SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false
SWEP.ViewModel = "models/weapons/cstrike/c_rif_galil.mdl"
SWEP.WorldModel = "models/weapons/w_rif_galil.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("weapons/xm1014/xm1014-1.wav")
SWEP.ReloadSound = Sound("Weapon_Deagle.Clipout")
SWEP.Primary.Damage = 10.5
SWEP.Primary.NumShots = 8
SWEP.Primary.Delay = 0.31

SWEP.Primary.ClipSize = 12
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "buckshot"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 9
SWEP.ConeMin = 6.5

SWEP.ReloadSpeed = 0.65

SWEP.WalkSpeed = SPEED_SLOWEST

SWEP.Tier = 4
SWEP.MaxStock = 3

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -1.125)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.81)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, "'Anvil' Drum Shotgun", "Uses 3 shells at once, slightly more damage, reduced accuracy", function(wept)
	wept.Primary.NumShots = wept.Primary.NumShots * 3
	wept.Primary.Delay = wept.Primary.Delay * 3.3
	wept.Primary.Damage = wept.Primary.Damage * 1.1
	wept.RequiredClip = 3
	wept.Recoil = 10

	wept.ConeMin = wept.ConeMin * 1.4
	wept.ConeMax = wept.ConeMax * 1.2

	wept.EmitFireSound = function(self)
		self:EmitSound(self.Primary.Sound, 75, math.random(87, 89), 0.75)
		self:EmitSound("weapons/shotgun/shotgun_fire6.wav", 75, math.random(102, 108), 0.65, CHAN_WEAPON + 20)
	end
end)

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound, 75, math.random(147, 153), 0.7)
	self:EmitSound("weapons/shotgun/shotgun_fire6.wav", 75, math.random(132, 138), 0.6, CHAN_WEAPON + 20)
end

function SWEP:SecondaryAttack()
end
