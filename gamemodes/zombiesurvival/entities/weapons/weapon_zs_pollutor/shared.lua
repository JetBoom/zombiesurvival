SWEP.PrintName = "'Pollutor' Acid Rifle"
SWEP.Description = "Launches acidic projectiles that have a chance to remove damage resistance"

SWEP.Base = "weapon_zs_baseproj"

SWEP.HoldType = "smg"

SWEP.ViewModel = "models/weapons/cstrike/c_smg_ump45.mdl"
SWEP.WorldModel = "models/weapons/w_smg_ump45.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.Primary.ClipSize = 20
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "chemical"
SWEP.Primary.Delay = 0.45
SWEP.Primary.DefaultClip = 20
SWEP.Primary.Damage = 34
SWEP.Primary.NumShots = 1

SWEP.ConeMax = 3
SWEP.ConeMin = 2.5

SWEP.WalkSpeed = SPEED_SLOW

SWEP.Tier = 3
SWEP.MaxStock = 3

SWEP.FireAnimSpeed = 0.4

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.05)

local branch = GAMEMODE:AddNewRemantleBranch(SWEP, 1, "'Scorch' Napalm Rifle", "Chance to ignite instead of corrode at the cost of damage", function(wept)
	wept.Primary.Damage = wept.Primary.Damage * 0.86

	if SERVER then
		wept.EntModify = function(self, ent)
			ent:SetDTInt(5, 1)
		end
	else
		wept.VElements["bio++++++++++"].color = Color(230, 150, 100)
		wept.VElements["bio++++++"].color = Color(230, 150, 100)
		wept.WElements["bio++++++++++"].color = Color(230, 150, 100)
		wept.WElements["bio++++++"].color = Color(230, 150, 100)
	end
end)
branch.Colors = {Color(255, 160, 50), Color(215, 120, 50), Color(175, 100, 40)}
branch.NewNames = {"Hot", "Searing", "Torching"}

branch = GAMEMODE:AddNewRemantleBranch(SWEP, 2, "'Glaze' Cryo Rifle", "Launches cryoblobs that slow zombies down at the cost of damage", function(wept)
	wept.Primary.Damage = wept.Primary.Damage * 0.77

	if SERVER then
		wept.EntModify = function(self, ent)
			ent:SetDTInt(5, 2)
		end
	else
		wept.VElements["bio++++++++++"].color = Color(100, 190, 230)
		wept.VElements["bio++++++"].color = Color(100, 190, 230)
		wept.WElements["bio++++++++++"].color = Color(100, 190, 230)
		wept.WElements["bio++++++"].color = Color(100, 190, 230)
	end
end)
branch.Colors = {Color(50, 160, 255), Color(50, 130, 215), Color(40, 115, 175)}
branch.NewNames = {"Cold", "Arctic", "Glacial"}

function SWEP:EmitFireSound()
	self:EmitSound("^weapons/mortar/mortar_fire1.wav", 70, math.random(88, 92), 0.65)
	self:EmitSound("npc/barnacle/barnacle_gulp2.wav", 70, 70, 0.85, CHAN_AUTO + 20)
end
