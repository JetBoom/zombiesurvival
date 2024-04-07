ENT.Type = "point"

function ENT:Initialize()
	self.KeepFists = self.KeepFists or 1
end

function ENT:AcceptInput(name, activator, caller, args)
	name = string.lower(name)
	if name == "stripweapon" then
		if activator:IsPlayer() and activator:Alive() and activator:Team() == TEAM_HUMAN then
				activator:StripWeapon(args)
		end
	elseif name == "stripallweapons" then
		if activator:IsPlayer() and activator:Alive() and activator:Team() == TEAM_HUMAN then
			if tonumber(self.KeepFists) == 1 then
				local weps = activator:GetWeapons()
				for k, v in pairs(weps) do
					local weaponclass = v:GetClass()
					if weaponclass ~= "weapon_zs_fists" then activator:StripWeapon(weaponclass) end
				end
			else
				activator:StripWeapons(args)
			end
		end
	elseif name == "setkeepfists" then
		self.KeepFists = tonumber(args)
	end
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	if key == "keepfists" then
		self.KeepFists = tonumber(value)
	end
end
		