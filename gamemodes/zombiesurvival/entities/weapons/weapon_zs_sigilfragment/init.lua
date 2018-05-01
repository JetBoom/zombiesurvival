INC_SERVER()

function SWEP:DoTeleport(target)
	local owner = self:GetOwner()

	local effectdata = EffectData()
	effectdata:SetOrigin(owner:WorldSpaceCenter())
	effectdata:SetEntity(owner)
	util.Effect(self.TeleportEffect, effectdata, true, true)
	effectdata:SetOrigin(target:WorldSpaceCenter())
	util.Effect(self.TeleportEffect, effectdata, true, true)

	owner:SetPos(target:GetPos())
	owner:SetBarricadeGhosting(true, true)

	if self:GetPrimaryAmmoCount() <= 0 then
		owner:StripWeapon(self:GetClass())
	end
end
