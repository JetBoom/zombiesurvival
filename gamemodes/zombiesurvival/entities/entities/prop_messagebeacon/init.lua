INC_SERVER()

ENT.ObjHealth = 100

function ENT:Initialize()
	self:SetModel("models/props_combine/combine_mine01.mdl")
	self:SetModelScale(0.333, 0)
	--self:PhysicsInit(SOLID_VPHYSICS)
	self:PhysicsInitBox(Vector(-8.29, -8.29, 0), Vector(8.29, 8.29, 10.13))
	self:SetCollisionBounds(Vector(-8.29, -8.29, 0), Vector(8.29, 8.29, 10.13))
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:SetUseType(SIMPLE_USE)

	self:CollisionRulesChanged()

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMaterial("metal")
		phys:EnableMotion(false)
		phys:Wake()
	end

	local worldhint = ents.Create("point_worldhint")
	if worldhint:IsValid() then
		self.WorldHint = worldhint
		worldhint:SetPos(self:GetPos())
		worldhint:SetParent(self)
		worldhint:Spawn()
		worldhint:SetViewable(TEAM_HUMAN)
		worldhint:SetRange(7680)
		worldhint:SetHint(self:GetMessage())
		worldhint:SetTranslated(true)
	end
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	if key == "messageid" then
		value = tonumber(value)
		if not value then return end
		self:SetMessageID(value)
	end
end

function ENT:OnTakeDamage(dmginfo)
	if dmginfo:GetDamage() <= 0 then return end

	self:TakePhysicsDamage(dmginfo)

	if not self.Destroyed then
		local attacker = dmginfo:GetAttacker()
		if not attacker:IsValidHuman() then
			if attacker:IsValidZombie() and self:HumanNearby() then
				attacker:AddLifeBarricadeDamage(dmginfo:GetDamage())
			end

			self.ObjHealth = self.ObjHealth - dmginfo:GetDamage()
			if self.ObjHealth <= 0 then
				self.Destroyed = true
				local effectdata = EffectData()
					effectdata:SetOrigin(self:LocalToWorld(self:OBBCenter()))
				util.Effect("Explosion", effectdata, true, true)
			end
		end
	end
end

function ENT:SetMessageID(id)
	self:SetDTInt(0, id)
	self.WorldHint:SetHint(self:GetMessage())
end

function ENT:AltUse(activator, tr)
	self:PackUp(activator)
end

function ENT:OnPackedUp(pl)
	pl:GiveEmptyWeapon("weapon_zs_messagebeacon")
	pl:GiveAmmo(1, "striderminigun")

	pl:PushPackedItem(self:GetClass(), self.ObjHealth)

	self:Remove()
end

function ENT:Think()
	if self.Destroyed then
		self:Remove()
	end
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end
