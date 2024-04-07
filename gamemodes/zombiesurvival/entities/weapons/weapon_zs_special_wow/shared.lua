SWEP.PrintName = "Will O' Wisp"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.ZombieOnly = true
SWEP.IsMelee = true

SWEP.ViewModel = "models/weapons/v_knife_t.mdl"
SWEP.WorldModel = "models/weapons/w_knife_t.mdl"

util.PrecacheSound("npc/scanner/scanner_nearmiss1.wav")
util.PrecacheSound("npc/scanner/scanner_nearmiss2.wav")
util.PrecacheSound("npc/scanner/scanner_talk1.wav")
util.PrecacheSound("npc/scanner/scanner_talk2.wav")

SWEP.NextAmbientSound = 0

function SWEP:Initialize()
	self:HideViewAndWorldModel()
end

function SWEP:Think()
end

function SWEP:PrimaryAttack()
	if CurTime() < self:GetNextPrimaryAttack() then return end
	self:SetNextPrimaryAttack(CurTime() + 4)

	local owner = self:GetOwner()

	owner.LastRangedAttack = CurTime()

	if SERVER then
		owner:GodEnable()
		util.BlastDamageEx(self, owner, owner:GetShootPos(), 64, 5, DMG_DISSOLVE)
		owner:GodDisable()
	end

	if IsFirstTimePredicted() then
		local effectdata = EffectData()
			effectdata:SetOrigin(owner:GetShootPos())
			effectdata:SetNormal(owner:GetAimVector())
		util.Effect("explosion_wispball", effectdata)
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
	if CurTime() >= self:GetNextSecondaryAttack() then
		self:SetNextSecondaryAttack(CurTime() + 5)
		self:EmitSound("npc/scanner/scanner_talk2.wav")
	end
end
