INC_SERVER()

SWEP.OriginalMeleeDamage = SWEP.MeleeDamage

function SWEP:Deploy()
	self.BaseClass.BaseClass.Deploy(self)
end

function SWEP:OnMeleeHit(hitent, hitflesh, tr)
	if not hitent:IsPlayer() then
		self.MeleeDamage = 30
	end
end

function SWEP:PostOnMeleeHit(hitent, hitflesh, tr)
	self.MeleeDamage = self.OriginalMeleeDamage
end
