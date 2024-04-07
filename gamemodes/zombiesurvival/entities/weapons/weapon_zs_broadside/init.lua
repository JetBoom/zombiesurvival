INC_SERVER()

SWEP.Primary.Projectile = "projectile_rocket"
SWEP.Primary.ProjVelocity = 900
SWEP.Primary.ProjExplosionTaper = 0.95

function SWEP:EntModify(ent)
	local owner = self:GetOwner()
	owner.RemoteDetRocket = ent
	owner:SetGroundEntity(NULL)
	owner:SetVelocity(-220 * owner:GetAimVector())

	ent.ProjTaper = self.Primary.ProjExplosionTaper

	self:SetNextSecondaryFire(CurTime() + 0.5)
end

function SWEP:SecondaryAttack()
	if self:GetNextSecondaryFire() > CurTime() then return end

	for k,v in pairs(ents.FindByClass(self.Primary.Projectile)) do
		if v:GetOwner() == self:GetOwner() then
			v:Explode()
		end
	end

	self:SetNextSecondaryFire(CurTime() + 0.5)
end
