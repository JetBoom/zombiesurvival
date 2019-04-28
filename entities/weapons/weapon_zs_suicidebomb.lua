AddCSLuaFile()

SWEP.Base				= "weapon_zs_base"

SWEP.PrintName			= translate.Get("wn_suicidebmb")		

SWEP.Slot				= 3
SWEP.SlotPos			= 4

SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= false
SWEP.ViewModelFOV		= 65
SWEP.ViewModelFlip		= false

SWEP.HoldType			= "slam"

SWEP.Spawnable			= true
SWEP.AdminOnly			= false

SWEP.ViewModel			= "models/weapons/cstrike/c_c4.mdl"
SWEP.WorldModel			= "models/weapons/w_c4.mdl"

SWEP.UseHands 			= true

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Exploded = false

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
end

function SWEP:Deploy()
	self.NextLeeroy = nil
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
end

function SWEP:Holster()
	self.NextLeeroy = nil
	return true
end

function SWEP:Think()

	if self.NextLeeroy && self.NextLeeroy < CurTime() && !self.Exploded && self.Owner:Alive() then
	
		self.Exploded = true
		
		sound.Play("ambient/explosions/explode_"..math.random(1,7)..".wav",self.Owner:GetPos(),200,math.random(50,100))
		
		local fx = EffectData()
		fx:SetOrigin(self.Owner:GetPos())
		util.Effect("Explosion", fx)
		
		if SERVER then
			util.BlastDamage(self.Weapon, self.Owner, self.Owner:GetPos(), 400, 700)
		end
		if CLIENT then	
			self.Owner:Kill( )
		end	
	end
	
end

function SWEP:PrimaryAttack()
	if not self.NextLeeroy then
		self.NextLeeroy = CurTime() + 3.2
		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
		self.Weapon:SetNextPrimaryFire(CurTime() + 3.2)
	end
end

function SWEP:SecondaryAttack()
	return false
end

function SWEP:Reload()
	return false
end
