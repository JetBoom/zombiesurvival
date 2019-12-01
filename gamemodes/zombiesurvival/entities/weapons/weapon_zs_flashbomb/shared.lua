SWEP.PrintName = ""..translate.Get"other_flashb_name"
SWEP.Description = ""..translate.Get"other_flashb_desc"

SWEP.Base = "weapon_zs_basethrown"

SWEP.ViewModel = "models/weapons/cstrike/c_eq_flashbang.mdl"
SWEP.WorldModel = "models/weapons/w_eq_flashbang.mdl"

SWEP.Primary.Ammo = "flashbomb"
SWEP.Primary.Sound = Sound("weapons/pinpull.wav")

SWEP.MaxStock = 12

function SWEP:Precache()
	util.PrecacheSound("weapons/pinpull.wav")
end
