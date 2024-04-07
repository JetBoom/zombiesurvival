SWEP.PrintName = "'Zeus' Voltaic Crossbow"
SWEP.Description = "An electrified crossbow which nullifies zombie buffs and prevents healing or reviving. Has a low flight arc but does not headshot, and shoots a bolt as it travels."

SWEP.Base = "weapon_zs_baseproj"

SWEP.HoldType = "crossbow"

SWEP.ViewModel = "models/weapons/c_crossbow.mdl"
SWEP.WorldModel = "models/weapons/w_crossbow.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.Primary.Sound = Sound("ambient/levels/labs/electric_explosion5.wav")
SWEP.ReloadFinishSound = Sound("npc/vort/attack_shoot.wav")
SWEP.Primary.Delay = 1
SWEP.Primary.Automatic = true
SWEP.Primary.Damage = 123

SWEP.Primary.ClipSize = 1
SWEP.Primary.Ammo = "XBowBolt"
SWEP.Primary.DefaultClip = 15
SWEP.RequiredClip = 1

SWEP.SecondaryDelay = 0.25

SWEP.WalkSpeed = SPEED_SLOW

SWEP.Tier = 4
SWEP.MaxStock = 3

SWEP.ConeMax = 0
SWEP.ConeMin = 0

SWEP.NextZoom = 0

SWEP.ReloadSpeed = 0.8

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.065)

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound, 75, math.random(215, 225), 0.75)
	self:EmitSound("weapons/crossbow/bolt_skewer1.wav", 75, math.random(112, 128), 0.6, CHAN_WEAPON + 20)
end

function SWEP:EmitReloadSound()
	if IsFirstTimePredicted() then
		self:EmitSound("weapons/crossbow/bolt_load"..math.random(2)..".wav", 50, 85, 1, CHAN_WEAPON + 21)
	end
end

function SWEP:EmitReloadFinishSound()
	if IsFirstTimePredicted() then
		self:EmitSound(self.ReloadFinishSound, 75, 235, 0.5, CHAN_WEAPON + 22)
	end
end

function SWEP:IsScoped()
	return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.25 <= CurTime()
end

util.PrecacheSound("weapons/crossbow/bolt_load1.wav")
util.PrecacheSound("weapons/crossbow/bolt_load2.wav")
