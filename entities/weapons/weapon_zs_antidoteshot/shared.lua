SWEP.PrintName = "'Purger' Antidote Handgun"
SWEP.Description = "Fires piercing antidote blasts. Heals poison and cleanses statuses."
SWEP.Slot = 4
SWEP.SlotPos = 0

SWEP.Base = "weapon_zs_baseproj"
DEFINE_BASECLASS("weapon_zs_baseproj")

SWEP.HoldType = "revolver"

SWEP.ViewModel = "models/weapons/cstrike/c_pist_deagle.mdl"
SWEP.WorldModel = "models/weapons/w_pist_deagle.mdl"
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false

SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.ReloadSound = Sound("Weapon_Pistol.Reload")

SWEP.Primary.Delay = 0.4

SWEP.Primary.ClipSize = 21
SWEP.Primary.DefaultClip = 150
SWEP.Primary.Ammo = "Battery"
SWEP.RequiredClip = 3

SWEP.WalkSpeed = SPEED_NORMAL

SWEP.ConeMax = 0
SWEP.ConeMin = 0

SWEP.ReloadSpeed = 0.43
SWEP.FireAnimSpeed = 1.3

SWEP.IronSightsPos = Vector(-5.95, 3, 2.75)
SWEP.IronSightsAng = Vector(-0.15, -1, 2)

SWEP.AllowQualityWeapons = true

GAMEMODE:SetPrimaryWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 5)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_PROJECTILE_VELOCITY, 50)

function SWEP:EmitFireSound()
	self:EmitSound("items/smallmedkit1.wav", 70, math.random(135, 140), 0.65, CHAN_WEAPON + 21)
	self:EmitSound("weapons/galil/galil-1.wav", 75, math.random(122, 128), 0.7, CHAN_WEAPON + 20)
end

function SWEP:EmitReloadSound()
	if IsFirstTimePredicted() then
		self:EmitSound("weapons/357/357_reload1.wav", 75, 75, 1, CHAN_WEAPON + 21)
	end
end

function SWEP:EmitReloadFinishSound()
	if IsFirstTimePredicted() then
		self:EmitSound("weapons/357/357_spin1.wav", 70, 90)
	end
end

function SWEP:SendReloadAnimation()
	self:SendWeaponAnim(ACT_VM_DRAW)
end

function SWEP:Deploy()
	if CLIENT then
		hook.Add("PostPlayerDraw", "PostPlayerDrawMedical", GAMEMODE.PostPlayerDrawMedical)
		GAMEMODE.MedicalAura = true
	end

	return BaseClass.Deploy(self)
end

function SWEP:Holster()
	if CLIENT and self:GetOwner() == MySelf then
		hook.Remove("PostPlayerDraw", "PostPlayerDrawMedical")
		GAMEMODE.MedicalAura = false
	end

	return true
end

function SWEP:OnRemove()
	if CLIENT and self:GetOwner() == MySelf then
		hook.Remove("PostPlayerDraw", "PostPlayerDrawMedical")
		GAMEMODE.MedicalAura = false
	end
end
