SWEP.PrintName = "Cool Wisp"

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

local math_random = math.random
local string_format = string.format

function SWEP:Initialize()
	self:HideViewAndWorldModel()
end

function SWEP:Think()
end

function SWEP:PrimaryAttack()
	if CurTime() < self:GetNextPrimaryAttack() then return end
	self:SetNextPrimaryAttack(CurTime() + 3)

	local owner = self:GetOwner()

	owner.LastRangedAttack = CurTime()

	if SERVER then
		for _, ent in pairs(util.BlastAlloc(self, owner, owner:GetPos(), 57)) do
			if ent:IsValidLivingPlayer() and gamemode.Call("PlayerShouldTakeDamage", ent, owner) and ent ~= owner then
				ent:GiveStatus("frost", 4)
				ent:AddLegDamageExt(10, owner, self, SLOWTYPE_COLD)
			end
		end

		owner:GodEnable()
		util.BlastDamageEx(self, owner, owner:GetShootPos(), 57, 5, DMG_DROWN)
		owner:GodDisable()
	end

	if IsFirstTimePredicted() then
		local effectdata = EffectData()
			effectdata:SetOrigin(owner:GetShootPos())
			effectdata:SetNormal(owner:GetAimVector())
		util.Effect("explosion_cold", effectdata)
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
	if CurTime() >= self:GetNextSecondaryAttack() then
		self:SetNextSecondaryAttack(CurTime() + 5)
		self:EmitSound(string_format("ambient/wind/wind_moan%d.wav", math_random(2)))
	end
end
