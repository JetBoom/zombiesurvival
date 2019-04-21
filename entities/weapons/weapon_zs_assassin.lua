AddCSLuaFile()

SWEP.PrintName = "'assassin' silent pistol"
SWEP.Description = "Shrouds your aura is silent fireing deals high dmg  ."

SWEP.Slot = 1
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DPos = Vector(-0.95, 0, 1)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DBone = "v_weapon.USP_Slide"
	SWEP.IronSightsPos = Vector(-2.8, 3, 2.44)
    SWEP.IronSightsAng = Vector(0, 0, 0)

	
	
end


SWEP.VElements = {
	["Mainbody+++++++"] = { type = "Model", model = "models/props_pipes/pipe02_connector01.mdl", bone = "v_weapon.FIVESEVEN_SLIDE", rel = "", pos = Vector(0, -1.558, 0), angle = Angle(0, -90, 0), size = Vector(0.076, 0.076, 0.076), color = Color(150, 150, 150, 255), surpresslightning = false, material = "models/props_junk/metalbucket01a", skin = 0, bodygroup = {} },
	["Mainbody2"] = { type = "Model", model = "models/props_c17/utilityconnecter005.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "", pos = Vector(-36.883, -3.136, -2.597), angle = Angle(0, 0, 90), size = Vector(0.172, 0.237, 0.172), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/pipesystem01a_skin2", skin = 0, bodygroup = {} },
	["Mainbody2+"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "", pos = Vector(-0.551, -3.1, -2), angle = Angle(0, 0, 90), size = Vector(0.039, 0.237, 0.019), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_junk/fruit_objects01", skin = 0, bodygroup = {} },
	["Mainbody1"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "", pos = Vector(0, -3, -5.715), angle = Angle(0, 0, 0), size = Vector(0.057, 0.057, 0.057), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
	["Barrel+"] = { type = "Model", model = "models/props_pipes/concrete_pipe001a.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "", pos = Vector(0, -3.136, -11.948), angle = Angle(90, 0, 0), size = Vector(0.068, 0.009, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/pipesystem01a_skin2", skin = 0, bodygroup = {} },
	["Trigger"] = { type = "Model", model = "models/gibs/metal_gib5.mdl", bone = "v_weapon.FIVESEVEN_TRIGGER", rel = "", pos = Vector(0, 0.518, -0.801), angle = Angle(-68.961, 90, 90), size = Vector(0.301, 0.301, 0.301), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_junk/i-beam_cluster01", skin = 0, bodygroup = {} },
	["Mainbody+++++++++"] = { type = "Model", model = "models/props_pipes/pipe02_connector01.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "", pos = Vector(0, -3.08, -0.25), angle = Angle(90, 0, 0), size = Vector(0.046, 0.046, 0.046), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_junk/fruit_objects01", skin = 0, bodygroup = {} },
	["Aim"] = { type = "Model", model = "models/gibs/metal_gib2.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "", pos = Vector(0, -3.737, -1.958), angle = Angle(0, 0, -90), size = Vector(0.432, 0.172, 0.497), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/pipesystem01a_skin2", skin = 0, bodygroup = {} },
	["Mainbody++++++++++++++"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "", pos = Vector(0.004, -2.997, -3.27), angle = Angle(0, 0, 0), size = Vector(0.14, 0.041, 0.041), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/pipesystem01a_skin2", skin = 0, bodygroup = {} },
	["Slide"] = { type = "Model", model = "models/gibs/metal_gib1.mdl", bone = "v_weapon.FIVESEVEN_SLIDE", rel = "", pos = Vector(-1.558, 1.457, 0.15), angle = Angle(-5.844, -92.338, 0), size = Vector(0.107, 0.237, 0.107), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/destroyedpipes01a", skin = 0, bodygroup = {} },
	["Mainbody++++++++"] = { type = "Model", model = "models/props_pipes/pipe02_connector01.mdl", bone = "v_weapon.FIVESEVEN_SLIDE", rel = "", pos = Vector(0, -0.12, 0), angle = Angle(0, -90, -127.403), size = Vector(1.615, 0.037, 0.037), color = Color(150, 150, 150, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
	["Mainbody++++++++++++"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "", pos = Vector(0, -2.8, -2), angle = Angle(0, 0, 0), size = Vector(0.14, 0.041, 0.256), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/pipesystem01a_skin2", skin = 0, bodygroup = {} },
	["Silencer+"] = { type = "Model", model = "models/props_junk/popcan01a.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "", pos = Vector(-0.051, -3, -16.8), angle = Angle(0, 45.583, 0), size = Vector(0.514, 0.514, 0.172), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_c17/awning001d", skin = 0, bodygroup = {} },
	["Mag"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "v_weapon.FIVESEVEN_CLIP", rel = "", pos = Vector(0, 0.919, -0.06), angle = Angle(0, 0, -17.532), size = Vector(0.041, 0.301, 0.172), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
	["Handle1"] = { type = "Model", model = "models/props_c17/handrail04_short.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "", pos = Vector(0.28, -0.301, -1.859), angle = Angle(0, 0, 73.636), size = Vector(0.067, 0.067, 0.086), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Mainbody+++++++++++++++"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "", pos = Vector(0.004, -2.997, -0.681), angle = Angle(0, 0, 0), size = Vector(0.14, 0.041, 0.032), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/pipesystem01a_skin2", skin = 0, bodygroup = {} },
	["Aim+"] = { type = "Model", model = "models/hunter/plates/plate.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "", pos = Vector(0.037, -3.636, -4.676), angle = Angle(-92.338, 0, -180), size = Vector(0.021, 0.347, 0.021), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/pipesystem01a_skin2", skin = 0, bodygroup = {} },
	["Mainbody++++++"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "", pos = Vector(0, -2.3, -10.91), angle = Angle(0, 0, 0), size = Vector(0.127, 0.092, 0.291), color = Color(255, 231, 231, 255), surpresslightning = false, material = "models/props_docks/dock01a", skin = 0, bodygroup = {} },
	["Silencer"] = { type = "Model", model = "models/props_junk/popcan01a.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "", pos = Vector(-0.051, -3, -16.8), angle = Angle(0, 45.583, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Mainbody"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "", pos = Vector(0, -2.3, -4.676), angle = Angle(0, 0, 0), size = Vector(0.127, 0.092, 0.69), color = Color(255, 231, 231, 255), surpresslightning = false, material = "models/props_docks/dock01a", skin = 0, bodygroup = {} },
	["Handle1+"] = { type = "Model", model = "models/props_c17/handrail04_short.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "", pos = Vector(-0.281, -0.301, -1.859), angle = Angle(0, 0, 73.636), size = Vector(0.067, 0.067, 0.086), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Mainbody+++++++++++"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "", pos = Vector(0, -2.25, -8.832), angle = Angle(0, 0, 0), size = Vector(0.14, 0.109, 0.23), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/pipesystem01a_skin2", skin = 0, bodygroup = {} },
	["Mainbody+++"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "", pos = Vector(-0.02, -2.198, -1.558), angle = Angle(0, 0, 0), size = Vector(0.129, 0.09, 0.129), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/pipesystem01a_skin2", skin = 0, bodygroup = {} },
	["Mainbody+++++"] = { type = "Model", model = "models/props_pipes/pipe02_connector01.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "", pos = Vector(0, -3.1, -0.32), angle = Angle(90, 0, 0), size = Vector(0.107, 0.107, 0.107), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_junk/i-beam_cluster01", skin = 0, bodygroup = {} },
	["Mainbody+"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "", pos = Vector(0.439, -3.411, -4.676), angle = Angle(0, 0, 0), size = Vector(0.052, 0.052, 0.69), color = Color(255, 231, 231, 255), surpresslightning = false, material = "models/props_docks/dock01a", skin = 0, bodygroup = {} },
	["Mainbody++++++++++"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "", pos = Vector(0.238, -3.391, -4.676), angle = Angle(0, 0, 0), size = Vector(0.052, 0.052, 0.69), color = Color(255, 231, 231, 255), surpresslightning = false, material = "models/props_docks/dock01a", skin = 0, bodygroup = {} },
	["Barrel"] = { type = "Model", model = "models/props_pipes/concrete_pipe001a.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "", pos = Vector(0, -3.136, -6.753), angle = Angle(90, 0, 0), size = Vector(0.071, 0.012, 0.012), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/pipesystem01a_skin2", skin = 0, bodygroup = {} },
	["Mainbody++++"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "", pos = Vector(0, -3.1, -1), angle = Angle(0, 0, 0), size = Vector(0.119, 0.039, 0.119), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
	["Mainbody+++++++++++++"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "", pos = Vector(0, -3.481, -2), angle = Angle(0, 0, 0), size = Vector(0.14, 0.041, 0.256), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/pipesystem01a_skin2", skin = 0, bodygroup = {} },
	["Silencer++"] = { type = "Model", model = "models/props_junk/popcan01a.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "", pos = Vector(-0.051, -3, -17.143), angle = Angle(0, 47.922, 40.909), size = Vector(0.514, 0.514, 0.172), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_c17/awning001b", skin = 0, bodygroup = {} },
	["Silencer+++"] = { type = "Model", model = "models/props_junk/popcan01a.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "", pos = Vector(-0.051, -3.136, -14.027), angle = Angle(0, 47.922, 0), size = Vector(0.287, 0.287, 0.287), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_c17/awning001b", skin = 0, bodygroup = {} }
}
SWEP.WElements = {
	["Mainbody+++++++"] = { type = "Model", model = "models/props_pipes/pipe02_connector01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0.518, 1.557, -2.898), angle = Angle(-3.507, 0, 0), size = Vector(0.076, 0.076, 0.076), color = Color(150, 150, 150, 255), surpresslightning = false, material = "models/props_junk/metalbucket01a", skin = 0, bodygroup = {} },
	["Handle1+"] = { type = "Model", model = "models/props_c17/handrail04_short.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.635, 1.157, -0.519), angle = Angle(0, -90, 0), size = Vector(0.067, 0.046, 0.107), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Mainbody1"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6, 1.657, -3.636), angle = Angle(174.156, -90, 97.013), size = Vector(0.057, 0.057, 0.057), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
	["Barrel+"] = { type = "Model", model = "models/props_pipes/concrete_pipe001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(9.869, 1.557, -4.276), angle = Angle(-5.844, 0, 0), size = Vector(0.068, 0.009, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/pipesystem01a_skin2", skin = 0, bodygroup = {} },
	["Mainbody2+"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.596, 2.397, -3.336), angle = Angle(-97.014, 0, 90), size = Vector(0.039, 0.162, 0.019), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_junk/fruit_objects01", skin = 0, bodygroup = {} },
	["Mainbody"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.714, 1.557, -2.997), angle = Angle(0, 90, -82.987), size = Vector(0.127, 0.092, 0.69), color = Color(255, 231, 231, 255), surpresslightning = false, material = "models/props_docks/dock01a", skin = 0, bodygroup = {} },
	["Aim"] = { type = "Model", model = "models/gibs/metal_gib2.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.596, 1.557, -3.937), angle = Angle(180, -90, 8.182), size = Vector(0.432, 0.107, 0.497), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/pipesystem01a_skin2", skin = 0, bodygroup = {} },
	["Slide"] = { type = "Model", model = "models/gibs/metal_gib1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.596, 3, -3.237), angle = Angle(0, 0, 0), size = Vector(0.107, 0.237, 0.107), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/destroyedpipes01a", skin = 0, bodygroup = {} },
	["Mainbody++++++++"] = { type = "Model", model = "models/props_pipes/pipe02_connector01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1.957, 1.557, -2.997), angle = Angle(-5.844, 0, 0), size = Vector(1.615, 0.037, 0.037), color = Color(150, 150, 150, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
	["Handle1++"] = { type = "Model", model = "models/props_c17/handrail04_short.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.635, 1.899, -0.519), angle = Angle(0, -90, 0), size = Vector(0.067, 0.046, 0.107), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Silencer"] = { type = "Model", model = "models/props_junk/popcan01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(15.064, 1.557, -4.676), angle = Angle(85.324, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Silencer+"] = { type = "Model", model = "models/props_junk/popcan01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(15.064, 1.557, -4.676), angle = Angle(85.324, 8.182, -8.183), size = Vector(0.514, 0.514, 0.237), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_c17/awning001b", skin = 0, bodygroup = {} },
	["Mag"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.635, 1.557, -0.519), angle = Angle(0, -90, -90), size = Vector(0.041, 0.301, 0.151), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
	["Trigger"] = { type = "Model", model = "models/gibs/metal_gib5.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.714, 1.557, -1.558), angle = Angle(-22.209, 0, -90), size = Vector(0.301, 0.301, 0.301), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_junk/i-beam_cluster01", skin = 0, bodygroup = {} },
	["Mainbody++++++++++"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.613, 1.1, -3.636), angle = Angle(82.986, 0, 0), size = Vector(0.052, 0.052, 0.69), color = Color(255, 231, 231, 255), surpresslightning = false, material = "models/props_docks/dock01a", skin = 0, bodygroup = {} },
	["Barrel"] = { type = "Model", model = "models/props_pipes/concrete_pipe001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7.791, 1.557, -4.075), angle = Angle(-5.844, 0, 0), size = Vector(0.071, 0.012, 0.012), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/pipesystem01a_skin2", skin = 0, bodygroup = {} },
	["Mainbody++++"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1.758, 1.557, -3.237), angle = Angle(-3.507, 0, 90), size = Vector(0.119, 0.039, 0.119), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/valve001_skin2", skin = 0, bodygroup = {} },
	["Mainbody+++++++++++++"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.596, 1.557, -3.237), angle = Angle(82.986, 0, 0), size = Vector(0.109, 0.14, 0.219), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/pipesystem01a_skin2", skin = 0, bodygroup = {} },
	["Silencer++"] = { type = "Model", model = "models/props_junk/popcan01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(14.664, 1.557, -4.636), angle = Angle(85.324, 0, 0), size = Vector(0.509, 0.509, 0.237), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_c17/awning001c", skin = 0, bodygroup = {} },
	["Silencer+++"] = { type = "Model", model = "models/props_junk/popcan01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(12.987, 1.557, -4.475), angle = Angle(85.324, 0, 0), size = Vector(0.31, 0.31, 0.31), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_c17/awning001b", skin = 0, bodygroup = {} }
}

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "pistol"

SWEP.ViewModel = "models/weapons/cstrike/c_pist_fiveseven.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.UseHands = true



SWEP.Primary.Sound = Sound( "weapons/usp/usp1.wav" )
SWEP.Primary.Damage = 45
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.15

SWEP.Primary.ClipSize = 12
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ReloadSpeed = 0.87
SWEP.FireAnimSpeed = 2


SWEP.ConeMax = 6.5
SWEP.ConeMin = 3.6

SWEP.WalkSpeed = SPEED_FAST

SWEP.Tier = 3




GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.8125)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.45)

function SWEP:GetAuraRange()
	return 512
end


if CLIENT then
SWEP.WepSelectIcon = surface.GetTextureID( "csgo/econ/weapons/base_weapons/weapon_usp_silencer" )
SWEP.DrawWeaponInfoBox	= false
SWEP.BounceWeaponIcon = false
killicon.Add( "weapon_csgo_usp_silencer", "csgo/econ/weapons/base_weapons/weapon_usp_silencer", Color( 255, 255, 255, 255 ) )
end