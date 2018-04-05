ENT.Type = "anim"
ENT.Base = "prop_baseoutlined"

ENT.NoNails = true

function ENT:HumanHoldable(pl)
	return pl:KeyDown(GAMEMODE.UtilityKey) or (pl:HasWeapon(self:GetWeaponType()) and self:GetClip1() == 0 and self:GetClip2() == 0)
end

function ENT:SetWeaponType(class)
	local weptab = weapons.GetStored(class)
	if weptab then
		if weptab.WorldModel then
			self:SetModel(weptab.WorldModel)
		elseif weptab.Base then
			local weptabb = weapons.GetStored(weptab.Base)
			if weptabb and weptabb.WorldModel then
				self:SetModel(weptabb.WorldModel)
			end
		end

		if SERVER and weptab.BoxPhysicsMax then
			self:PhysicsInitBox(weptab.BoxPhysicsMin, weptab.BoxPhysicsMax)
			self:SetCollisionBounds(weptab.BoxPhysicsMin, weptab.BoxPhysicsMax)
			self:SetSolid(SOLID_VPHYSICS)
			self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
		end

		if weptab.ModelScale then
			self:SetModelScale(weptab.ModelScale, 0)
		end
	end

	self:SetDTString(0, class)
end

function ENT:GetWeaponType()
	return self:GetDTString(0)
end
