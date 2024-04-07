SWEP.PrintName = "'Slinger' Bolt Pistol"
SWEP.Description = "A slow loading, inaccurate bolt pistol with no special properties."

SWEP.Base = "weapon_zs_baseproj"

SWEP.HoldType = "revolver"

SWEP.ViewModel = "models/weapons/cstrike/c_pist_p228.mdl"
SWEP.WorldModel = "models/weapons/w_pist_p228.mdl"
SWEP.UseHands = true

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
SWEP.ViewModelBoneMods = {}

SWEP.CSMuzzleFlashes = false

SWEP.Primary.Sound = Sound("Weapon_Crossbow.Single")
SWEP.Primary.Delay = 1
SWEP.Primary.Automatic = true
SWEP.Primary.Damage = 59

SWEP.Primary.ClipSize = 1
SWEP.Primary.Ammo = "XBowBolt"
SWEP.Primary.ClipMultiplier = 2
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 2.5
SWEP.ConeMin = 1.2

SWEP.NextZoom = 0

SWEP.ReloadSpeed = 0.59

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.07)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, "'Darter' Bolt Pistol", "Deals less damage but has much higher velocity", function(wept)
	wept.Primary.Damage = wept.Primary.Damage * 0.9
	wept.Primary.ProjVelocity = 2300
	if SERVER then
		wept.EntModify = function(self, ent)
			ent:SetDTBool(0, true)
		end
	end
end)
local branch = GAMEMODE:AddNewRemantleBranch(SWEP, 2, "'Hurler' Bolt Pistol", "Greater maximum accuracy, less damage at close range and more damage from afar", function(wept)
	wept.Primary.Damage = wept.Primary.Damage * 0.75
	wept.ConeMin = 0.3
	if SERVER then
		wept.EntModify = function(self, ent)
			ent:SetDTBool(1, true)
		end
	end
end)
branch.Colors = {Color(255, 160, 150), Color(215, 120, 150), Color(175, 100, 140)}
branch.NewNames = {"Range", "Seeker", "Searcher"}

function SWEP:SendReloadAnimation()
	self:SendWeaponAnim(ACT_VM_DRAW)
end

function SWEP:EmitReloadFinishSound()
	if IsFirstTimePredicted() then
		self:EmitSound("weapons/galil/galil_boltpull.wav", 70, 190)
	end
end

function SWEP:EmitReloadSound()
	if IsFirstTimePredicted() then
		self:EmitSound("weapons/g3sg1/g3sg1_clipout.wav", 70, 135, 0.9, CHAN_AUTO)
	end
end

function SWEP:EmitFireSound()
	self:EmitSound("weapons/crossbow/fire1.wav", 70, 230, 0.9, CHAN_WEAPON)
end

util.PrecacheSound("weapons/crossbow/bolt_load1.wav")
util.PrecacheSound("weapons/crossbow/bolt_load2.wav")
