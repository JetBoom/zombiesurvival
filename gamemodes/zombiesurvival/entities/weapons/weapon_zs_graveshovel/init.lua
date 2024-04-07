INC_SERVER()

SWEP.OriginalMeleeDamage = SWEP.MeleeDamage

function SWEP:Deploy()
	self:SetShovelCharge(self:GetOwner().GraveShovelDamage or 0)

	return self.BaseClass.Deploy(self)
end

function SWEP:OnMeleeHit(hitent, hitflesh, tr)
	if self:GetOwner().GraveShovelDamage then
		self.MeleeDamage = self.MeleeDamage + self:GetOwner().GraveShovelDamage
	end
end

function SWEP:PostOnMeleeHit(hitent, hitflesh, tr)
	if hitent:IsValid() and hitent:IsPlayer() and hitent.Revive and hitent.Revive:IsValid() and gamemode.Call("PlayerShouldTakeDamage", hitent, self:GetOwner()) then
		local killer = self:GetOwner()

		if killer:IsValid() then
			killer.GraveShovelDamage = killer.GraveShovelDamage and killer.GraveShovelDamage + 5 or 5
			killer:EmitSound("hl1/ambience/particle_suck1.wav", 65, 250, 0.65)
		end

		self:SetShovelCharge(killer.GraveShovelDamage or 0)
		hitent:TakeSpecialDamage(hitent:Health(), DMG_DIRECT, self:GetOwner(), self, tr.HitPos)
	end

	self.MeleeDamage = self.OriginalMeleeDamage
end
