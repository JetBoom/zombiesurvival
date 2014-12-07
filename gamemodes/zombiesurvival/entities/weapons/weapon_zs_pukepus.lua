AddCSLuaFile()

SWEP.Base = "weapon_zs_zombie"

if CLIENT then
	SWEP.PrintName = "Puke Pus"
end

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
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	self.PukeLeft = 40

	self.Owner:EmitSound("npc/barnacle/barnacle_die2.wav")
	self.Owner:EmitSound("npc/barnacle/barnacle_digesting1.wav")
	self.Owner:EmitSound("npc/barnacle/barnacle_digesting2.wav")
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end

if not SERVER then return end

function SWEP:Think()
	local pl = self.Owner

	if self.PukeLeft > 0 and CurTime() >= self.NextPuke then
		self.PukeLeft = self.PukeLeft - 1
		self.NextEmit = CurTime() + 0.1

		local ent = ents.Create("projectile_poisonpuke")
		if ent:IsValid() then
			ent:SetPos(pl:EyePos())
			ent:SetOwner(pl)
			ent:Spawn()

			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				local ang = pl:EyeAngles()
				ang:RotateAroundAxis(ang:Forward(), math.Rand(-30, 30))
				ang:RotateAroundAxis(ang:Up(), math.Rand(-30, 30))
				phys:SetVelocityInstantaneous(ang:Forward() * math.Rand(475, 750))
			end
		end
	end

	self:NextThink(CurTime())
	return true
end
