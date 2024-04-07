ENT.Type = "anim"
ENT.Base = "prop_baseoutlined"

ENT.NoNails = true

function ENT:HumanHoldable(pl)
	return pl:KeyDown(GAMEMODE.UtilityKey) or (pl:HasWeapon(self:GetWeaponType()) and self:GetClip1() == 0 and self:GetClip2() == 0)
end

function ENT:SetWeaponType(class)
	local weptab = weapons.Get(class)
	if string.sub(class, 1, 12) == "weapon_zs_t_" then -- Convertor
		if SERVER then
			self:MakeInvItemConvert(class)
		end
	elseif weptab then
		if weptab.WorldModel then
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
