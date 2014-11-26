AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_animations.lua")

include("shared.lua")

ENT.CleanupPriority = 1

function ENT:Initialize()
	self.m_Health = 200

	local weptab = weapons.GetStored(self:GetWeaponType())
	if weptab and not weptab.BoxPhysicsMax then
		self:PhysicsInit(SOLID_VPHYSICS)
	end
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMaterial("material")
		phys:EnableMotion(true)
		phys:Wake()
	end

	self:ItemCreated()
end

function ENT:SetClip1(ammo)
	self.m_Clip1 = tonumber(ammo) or self:GetClip1()
end

function ENT:GetClip1()
	return self.m_Clip1 or 0
end

function ENT:SetClip2(ammo)
	self.m_Clip2 = tonumber(ammo) or self:GetClip2()
end

function ENT:GetClip2()
	return self.m_Clip2 or 0
end

function ENT:SetShouldRemoveAmmo(bool)
	self.m_DontRemoveAmmo = not bool
end

function ENT:GetShouldRemoveAmmo()
	return not self.m_DontRemoveAmmo
end

function ENT:Use(activator, caller)
	if not activator:IsPlayer()
		or not activator:Alive()
		or activator:Team() ~= TEAM_HUMAN
		or self.Removing
		or activator:KeyDown(GAMEMODE.UtilityKey)
		or self.NoPickupsTime and CurTime() < self.NoPickupsTime and self.NoPickupsOwner ~= activator then return end

	local weptype = self:GetWeaponType()
	if not weptype then return end

	if activator:HasWeapon(weptype) and not GAMEMODE.MaxWeaponPickups then
		local wep = activator:GetWeapon(weptype)
		if wep:IsValid() then
			local primary = wep:ValidPrimaryAmmo()
			local secondary = wep:ValidSecondaryAmmo()

			if primary then activator:GiveAmmo(self:GetClip1(), primary) self:SetClip1(0) end
			if secondary then activator:GiveAmmo(self:GetClip2(), secondary) self:SetClip2(0) end

			local stored = weapons.GetStored(weptype)
			if stored and stored.AmmoIfHas then
				self:RemoveNextFrame()
			end

			return
		end
	end

	if not self.PlacedInMap or not GAMEMODE.MaxWeaponPickups or (activator.WeaponPickups or 0) < GAMEMODE.MaxWeaponPickups or team.NumPlayers(TEAM_HUMAN) <= 1 then
		local wep = self.PlacedInMap and activator:Give(weptype) or activator:GiveEmptyWeapon(weptype)
		if wep and wep:IsValid() and wep:GetOwner():IsValid() then
			if self:GetShouldRemoveAmmo() then
				wep:SetClip1(self:GetClip1())
				wep:SetClip2(self:GetClip2())
			end

			if self.PlacedInMap then
				activator.WeaponPickups = (activator.WeaponPickups or 0) + 1
			end

			self:RemoveNextFrame()
		end
	else
		activator:CenterNotify(COLOR_RED, translate.ClientGet(activator, "you_decide_to_leave_some"))
	end
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	if key == "weapontype" then
		self:SetWeaponType(value)
	end
end

function ENT:OnTakeDamage(dmginfo)
	self:TakePhysicsDamage(dmginfo)

	self.m_Health = self.m_Health - dmginfo:GetDamage()
	if self.m_Health <= 0 then
		self:RemoveNextFrame()
	end
end
