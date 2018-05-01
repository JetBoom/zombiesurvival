SWEP.Base = "weapon_zs_gorechild"

SWEP.PrintName = "Shadow Child"

SWEP.MeleeDamage = 2

function SWEP:MeleeHit(ent, trace, damage, forcescale)
	if ent:IsPlayer() then
		local owner = self:GetOwner()

		if owner.Master and owner.Master:IsValidLivingZombie() then
			owner.Master:AddLifeHumanDamage(damage)
		end
	end

	self.BaseClass.BaseClass.MeleeHit(self, ent, trace, damage, forcescale)
end

function SWEP:Think()
	self.BaseClass.BaseClass.Think(self)

	if IsFirstTimePredicted() then
		local curtime = CurTime()
		local owner = self:GetOwner()

		if self:GetSwinging() then
			if not owner:KeyDown(IN_ATTACK) and self.SwingStop and self.SwingStop <= curtime then
				self:SetSwinging(false)
				self.SwingStop = nil
			end
		end
	end

	self:NextThink(CurTime())
	return true
end

function SWEP:Swung()
	if not IsFirstTimePredicted() then return end

	self.SwingStop = CurTime() + 0.5

	if not self:GetSwinging() then
		self:SetSwinging(true)
	end

	self.AltSwing = not self.AltSwing

	local vm = self:GetOwner():GetViewModel()
	vm:SendViewModelMatchingSequence(vm:LookupSequence(self.AltSwing and "fists_left" or "fists_right"))

	self.BaseClass.BaseClass.Swung(self)
end

function SWEP:Deploy()
	local vm = self:GetOwner():GetViewModel()
	vm:SendViewModelMatchingSequence(vm:LookupSequence("fists_draw"))

	return self.BaseClass.BaseClass.Deploy(self)
end
