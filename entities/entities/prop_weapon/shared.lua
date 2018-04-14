ENT.Type = "anim"
ENT.Base = "prop_baseoutlined"

ENT.NoNails = true

ENT.SandBoxTable = {}
ENT.SandBoxTable["weapon_crowbar"] = "models/weapons/w_crowbar.mdl" 
ENT.SandBoxTable["weapon_pistol"] = "models/weapons/w_pistol.mdl" 
ENT.SandBoxTable["weapon_smg1"] = "models/weapons/w_smg1.mdl" 
ENT.SandBoxTable["weapon_frag"] = "models/weapons/w_grenade.mdl" 
ENT.SandBoxTable["weapon_physcannon"] = "models/weapons/w_physics.mdl" 
ENT.SandBoxTable["weapon_crossbow"] = "models/weapons/w_crossbow.mdl" 
ENT.SandBoxTable["weapon_shotgun"] = "models/weapons/w_shotgun.mdl" 
ENT.SandBoxTable["weapon_357"] = "models/weapons/w_357.mdl" 
ENT.SandBoxTable["weapon_rpg"] = "models/weapons/w_rocket_launcher.mdl" 
ENT.SandBoxTable["weapon_ar2"] = "models/weapons/w_irifle.mdl" 
ENT.SandBoxTable["weapon_physgun"] = "models/weapons/w_physics.mdl" 
ENT.SandBoxTable["weapon_bugbait"] = "models/weapons/w_bugbait.mdl" 
ENT.SandBoxTable["weapon_stunstick"] = "models/weapons/w_stunbaton.mdl" 
ENT.SandBoxTable["weapon_slam"] = "models/weapons/w_slam.mdl"

function ENT:HumanHoldable(pl)
	return pl:KeyDown(GAMEMODE.UtilityKey) or (pl:HasWeapon(self:GetWeaponType()) and self:GetClip1() == 0 and self:GetClip2() == 0)
end

function ENT:SetWeaponType(class)
	local weptab = weapons.GetStored(class)
	local sandbox_tab = self.SandBoxTable
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
		
		if self.SandBoxTable[class] then
			self:SetModel(self.SandBoxTable[string.lower(class)] or "models/weapons/w_bugbait.mdl")
		end
	end

	self:SetDTString(0, class)
end

function ENT:GetWeaponType()
	return self:GetDTString(0)
end
