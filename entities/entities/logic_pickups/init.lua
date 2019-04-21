ENT.Type = "point"

function ENT:Initialize()
end

function ENT:Think()
end

function ENT:AcceptInput(name, activator, caller, args)
	name = string.lower(name)
	if name == "setmaxweaponpickups" then
		self:SetKeyValue("maxweaponpickups", args)
	elseif name == "setmaxammopickups" then
		self:SetKeyValue("maxammopickups", args)
	elseif name == "setmaxflashlightpickups" then
		self:SetKeyValue("maxflashlightpickups", args)
	elseif name == "setweaponrequiredforammo" then
		self:SetKeyValue("weaponrequiredforammo", args)
	end
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	if key == "maxweaponpickups" then
		value = tonumber(value) or -1
		if value == -1 then
			GAMEMODE.MaxWeaponPickups = nil
		else
			GAMEMODE.MaxWeaponPickups = value
		end
	elseif key == "maxammopickups" then
		value = tonumber(value) or -1
		if value == -1 then
			GAMEMODE.MaxAmmoPickups = nil
		else
			GAMEMODE.MaxAmmoPickups = value
		end
	elseif key == "maxflashlightpickups" then
		value = tonumber(value) or -1
		if value == -1 then
			GAMEMODE.MaxFlashlightPickups = nil
		else
			GAMEMODE.MaxFlashlightPickups = value
		end
	elseif key == "weaponrequiredforammo" then
		GAMEMODE.WeaponRequiredForAmmo = tonumber(value) == 1
	end
end
