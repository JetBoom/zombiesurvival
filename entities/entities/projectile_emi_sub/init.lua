INC_SERVER()

function ENT:Initialize()
	self:SetModel("models/dav0r/hoverball.mdl")
	self:PhysicsInitSphere(4)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetModelScale(0.55, 0)
	self:SetupGenericProjectile(false)

	self:EmitSound("weapons/physcannon/energy_sing_flyby2.wav", 70, math.random(245, 255))
	self:Fire("kill", "", 5.75)
	self.Creation = UnPredictedCurTime()
end

local vecDown = Vector()
function ENT:PhysicsUpdate(phys)
	local livetime = UnPredictedCurTime() - self.Creation
	local vel = phys:GetVelocity()

	vecDown.x = vel.x * 0.95
	vecDown.y = vel.y * 0.95
	vecDown.z = (200 + livetime * -300) + math.sin(self.Rot + livetime * 10) * 250

	phys:SetVelocityInstantaneous(vecDown)
end

function ENT:Hit(vHitPos, vHitNormal, eHitEntity)
	if self.Exploded then return end
	self.Exploded = true

	local owner = self:GetOwner()
	if not owner:IsValid() then owner = self end

	vHitPos = vHitPos or self:GetPos()
	vHitNormal = vHitNormal or Vector(0, 0, 1)

	if owner:IsValidLivingHuman() then
		local source = self:ProjectileDamageSource()
		if eHitEntity and eHitEntity:IsValid() then
			eHitEntity:TakeSpecialDamage((self.ProjDamage or 25) * (owner.ProjectileDamageMul or 1), DMG_DISSOLVE, owner, source, hitpos)

			util.BlastDamagePlayer(source, owner, vHitPos + vHitNormal, 67, self.ProjDamage/2, DMG_DISSOLVE)
		end
	end
end
