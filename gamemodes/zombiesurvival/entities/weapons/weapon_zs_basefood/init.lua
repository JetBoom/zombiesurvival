INC_SERVER()

function SWEP:Eat()
	local owner = self:GetOwner()

	if owner:IsSkillActive(SKILL_SUGARRUSH) then
		local boost = owner:GiveStatus("adrenalineamp", 14)
		if boost and boost:IsValid() then
			boost:SetSpeed(35)
		end
	end

	local max = owner:IsSkillActive(SKILL_D_FRAIL) and math.floor(owner:GetMaxHealth() * 0.25) or owner:GetMaxHealth()

	if owner:IsSkillActive(SKILL_GLUTTON) then
		local healing = self.FoodHealth * (owner.FoodRecoveryMul or 1)

		owner:SetBloodArmor(math.min(owner:GetBloodArmor() + (math.min(30, healing) * owner.BloodarmorGainMul), owner.MaxBloodArmor + (40 * owner.MaxBloodArmorMul)))
	else
		local healing = self.FoodHealth * (owner:GetTotalAdditiveModifier("FoodRecoveryMul", "HealingReceived") - (owner:GetPhantomHealth() > 0.5 and 0.5 or 0))

		owner:SetHealth(math.min(owner:Health() + healing, max))
		owner:SetPhantomHealth(math.max(0, math.floor(owner:GetPhantomHealth() - healing)))
	end

	self:TakePrimaryAmmo(1)
	if self:GetPrimaryAmmoCount() <= 0 then
		owner:StripWeapon(self:GetClass())
	end
end
