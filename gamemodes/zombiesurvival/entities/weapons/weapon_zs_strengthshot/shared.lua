SWEP.PrintName = "Strength Shot Gun"
SWEP.Description = "Fires performance enhancing darts which can increase target damage.\nThe extra damage is given to you as points."
SWEP.Slot = 4
SWEP.SlotPos = 0

SWEP.Base = "weapon_zs_baseproj"
DEFINE_BASECLASS("weapon_zs_baseproj")

SWEP.HoldType = "pistol"

SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.ReloadSound = Sound("Weapon_Pistol.Reload")

SWEP.Primary.Delay = 0.25

SWEP.Primary.ClipSize = 25
SWEP.Primary.DefaultClip = 150
SWEP.Primary.Ammo = "Battery"
SWEP.RequiredClip = 5

SWEP.WalkSpeed = SPEED_NORMAL

SWEP.ConeMax = 0
SWEP.ConeMin = 0

SWEP.ReloadSpeed = 0.85

SWEP.BuffDuration = 10

SWEP.IronSightsPos = Vector(-5.95, 3, 2.75)
SWEP.IronSightsAng = Vector(-0.15, -1, 2)

SWEP.AllowQualityWeapons = true

GAMEMODE:SetPrimaryWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 5)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_BUFF_DURATION, 2)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, "Defence Shot Gun", "Provides players with a defence boost instead of a strength boost", function(wept)
	if SERVER then
		wept.EntModify = function(self, ent)
			ent:SetDTBool(0, true)
			ent:SetSeeked(self:GetSeekedPlayer() or nil)
			ent.BuffDuration = wept.BuffDuration
		end
	else
		for k,v in pairs(wept.VElements) do
			v.color = Color(100, 120, 215, 255)
		end
	end
end)

function SWEP:GetFireDelay()
	local owner = self:GetOwner()
	return (self.Primary.Delay * (owner.MedgunFireDelayMul or 1)) / (owner:GetStatus("frost") and 0.7 or 1)
end

function SWEP:GetReloadSpeedMultiplier()
	local owner = self:GetOwner()
	return BaseClass.GetReloadSpeedMultiplier(self) * (owner.MedgunReloadSpeedMul or 1) -- Convention is now BaseClass instead of self.BaseClass
end

function SWEP:SetSeekedPlayer(ent)
	self:SetDTEntity(6, ent)
end

function SWEP:GetSeekedPlayer()
	return self:GetDTEntity(6)
end

function SWEP:SecondaryAttack()
	if not self:CanPrimaryAttack() then return end

	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay()/2)

	local owner = self:GetOwner()
	if not owner:IsSkillActive(SKILL_SMARTTARGETING) then return end

	local targetent = owner:CompensatedMeleeTrace(2048, 2, nil, nil, true).Entity
	local locked = targetent and targetent:IsValidLivingHuman()

	if CLIENT then
		self:EmitSound(locked and "npc/scanner/combat_scan4.wav" or "npc/scanner/scanner_scan5.wav", 65, locked and 75 or 200)
	end
	self:SetSeekedPlayer(locked and targetent)
end
