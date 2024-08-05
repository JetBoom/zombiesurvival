AddCSLuaFile()

util.PrecacheSound("weapons/bugbait/bugbait_squeeze1.wav")
util.PrecacheSound("weapons/bugbait/bugbait_squeeze2.wav")
util.PrecacheSound("weapons/bugbait/bugbait_squeeze3.wav")

if CLIENT then
	SWEP.PrintName = "부푼 좀비"
end

SWEP.Base = "weapon_zs_zombie"

SWEP.MeleeDamage = 30
SWEP.MeleeForceScale = 1.25

SWEP.Primary.Delay = 1.5
SWEP.Secondary.Delay = 12
SWEP.ShootPower = 990
SWEP.ShootDelay = 1
SWEP.Radius = 195 // Def. 225
SWEP.PushVel = 275 // Def. 450
SWEP.MaxDmg = 3 // Def. 4


function SWEP:Reload()
	self.BaseClass.SecondaryAttack(self)
end

function SWEP:Think()
	self.BaseClass.Think(self)
	
	self.Secondary.OriginalDelay = self.Secondary.OriginalDelay or self.Secondary.Delay
	self.OriginalShootDelay = self.OriginalShootDelay or self.ShootDelay
	
end

function SWEP:PlayAlertSound()
	self:PlayAttackSound()
end

function SWEP:PlayIdleSound()
	self.Owner:EmitSound("npc/barnacle/barnacle_tongue_pull"..math.random(3)..".wav")
end

function SWEP:PlayAttackSound()
	self.Owner:EmitSound("npc/ichthyosaur/attack_growl"..math.random(3)..".wav", 70, math.Rand(145, 155))
end

function SWEP:SecondaryAttack()
	-- if !self:CanSecondaryAttack() then return end
	if (self.NextSecondary or 0) > CurTime() then
		return
	end
	
	local owner = self.Owner
	if !IsValid(owner) or !owner:IsPlayer() then
		return
	end
	self:EmitSound("weapons/bugbait/bugbait_squeeze" .. tostring(math.random(1, 3)) .. ".wav")
	if SERVER then 
		owner:SetWalkSpeed(owner:GetWalkSpeed() * 0.75)
		owner:SetDuckSpeed(owner:GetDuckSpeed() * 0.75)
		local ent = ents.Create("projectile_siegeball")
		ent:SetPos(owner:GetShootPos() + owner:GetAimVector() * 10)
		ent.ShootPower = self.ShootPower
		ent.Radius = self.Radius
		ent.ShootTime = CurTime() + self.ShootDelay
		ent.PushVel = self.PushVel
		ent.MaxDmg = self.MaxDmg
		ent:SetOwner(owner)
		ent:Spawn()
	end
	self.NextSecondary = CurTime() + self.Secondary.Delay
end

if not CLIENT then return end

function SWEP:ViewModelDrawn()
	render.ModelMaterialOverride(0)
end

local matSheet = Material("models/weapons/v_zombiearms/ghoulsheet")
function SWEP:PreDrawViewModel(vm)
	render.ModelMaterialOverride(matSheet)
end
