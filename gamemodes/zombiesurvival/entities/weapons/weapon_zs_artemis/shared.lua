SWEP.PrintName = "'Artemis' Dual Crossbows"
SWEP.Description = "A pair of miniature crossbows. Fires quick successions of explosive bolts."

SWEP.Slot = 3
SWEP.SlotPos = 0

SWEP.Base = "weapon_zs_baseproj"

sound.Add({
	name = "Weapon_Artemis_Reload.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	soundlevel = 100,
	pitch = {80, 85},
	sound = "weapons/crossbow/reload1.wav"
})

sound.Add({
	name = "Weapon_Artemis_Fire.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	soundlevel = 100,
	pitch = {150, 160},
	sound = "weapons/crossbow/fire1.wav"
})

sound.Add({
	name = "Weapon_Artemis_Empty.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	soundlevel = 100,
	pitch = {80, 85},
	sound = "weapons/ar2/ar2_empty.wav"
})

SWEP.HoldType = "duel"

SWEP.ViewModel = "models/weapons/cstrike/c_pist_elite.mdl"
SWEP.WorldModel = "models/weapons/w_pist_elite.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.Primary.Delay = 0.5
SWEP.Primary.Damage = 85

SWEP.Primary.ClipSize = 4
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "XBowBolt"
SWEP.Primary.DefaultClip = 15

SWEP.ReloadDelay = 3.5

SWEP.Tier = 4
SWEP.MaxStock = 3

SWEP.ConeMax = 0
SWEP.ConeMin = 0

SWEP.WalkSpeed = SPEED_SLOW

SWEP.Primary.Sound = Sound("Weapon_Artemis_Fire.Single")
SWEP.ReloadSound = Sound("Weapon_Artemis_Reload.Single")
SWEP.DryFireSound = Sound("Weapon_Artemis_Empty.Single")

SWEP.DontScaleReloadSpeed = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.1, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 1, 1)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, "'Actaeon' Dual Crossbows", "Bolts pierce slightly instead of exploding, and inflict damage vulnerability, less damage", function(wept)
	wept.Primary.Damage = wept.Primary.Damage * 0.75
	wept.Primary.Projectile = "projectile_arrow_inq"
	wept.EntModify = function(self, ent)
		ent:SetDTBool(0, true)
	end
end)

function SWEP:SecondaryAttack()
end

function SWEP:SendWeaponAnimation()
	self:SendWeaponAnim(self:Clip1() % 2 == 0 and ACT_VM_PRIMARYATTACK or ACT_VM_SECONDARYATTACK)
	self.IdleAnimation = CurTime() + self:SequenceDuration()
end

function SWEP:ProcessReloadEndTime()
	local reloadspeed = self.ReloadSpeed * self:GetReloadSpeedMultiplier()
	self:SetReloadFinish(CurTime() + self.ReloadDelay / reloadspeed)
end
