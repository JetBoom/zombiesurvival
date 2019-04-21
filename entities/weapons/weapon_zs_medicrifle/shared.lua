SWEP.PrintName = "'Convalescence' Medical Rifle"
SWEP.Description = "Fires fast-moving medical darts which can heal at a range. Darts can also inflict damage to zombies as well as reduce their damage output."
SWEP.Slot = 4
SWEP.SlotPos = 0

SWEP.Base = "weapon_zs_baseproj"
DEFINE_BASECLASS("weapon_zs_baseproj")

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/cstrike/c_snip_scout.mdl"
SWEP.WorldModel = "models/weapons/w_snip_scout.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.ReloadSound = Sound("Weapon_Pistol.Reload")

SWEP.Primary.Delay = 0.85
SWEP.Primary.ClipSize = 64
SWEP.Primary.DefaultClip = 120
SWEP.Primary.Ammo = "Battery"

SWEP.RequiredClip = 8
SWEP.Primary.Damage = 75
SWEP.ReloadSpeed = 1

SWEP.WalkSpeed = SPEED_SLOW

SWEP.ConeMax = 0
SWEP.ConeMin = 0

SWEP.FireAnimSpeed = 1.4

SWEP.BuffDuration = 10

SWEP.Tier = 2

SWEP.AllowQualityWeapons = true

SWEP.Heal = 10

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_BUFF_DURATION, 3)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_HEALING, 1.1)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, "'Invigorator' Strength Rifle", "Strength boost instead of defence, and makes zombies more vulnerable to damage instead", function(wept)
	if SERVER then
		wept.EntModify = function(self, ent)
			local owner = self:GetOwner()

			ent:SetDTBool(0, true)
			ent:SetSeeked(self:GetSeekedPlayer() or nil)
			ent.Heal = wept.Heal * (owner.MedDartEffMul or 1)
			ent.BuffDuration = wept.BuffDuration
		end
	else
		for k,v in pairs(wept.VElements) do
			v.color = Color(215, 100, 75, 255)
		end
	end
end)

function SWEP:EmitFireSound()
	self:EmitSound("weapons/ar2/npc_ar2_altfire.wav", 70, math.random(137, 143), 0.85)
	self:EmitSound("weapons/ar2/fire1.wav", 70, math.random(105, 115), 0.85, CHAN_WEAPON + 20)
	self:EmitSound("items/smallmedkit1.wav", 70, math.random(165, 170), 0.65, CHAN_WEAPON + 21)
end

function SWEP:GetFireDelay()
	local owner = self:GetOwner()
	return (self.Primary.Delay * (owner.MedgunFireDelayMul or 1)) / (owner:GetStatus("frost") and 0.7 or 1)
end

function SWEP:GetReloadSpeedMultiplier()
	local owner = self:GetOwner()
	return BaseClass.GetReloadSpeedMultiplier(self) * (owner.MedgunReloadSpeedMul or 1) -- Convention is now BaseClass instead of self.BaseClass
end

function SWEP:CanSecondaryAttack()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() or self:GetReloadFinish() > 0 then return false end

	return self:GetNextSecondaryFire() <= CurTime()
end

function SWEP:SecondaryAttack()
	if not self:CanSecondaryAttack() then return end

	self:SetNextSecondaryFire(CurTime() + 0.1)

	local owner = self:GetOwner()
	if not owner:IsSkillActive(SKILL_SMARTTARGETING) then return end

	local targetent = owner:CompensatedMeleeTrace(2048, 2, nil, nil, true).Entity
	local locked = targetent and targetent:IsValidLivingHuman() and gamemode.Call("PlayerCanBeHealed", targetent)

	if CLIENT then
		self:EmitSound(locked and "npc/scanner/combat_scan4.wav" or "npc/scanner/scanner_scan5.wav", 65, locked and 75 or 200)
	end
	self:SetSeekedPlayer(locked and targetent)
end

function SWEP:SetSeekedPlayer(ent)
	self:SetDTEntity(6, ent)
end

function SWEP:GetSeekedPlayer()
	return self:GetDTEntity(6)
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
