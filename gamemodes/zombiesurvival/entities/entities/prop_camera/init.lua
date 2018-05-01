INC_SERVER()

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetModel("models/props_c17/light_domelight02_off.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
		phys:Wake()
	end

	self:SetMaxObjectHealth(self.MaxHealth)
	self:SetObjectHealth(self:GetMaxObjectHealth())

	local ent = ents.Create("prop_hitbox_camera")
	if ent:IsValid() then
		ent:SetPos(self:GetPos())
		ent:SetAngles(self:GetAngles())
		ent:SetOwner(self)
		ent:SetParent(self)
		ent:Spawn()

		self:DeleteOnRemove(ent)
		self.Hitbox = ent
	end
end

function ENT:SetObjectHealth(health)
	self:SetDTFloat(3, health)

	if health <= 0 and not self.Destroyed then
		self.Destroyed = true

		self:EmitSound("npc/manhack/gib.wav")

		local ent = ents.Create("prop_physics")
		if ent:IsValid() then
			ent:SetPos(self:WorldSpaceCenter())
			ent:SetAngles(self:GetAngles())
			ent:SetModel("models/manhack.mdl")
			ent:Spawn()

			ent:Fire("break")
			ent:Fire("kill", "", 0.05)
		end

		if self:GetObjectOwner():IsValidLivingHuman() then
			self:GetObjectOwner():SendDeployableLostMessage(self)
		end

		self:Remove()
	end
end

function ENT:AltUse(activator, tr)
	self:PackUp(activator)
end

function ENT:OnPackedUp(pl)
	pl:GiveEmptyWeapon(self.SWEP)
	pl:GiveAmmo(1, "camera")

	pl:PushPackedItem(self:GetClass(), self:GetObjectHealth())

	self:Remove()
end

function ENT:OnTakeDamage(dmginfo)
	self:TakePhysicsDamage(dmginfo)

	if dmginfo:GetDamage() <= 0 then return end

	local attacker = dmginfo:GetAttacker()
	if not (attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN) then
		self:ResetLastBarricadeAttacker(attacker, dmginfo)
		self:SetObjectHealth(self:GetObjectHealth() - dmginfo:GetDamage())
	end
end

function ENT:SetMaxObjectHealth(health)
	self:SetDTInt(1, health)
end

function ENT:ClearObjectOwner()
	self:SetObjectOwner(NULL)
end

function ENT:SetObjectOwner(ent)
	self:SetDTEntity(1, ent)
	if self.HitBox then
		self.HitBox:SetObjectOwner(ent)
	end
end
