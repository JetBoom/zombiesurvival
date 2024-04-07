AddCSLuaFile()
 
SWEP.PrintName = translate.Get("craft_volcanoarm")
SWEP.Description = translate.Get("craft_volcanoarmdesk")
SWEP.Slot = 1
SWEP.SlotPos = 0
 
if CLIENT then
    SWEP.ViewModelFlip = false
    SWEP.ViewModelFOV = 60
 
    SWEP.HUD3DBone = "Python"
    SWEP.HUD3DPos = Vector(0.85, 0, -2.5)
    SWEP.HUD3DScale = 0.015
 
    SWEP.WElements = {
        ["base"] = { type = "Model", model = "models/props_pipes/pipe02_straight01_short.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(23, 1, -6.5), angle = Angle(0, -90, -5), size = Vector(0.2, 1, 0.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_357/357_sheet", skin = 0, bodygroup = {} },
        ["base+"] = { type = "Model", model = "models/props_lab/powerbox02c.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0, 9, 3), angle = Angle(90, 90, 0), size = Vector(0.5, 0.2, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_grenade/rim", skin = 0, bodygroup = {} }
    }
 
    SWEP.VElements = {
        ["base"] = { type = "Model", model = "models/props_pipes/pipe02_straight01_short.mdl", bone = "Python", rel = "", pos = Vector(0, -1.5, 16), angle = Angle(0, 0, 90), size = Vector(0.2, 1, 0.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_357/357_sheet", skin = 0, bodygroup = {} },
        ["base+"] = { type = "Model", model = "models/props_lab/powerbox02c.mdl", bone = "Python", rel = "base", pos = Vector(0, 9, 3), angle = Angle(90, 90, 0), size = Vector(0.5, 0.2, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_grenade/rim", skin = 0, bodygroup = {} }
    }
end
 
SWEP.Base = "weapon_zs_base"
 
SWEP.HoldType = "revolver"
 
SWEP.ViewModel = "models/weapons/c_357.mdl"
SWEP.WorldModel = "models/weapons/w_357.mdl"
SWEP.UseHands = true
 
SWEP.CSMuzzleFlashes = false
 
SWEP.Primary.Sound = Sound("weapons/zs_longarm/longarm_fire.ogg")
SWEP.Primary.Delay = 1
SWEP.Primary.Damage = 200
SWEP.Primary.NumShots = 1
 
--[[SWEP.Primary.ClipSize = 10
SWEP.RequiredClip = 2]]
SWEP.Primary.ClipSize = 5
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL
GAMEMODE:SetupDefaultClip(SWEP.Primary)
 
SWEP.WalkSpeed = SPEED_SLOW
 
SWEP.Recoil = 100
 
SWEP.ConeMax = .02
SWEP.ConeMin = .01
 
SWEP.Tier = 5
 
SWEP.IronSightsPos = Vector(-4.65, 4, 0.25)
SWEP.IronSightsAng = Vector(0, 0, 1)
 
--SWEP.TracerName = "rico_trace"

function SWEP.BulletCallback(attacker, tr, dmginfo)
	if not attacker:IsValid() or not attacker:IsPlayer() then return end

	local e = EffectData()
		e:SetOrigin(tr.HitPos)
		e:SetNormal(tr.HitNormal)
		e:SetRadius(200)
		e:SetMagnitude(10)
		e:SetScale(1)
	util.Effect("meteorexplosion", e)

	util.BlastDamage2(self, attacker, tr.HitPos, 500, 250)

	GenericBulletCallback(attacker, tr, dmginfo)
end