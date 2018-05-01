SWEP.Base = "weapon_zs_zombie"

SWEP.PrintName = "Puke Pus"

SWEP.Primary.Delay = 3.5

SWEP.ViewModel = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"

SWEP.NextPuke = 0
SWEP.PukeLeft = 0

function SWEP:Initialize()
	self:HideViewAndWorldModel()

	self.BaseClass.Initialize(self)
end

function SWEP:PrimaryAttack()
	if CurTime() < self:GetNextPrimaryFire() then return end
	local owner = self:GetOwner()
	local delay = owner:GetMeleeSpeedMul()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay * delay)

	self.PukeLeft = 35

	owner:EmitSound("npc/barnacle/barnacle_die2.wav")
	owner:EmitSound("npc/barnacle/barnacle_digesting1.wav")
	owner:EmitSound("npc/barnacle/barnacle_digesting2.wav")
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end
