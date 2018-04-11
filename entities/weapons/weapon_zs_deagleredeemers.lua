AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = translate.Get("craft_deagleredeemers")
	SWEP.Description = translate.Get("deagle_desk") --SWEP.Description = "This high-powered handgun has the ability to pierce through multiple zombies. The bullet's power decreases by half which each zombie it hits."
	SWEP.Slot = 1
	SWEP.SlotPos = 0
SWEP.VElements = {
	["element_name+"] = { type = "Model", model = "models/weapons/cstrike/c_pist_deagle.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-24.435, 8.284, -5.89), angle = Angle(-2.395, -1.685, 177.832), size = Vector(1.205, 1.205, 1.205), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["element_name"] = { type = "Model", model = "models/weapons/cstrike/c_pist_deagle.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(-24.066, -6.108, 7.959), angle = Angle(0, 0.13, -1.078), size = Vector(1.205, 1.205, 1.205), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["element_name"] = { type = "Model", model = "models/weapons/w_pist_deagle.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(3.875, 1.69, -1.068), angle = Angle(0, -1.17, -1.17), size = Vector(0.69, 0.69, 0.69), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "v_weapon.Deagle_Slide"
	SWEP.HUD3DPos = Vector(-1, 0, 1)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.015

	SWEP.IronSightsPos = Vector(-6.35, 5, 1.7)
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "duel"

SWEP.ViewModel = "models/weapons/cstrike/c_pist_elite.mdl"
SWEP.WorldModel = "models/weapons/w_pist_deagle.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("Weapon_Deagle.Single")
SWEP.Primary.Damage = 47
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.2
SWEP.Primary.KnockbackScale = 3

SWEP.Primary.ClipSize = 14
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "pistol"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 0.055SWEP.ConeMin = 0.05

