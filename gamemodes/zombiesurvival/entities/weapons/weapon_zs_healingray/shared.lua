SWEP.PrintName = "'Rejuvenator' Healing Ray"
SWEP.Description = "Locks on to humans and heals them to full, discharging medical ammo along a ray."

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "physgun"

SWEP.ViewModel = "models/weapons/c_physcannon.mdl"
SWEP.WorldModel = "models/weapons/w_physics.mdl"
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false
SWEP.UseHands = true

SWEP.Primary.Delay = 0.1

SWEP.Primary.ClipSize = 30
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "Battery"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 0
SWEP.ConeMin = 0

SWEP.Tier = 4
SWEP.MaxStock = 3

SWEP.HealRange = 300
SWEP.Heal = 3

SWEP.WalkSpeed = SPEED_SLOWER
SWEP.FireAnimSpeed = 0.24

GAMEMODE:SetPrimaryWeaponModifier(SWEP, WEAPON_MODIFIER_HEALRANGE, 100, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_HEALING, 0.3)

function SWEP:Initialize()
	self.BaseClass.Initialize(self)

	self.ChargeSound = CreateSound(self, "items/medcharge4.wav")
end

function SWEP:Holster()
	self.ChargeSound:Stop()

	return self.BaseClass.Holster(self)
end

function SWEP:OnRemove()
	self.ChargeSound:Stop()
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	local owner = self:GetOwner()

	local trtbl = owner:CompensatedPenetratingMeleeTrace(self.HealRange, 2, nil, nil, true)
	local ent
	for _, tr in pairs(trtbl) do
		local test = tr.Entity
		if test and test:IsValidLivingHuman() and gamemode.Call("PlayerCanBeHealed", test) then
			ent = test

			break
		end
	end

	if not ent or self:GetDTEntity(10):IsValid() then return end

	self:SetDTEntity(10, ent)
	self:SetNextPrimaryFire(CurTime() + 1)
	self:EmitSound("items/medshot4.wav", 75, 80)
end

function SWEP:CanPrimaryAttack()
	if self:GetPrimaryAmmoCount() <= 0 then
		return false
	end

	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() or self:GetDTEntity(10):IsValid() then return false end

	return self:GetNextPrimaryFire() <= CurTime()
end

function SWEP:Reload()
end

function SWEP:Think()
	self.BaseClass.Think(self)

	self:CheckHealRay()
end

function SWEP:StopHealing()
	self:SetDTEntity(10, NULL)
	self:SetNextPrimaryFire(CurTime() + 0.75)
	self:EmitSound("items/medshotno1.wav", 75, 60)
	self.ChargeSound:Stop()
end

function SWEP:TakeAmmo()
	self:TakeCombinedPrimaryAmmo(2)
end

function SWEP:CheckHealRay()
	local ent = self:GetDTEntity(10)
	local owner = self:GetOwner()

	if ent:IsValidLivingHuman() and gamemode.Call("PlayerCanBeHealed", ent) and owner:KeyDown(IN_ATTACK) and
		ent:WorldSpaceCenter():DistToSqr(owner:WorldSpaceCenter()) <= self.HealRange * self.HealRange and self:GetCombinedPrimaryAmmo() > 0 then

		if CurTime() > self:GetDTFloat(10) then
			owner:HealPlayer(ent, math.min(self:GetCombinedPrimaryAmmo(), self.Heal))
			self:TakeAmmo()
			self:SetDTFloat(10, CurTime() + 0.36)
			self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

			local effectdata = EffectData()
				effectdata:SetOrigin(ent:WorldSpaceCenter())
				effectdata:SetFlags(3)
				effectdata:SetEntity(self)
				effectdata:SetAttachment(1)
			util.Effect("tracer_healray", effectdata)
		end

		self.ChargeSound:PlayEx(1, 70)
	elseif ent:IsValid() then
		self:StopHealing()
	end
end
