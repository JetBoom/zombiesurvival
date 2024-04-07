ENT.Type = "anim"

ENT.NoNails = true
ENT.IgnoreTraces = true

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:HumanHoldable(pl)
	return false
end

function ENT:SetWeaponType(class)
	local weptab = weapons.Get(class)
	if weptab then
		if weptab.FakeWorldModel then
			self:SetModel(weptab.FakeWorldModel)
		elseif weptab.WorldModel then
			self:SetModel(weptab.WorldModel)
		end

		if SERVER then
			self:SetupPhysics(weptab)
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
