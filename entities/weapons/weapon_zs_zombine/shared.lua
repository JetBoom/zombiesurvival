AddCSLuaFile()

SWEP.Base = "weapon_zs_zombie"

SWEP.MeleeDelay = 0.3
SWEP.MeleeReach = 40
SWEP.MeleeDamage = 40
SWEP.MeleeForceScale = 1
SWEP.MeleeSize = 1
SWEP.MeleeDamageType = DMG_SLASH
SWEP.Primary.Delay = 1
SWEP.Primary.Automatic = false

SWEP.Secondary.Delay = 10
SWEP.Secondary.Ammo = "pistol"
SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = false
SWEP.RequiredClip = 1


SWEP.ViewModel = Model("models/weapons/zombine/v_zombine.mdl")
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"

AccessorFuncDT(SWEP, "AttackAnimTime", "Float", 3)

function SWEP:Think()
	self:CheckMeleeAttack()
	self:CheckMoaning()
	self:CheckIdleAnimation()
end

function SWEP:StopMoaningSound()
	local owner = self.Owner
	owner:StopSound("weapons/npc/zombine/zombie_voice_idle1.wav")
	owner:StopSound("weapons/npc/zombine/zombie_voice_idle2.wav")
	owner:StopSound("weapons/npc/zombine/zombie_voice_idle3.wav")
	owner:StopSound("weapons/npc/zombine/zombie_voice_idle4.wav")
	owner:StopSound("weapons/npc/zombine/zombie_voice_idle5.wav")
	owner:StopSound("weapons/npc/zombine/zombie_voice_idle6.wav")
	owner:StopSound("weapons/npc/zombine/zombie_voice_idle7.wav")
	owner:StopSound("weapons/npc/zombine/zombie_voice_idle8.wav")
	owner:StopSound("weapons/npc/zombine/zombie_voice_idle9.wav")
	owner:StopSound("weapons/npc/zombine/zombie_voice_idle10.wav")
	owner:StopSound("weapons/npc/zombine/zombie_voice_idle11.wav")
	owner:StopSound("weapons/npc/zombine/zombie_voice_idle12.wav")
	owner:StopSound("weapons/npc/zombine/zombie_voice_idle13.wav")
	owner:StopSound("weapons/npc/zombine/zombie_voice_idle14.wav")
	
end

function SWEP:CheckMoaning()
	if self:IsMoaning() and self.Owner:Health() < self:GetMoanHealth() then
		self:SetNextSecondaryFire(CurTime() + 1)
		self:StopMoaning()
	end
end

function SWEP:PrimaryAttack()
	if not self.Owner:OnGround() || self:GetGrenading() then return end

	self.BaseClass.PrimaryAttack(self)

	if self:IsSwinging() then
		self:SetAttackAnimTime(CurTime() + self.Primary.Delay)
	end
end

function SWEP:SendAttackAnim()
	if self.SwapAnims then
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	else	
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	end
	self.SwapAnims = not self.SwapAnims
end

function SWEP:CheckIdleAnimation()
	if self.IdleAnimation and self.IdleAnimation <= CurTime() then
		self.IdleAnimation = nil
		self:SendWeaponAnim(ACT_VM_IDLE)
	end
end

function SWEP:StopMoaning()
	if not self:IsMoaning() then return end
	self:SetMoaning(false)
	self.Owner:ResetSpeed()

	self:StopMoaningSound()
end

function SWEP:StartMoaning()

	if self:IsMoaning() then return end
	
	self:SetMoaning(true)
	
	self.Owner:SetWalkSpeed( self.Owner:GetMaxSpeed() * 1.8 ) 

	self:SetMoanHealth(self.Owner:Health())

	self:StartMoaningSound()
end

function SWEP:IsInAttackAnim()
	return self:GetAttackAnimTime() > 0 and CurTime() < self:GetAttackAnimTime()
end

function SWEP:Deploy()
	self.IdleAnimation = CurTime() + self:SequenceDuration()

	self.BaseClass.Deploy(self)
	
	return true
end

function SWEP:OnRemove()
	if IsValid(self.Owner) then
		self:StopMoaning()
	end
end
SWEP.Holster = SWEP.OnRemove

function SWEP:StartMoaningSound()
	self.Owner:EmitSound("weapons/npc/zombine/zombie_voice_idle"..math.random(1, 10)..".wav")
end

function SWEP:PlayHitSound()
	self.Owner:EmitSound("npc/zombie/claw_strike"..math.random(3)..".wav")
end

function SWEP:PlayMissSound()
	self.Owner:EmitSound("npc/zombie/claw_miss"..math.random(2)..".wav")
end

function SWEP:PlayAttackSound()
	self.Owner:EmitSound("weapons/npc/zombine/zo_attack"..math.random(1, 2)..".wav")
end

function SWEP:PlayAlertSound()
	self.Owner:EmitSound("weapons/npc/zombine/zombie_voice_idle"..math.random(1, 10)..".wav")
end

function SWEP:PlayIdleSound()
	self.Owner:EmitSound("weapons/npc/zombine/zombie_voice_idle"..math.random(1, 10)..".wav")
end

function SWEP:SetMoaning(moaning)
	self:SetDTBool(0, moaning)
end

function SWEP:GetMoaning()
	return self:GetDTBool(0)
end
SWEP.IsMoaning = SWEP.GetMoaning

function SWEP:TakeAmmo()
	self:TakeSecondaryAmmo(self.RequiredClip)
end

function SWEP:SetupDataTables()
	self:NetworkVar( "Bool", 5, "Grenading" )
	self:NetworkVar( "Float", 5, "SpawnedTime" )
	self:NetworkVar( "Float", 5, "GrenadeTime" )
end

function SWEP:SetMoanHealth(health)
	self:SetDTInt(0, health)
end

function SWEP:GetMoanHealth()
	return self:GetDTInt(0)
end