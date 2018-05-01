SWEP.PrintName = "Sigil Fragment"
SWEP.Description = "A mysterious stone that holds some power over the world.\nReturns you to any uncorrupted Sanity Sigil that you're pointing towards."

SWEP.Base = "weapon_zs_basemelee"

SWEP.ViewModel = "models/weapons/c_bugbait.mdl"
SWEP.WorldModel = "models/weapons/w_bugbait.mdl"
SWEP.UseHands = true

SWEP.HoldType = "slam"

SWEP.WalkSpeed = SPEED_FAST

SWEP.AmmoIfHas = true

SWEP.Primary.ClipSize = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "sigilfragment"
SWEP.Primary.Delay = 1
SWEP.Primary.DefaultClip = 1

SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "dummy"

SWEP.BoxPhysicsMin = Vector(-4, -4, -4)
SWEP.BoxPhysicsMax = Vector(4, 4, 4)

SWEP.TeleportStatus = "sigilteleport"
SWEP.TeleportEffect = "sigil_teleport"

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	GAMEMODE:DoChangeDeploySpeed(self)

	if CLIENT then
		self:Anim_Initialize()
	end
end

function SWEP:CanPrimaryAttack()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() or GAMEMODE:NumUncorruptedSigils() <= 0 then return false end

	if self:GetPrimaryAmmoCount() <= 0 then
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		return false
	end

	return true
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	self:SetNextPrimaryFire(CurTime() + 3)

	local owner = self:GetOwner()
	local vm = owner:GetViewModel()
	if IsValid(vm) then
		vm:SendViewModelMatchingSequence(vm:LookupSequence("squeeze") or 0)
	end
	owner:DoAttackEvent()

	self:EmitSound("ambient/levels/labs/teleport_preblast_suckin1.wav", 70, 140)

	self.Teleport = CurTime() + 1.5
	self.NextDeploy = nil
	self.NextIdle = nil

	if SERVER then
		local status = owner:GiveStatus(self.TeleportStatus)
		if status:IsValid() then
			status:SetFromSigil(self)
			status:SetEndTime(CurTime() + 1.5 * (owner.SigilTeleportTimeMul or 1))
		end
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:CanSecondaryAttack()
	return false
end

function SWEP:Reload()
	return false
end

function SWEP:Deploy()
	GAMEMODE:WeaponDeployed(self:GetOwner(), self)

	if self:GetPrimaryAmmoCount() <= 0 then
		self:SendWeaponAnim(ACT_VM_THROW)
	else
		self:SendWeaponAnim(ACT_VM_DEPLOY)
	end

	self.NextIdle = CurTime() + 2

	return true
end

function SWEP:Holster()
	self.NextDeploy = nil
	self.NextIdle = nil
	self.Teleport = nil

	if CLIENT then
		self:Anim_Holster()
	end

	return true
end

function SWEP:Think()
	if self.Teleport and CurTime() >= self.Teleport then
		self.Teleport = nil
		self.NextIdle = CurTime() + 1
	elseif self.NextIdle and CurTime() >= self.NextIdle then
		self.NextIdle = nil

		self:SendWeaponAnim(ACT_VM_IDLE)
	elseif self.NextDeploy and self.NextDeploy <= CurTime() then
		self.NextDeploy = nil

		if 0 < self:GetPrimaryAmmoCount() then
			self:SendWeaponAnim(ACT_VM_DRAW)
		else
			self:SendWeaponAnim(ACT_VM_THROW)
			if SERVER then
				self:Remove()
			end
		end
	end
end
