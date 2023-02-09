INC_SERVER()
AddCSLuaFile("cl_animations.lua")

ENT.CleanupPriority = 1

function ENT:Initialize()
	self.ObjHealth = 200
	self.Forced = self.Forced or false
	self.NeverRemove = self.NeverRemove or false
	self.Restrained = self.Restrained or false

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMaterial("material")
		phys:EnableMotion(not self.Restrained)
		phys:SetMass(45)
		phys:Wake()
	end

	self:ItemCreated()
end

function ENT:Use(activator, caller)
	self:GiveToActivator(activator, caller)
end

function ENT:GiveToActivator(activator, caller)
	if  not activator:IsPlayer()
		or not activator:Alive()
		or activator:Team() ~= TEAM_HUMAN
		or self.Removing
		or (activator:KeyDown(GAMEMODE.UtilityKey) and not self.Forced)
		or self.NoPickupsTime and CurTime() < self.NoPickupsTime and self.NoPickupsOwner ~= activator then

		return
	end

	local itype = self:GetInventoryItemType()
	if not itype then
		return
	end

	local itypecat = GAMEMODE:GetInventoryItemType(itype)
	if itypecat == INVCAT_TRINKETS and activator:HasInventoryItem(itype) then
		activator:CenterNotify(COLOR_RED, translate.ClientGet(activator, "you_already_have_this_trinket"))
		return
	end

	activator:AddInventoryItem(itype)

	net.Start("zs_invitem")
		net.WriteString(itype)
	net.Send(activator)

	if not self.NeverRemove then self:RemoveNextFrame() end
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	if key == "invitemtype" then
		self:SetInventoryItemType(value)
	elseif key == "neverremove" then
		self.NeverRemove = tonumber(value) == 1
	end
end

function ENT:AcceptInput(name, activator, caller, arg)
	name = string.lower(name)
	if name == "givetoactivator" then
		self.Forced = true
		self:GiveToActivator(activator,caller)
		return true
	end
end

function ENT:OnTakeDamage(dmginfo)
	if dmginfo:GetDamage() <= 0 then return end

	if self.NeverRemove then return end
	self:TakePhysicsDamage(dmginfo)

	local attacker = dmginfo:GetAttacker()
	if attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN then return end

	self.ObjHealth = self.ObjHealth - dmginfo:GetDamage()
	if self.ObjHealth <= 0 then
		self:RemoveNextFrame()
	end
end
