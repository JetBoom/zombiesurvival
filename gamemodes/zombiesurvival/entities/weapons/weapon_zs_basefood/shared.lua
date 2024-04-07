SWEP.Base = "weapon_zs_basemelee"

SWEP.PrintName = "Food"
SWEP.Slot = 4
SWEP.SlotPos = 0

SWEP.ViewModel = "models/weapons/c_grenade.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.UseHands = true

SWEP.HoldType = "slam"
SWEP.SwingHoldType = "camera"

SWEP.Primary.ClipSize = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "watermelon"
SWEP.Primary.Delay = 1
SWEP.Primary.DefaultClip = 1

SWEP.FoodHealth = 15
SWEP.FoodEatTime = 4
SWEP.EatViewAngles = Angle(80, 0, 15)
SWEP.EatViewOffset = Vector(-8, -40, 0)

SWEP.AmmoIfHas = true
SWEP.NoPickupIfHas = true
SWEP.NoMagazine = true

SWEP.DroppedColorModulation = Color(1, 0, 1)

SWEP.NeedToPlayEatSound = true
SWEP.SugarRushFood = false

SWEP.WalkSpeed = SPEED_NORMAL

AccessorFuncDT(SWEP, "EatEndTime", "Float", 0)
AccessorFuncDT(SWEP, "EatStartTime", "Float", 1)

SWEP.Weight = 1

function SWEP:CanEat()
	local owner = self:GetOwner()

	if owner:GetStatus("sickness") then return false end

	if owner:IsSkillActive(SKILL_SUGARRUSH) then
		return true
	end

	if owner:IsSkillActive(SKILL_GLUTTON) then
		return owner:GetBloodArmor() < owner.MaxBloodArmor + (40 * owner.MaxBloodArmorMul)
	end

	local max = owner:IsSkillActive(SKILL_D_FRAIL) and math.floor(owner:GetMaxHealth() * 0.25) or owner:GetMaxHealth()
	return owner:Health() < max
end

function SWEP:PrimaryAttack()
	if self:GetEatEndTime() == 0 and self:CanEat() then
		self:SetEatStartTime(CurTime())
		self:SetEatEndTime(CurTime() + self:GetFoodEatTime())
	end
end

function SWEP:SecondaryAttack()
	if not self:CanPrimaryAttack() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	local owner = self:GetOwner()

	if owner:HasTrinket("processor") then
		owner:EmitSound("weapons/bugbait/bugbait_squeeze1.wav", 65, 150)

		if SERVER then
			owner:GiveAmmo(self.FoodHealth * 2, "Battery")
			owner:StripWeapon(self:GetClass())
		end
	end
end

function SWEP:Reload()
end

function SWEP:Think()
	if self:GetEatEndTime() > 0 then
		local time = CurTime()

		if math.cos(12 * math.pi * (time - self:GetEatStartTime()) / self:GetFoodEatTime()) < 0 then -- Derivitive of sin(x) = cos(x/2)
			if self.NeedToPlayEatSound then
				self.NeedToPlayEatSound = false
				local snd
				if self.FoodIsLiquid then
					snd = "zombiesurvival/drink"..math.random(3)..".ogg"
				else
					snd = "zombiesurvival/eat1.ogg"
				end
				self:EmitSound(snd, 60, math.random(90, 110))
			end
		else
			self.NeedToPlayEatSound = true
		end

		if time >= self:GetEatEndTime() then
			self:SetEatEndTime(0)

			if SERVER then
				self:Eat()

				return
			end
		end

		local owner = self:GetOwner()
		if not owner:IsValid() then return end

		if owner:GetStatus("sickness") then
			self:SetEatEndTime(0)
		end

		if owner:IsSkillActive(SKILL_GLUTTON) or owner:IsSkillActive(SKILL_SUGARRUSH) then return end

		local max = owner:IsSkillActive(SKILL_D_FRAIL) and math.floor(owner:GetMaxHealth() * 0.25) or owner:GetMaxHealth()
		if owner:Health() >= max then
			self:SetEatEndTime(0)
		end
	end
end

function SWEP:Holster()
	self:SetEatStartTime(0)
	self:SetEatEndTime(0)

	return true
end

function SWEP:Deploy()
	gamemode.Call("WeaponDeployed", self:GetOwner(), self)
	return true
end

function SWEP:GetFoodEatTime()
	return self.FoodEatTime * (self:GetOwner():IsValid() and self:GetOwner().FoodEatTimeMul or 1)
end
