AddCSLuaFile()
     
    if CLIENT then
            SWEP.PrintName = translate.Get("weapon_python")
            SWEP.Author     = ""
            SWEP.ViewModelFlip = false
			SWEP.ViewModelFOV = 60
	 
    SWEP.ViewModelBoneMods = {
            ["Bullet4"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
            ["Bullet3"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
            ["Bullet6"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
            ["Bullet5"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
    }
           
    SWEP.VElements = {
            ["bullet3"] = { type = "Model", model = "models/props_c17/streetsign004e.mdl", bone = "Cylinder_release", rel = "", pos = Vector(0, -0.801, -3), angle = Angle(180, 180, 90), size = Vector(0.029, 0.029, 0.029), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
            ["handle"] = { type = "Model", model = "models/props_junk/sawblade001a.mdl", bone = "Python", rel = "", pos = Vector(0.449, 0.6, -2.401), angle = Angle(90, 180, 180), size = Vector(0.037, 0.037, 0.059), color = Color(0, 0, 0, 255), surpresslightning = false, material = "models/xqm/cellshadedcamo_diffuse", skin = 0, bodygroup = {} },
            ["bullet3++"] = { type = "Model", model = "models/props_c17/streetsign004e.mdl", bone = "Cylinder_release", rel = "", pos = Vector(-0.561, -1.8, -3), angle = Angle(180, 180, 90), size = Vector(0.029, 0.029, 0.029), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
            ["handle++"] = { type = "Model", model = "models/Gibs/wood_gib01d.mdl", bone = "Python", rel = "", pos = Vector(0.479, 0.699, -2.6), angle = Angle(-12, 90, 99.35), size = Vector(0.029, 0.029, 0.029), color = Color(255, 25, 25, 255), surpresslightning = false, material = "models/xqm/squaredmat", skin = 0, bodygroup = {} },
            ["cylinder+++"] = { type = "Model", model = "models/Gibs/HGIBS.mdl", bone = "Bullet1", rel = "", pos = Vector(0, 0, 0.1), angle = Angle(-90, -180, 90), size = Vector(0.059, 0.09, 0.09), color = Color(238, 255, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
            ["handle+"] = { type = "Model", model = "models/Gibs/wood_gib01d.mdl", bone = "Python", rel = "", pos = Vector(0.479, 0.699, -2.201), angle = Angle(10.519, 90, 0), size = Vector(0.029, 0.029, 0.029), color = Color(255, 25, 25, 255), surpresslightning = false, material = "models/xqm/squaredmat", skin = 0, bodygroup = {} },
            ["cylinder+++++"] = { type = "Model", model = "models/Gibs/HGIBS.mdl", bone = "Bullet2", rel = "", pos = Vector(0, 0, 0.1), angle = Angle(-90, -180, 90), size = Vector(0.059, 0.09, 0.09), color = Color(226, 206, 92, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
            ["cylinder"] = { type = "Model", model = "models/XQM/deg360single.mdl", bone = "Cylinder_release", rel = "", pos = Vector(0, -1.425, -0.5), angle = Angle(90, 120, 0), size = Vector(0.1, 0.041, 0.041), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/xqm/cellshadedcamo_diffuse", skin = 0, bodygroup = {} },
            ["cylinder++"] = { type = "Model", model = "models/XQM/deg360single.mdl", bone = "Bullet1", rel = "", pos = Vector(0, 0, 1.399), angle = Angle(90, -90, 0), size = Vector(0.059, 0.013, 0.013), color = Color(255, 255, 54, 255), surpresslightning = false, material = "models/xqm/2deg360_diffuse", skin = 0, bodygroup = {} },
            ["tube"] = { type = "Model", model = "models/XQM/cylinderx1huge.mdl", bone = "Python", rel = "", pos = Vector(0, -0.63, 6), angle = Angle(90, 120, 0), size = Vector(0.2, 0.025, 0.025), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/xqm/deg360", skin = 0, bodygroup = {} },
            ["bullet3+++"] = { type = "Model", model = "models/props_c17/streetsign004e.mdl", bone = "Cylinder_release", rel = "", pos = Vector(-0.561, -1.101, -3), angle = Angle(180, 180, 90), size = Vector(0.029, 0.029, 0.029), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
            ["cylinder++++"] = { type = "Model", model = "models/XQM/deg360single.mdl", bone = "Bullet2", rel = "", pos = Vector(0, 0, 1.399), angle = Angle(90, -90, 0), size = Vector(0.059, 0.013, 0.013), color = Color(255, 255, 54, 255), surpresslightning = false, material = "models/xqm/2deg360_diffuse", skin = 0, bodygroup = {} },
            ["bullet3+"] = { type = "Model", model = "models/props_c17/streetsign004e.mdl", bone = "Cylinder_release", rel = "", pos = Vector(0.6, -1.101, -3), angle = Angle(180, 180, 90), size = Vector(0.029, 0.029, 0.029), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
    }
     
    SWEP.WElements = {
            ["tube"] = { type = "Model", model = "models/XQM/cylinderx1huge.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "cylinder", pos = Vector(5, -0.201, -1), angle = Angle(-5, 1, 180), size = Vector(0.23, 0.025, 0.025), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/xqm/deg360", skin = 0, bodygroup = {} },
            ["tube+"] = { type = "Model", model = "models/XQM/cylinderx1huge.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "tube", pos = Vector(5.099, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.019, 0.021, 0.021), color = Color(0, 0, 0, 255), surpresslightning = false, material = "models/xqm/deg360", skin = 0, bodygroup = {} },
            ["scopeholder+"] = { type = "Model", model = "models/props_c17/lampShade001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "scope", pos = Vector(2, 0, 1), angle = Angle(0, 0, 0), size = Vector(0.1, 0.05, 0.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
            ["cylinder"] = { type = "Model", model = "models/XQM/deg360single.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7.9, 1, -3.701), angle = Angle(0, 0, 0), size = Vector(0.1, 0.05, 0.05), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/xqm/cellshadedcamo_diffuse", skin = 0, bodygroup = {} },
            ["scopeholder"] = { type = "Model", model = "models/props_c17/lampShade001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "scope", pos = Vector(-2, 0, 1), angle = Angle(0, 0, 0), size = Vector(0.1, 0.05, 0.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
    }
           -- killicon.AddFont( "weapon_zs_magnum", "HL2MPTypeDeath", ".",Color(255, 0, 0, 255 ) )
            SWEP.ViewModelFOV = 60
    end
     
SWEP.Base = "weapon_zs_base"
SWEP.Slot = 5
SWEP.SlotPos = 1
SWEP.Spawnable                  = true
SWEP.AdminSpawnable             = true
SWEP.ViewModel                  = Model ( "models/weapons/c_357.mdl" )
SWEP.UseHands = true
SWEP.WorldModel                 = Model ( "models/weapons/w_357.mdl" )
SWEP.AutoSwitchTo               = false
SWEP.AutoSwitchFrom             = false
SWEP.HoldType = "revolver"
SWEP.Primary.Sound                      = Sound( "weapons/python/python2.wav" )
SWEP.Primary.Recoil                     = 5
SWEP.Primary.Damage                     = 95
SWEP.Primary.NumShots           = 1
SWEP.Primary.ClipSize           = 2
SWEP.Primary.Delay                      = 0.5
SWEP.Primary.DefaultClip        = 28
SWEP.Primary.Automatic          = false
SWEP.Primary.Ammo                       = "pistol"
SWEP.MaxBulletDistance          = 2000
     
SWEP.ConeMax = 0.095
SWEP.ConeMin = 0.04

SWEP.IronSightsPos = Vector(-4.62, 4, 0.65)
SWEP.IronSightsAng = Vector(0, 0, 1)

