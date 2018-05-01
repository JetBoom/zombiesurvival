INC_SERVER()

local function RefreshFFOwners(pl)
	for _, ent in pairs(ents.FindByClass("prop_ffemitter")) do
		if ent:IsValid() and ent:GetObjectOwner() == pl then
			ent:SetObjectOwner(NULL)
		end
	end
end
hook.Add("PlayerDisconnected", "ForceField.PlayerDisconnected", RefreshFFOwners)
hook.Add("OnPlayerChangedTeam", "ForceField.OnPlayerChangedTeam", RefreshFFOwners)

function ENT:Initialize()
	self:SetModel("models/props_lab/lab_flourescentlight002b.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)

	self:CollisionRulesChanged()

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
		phys:Wake()
	end

	local ent = ents.Create("prop_ffemitterfield")
	if ent:IsValid() then
		self.Field = ent

		ent:SetPos(self:GetPos() + self:GetForward() * 48 + self:GetUp() * -26)
		ent:SetAngles(self:GetAngles())
		ent:SetOwner(self)
		ent:Spawn()

		ent:SetEmitter(self)
	end

	self:SetMaxObjectHealth(150)
	self:SetObjectHealth(self:GetMaxObjectHealth())
end

function ENT:OnRemove()
	if self.Field and self.Field:IsValid() then
		self.Field:Remove()
	end
end

function ENT:SetObjectHealth(health)
	self:SetDTFloat(0, health)
	if health <= 0 and not self.Destroyed then
		self.Destroyed = true

		if self:GetObjectOwner():IsValidLivingHuman() then
			self:GetObjectOwner():SendDeployableLostMessage(self)
		end

		local ent = ents.Create("prop_physics")
		if ent:IsValid() then
			ent:SetModel(self:GetModel())
			ent:SetMaterial(self:GetMaterial())
			ent:SetAngles(self:GetAngles())
			ent:SetPos(self:GetPos())
			ent:SetSkin(self:GetSkin() or 0)
			ent:SetColor(self:GetColor())
			ent:Spawn()
			ent:Fire("break", "", 0)
			ent:Fire("kill", "", 0.1)
		end

		local effectdata = EffectData()
			effectdata:SetOrigin(self:LocalToWorld(self:OBBCenter()))
		util.Effect("Explosion", effectdata, true, true)
	end
end

function ENT:OnTakeDamage(dmginfo)
	if dmginfo:GetDamage() <= 0 then return end

	self:TakePhysicsDamage(dmginfo)

	local attacker = dmginfo:GetAttacker()
	if not (attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN) then
		self:SetObjectHealth(self:GetObjectHealth() - dmginfo:GetDamage())
		self:ResetLastBarricadeAttacker(attacker, dmginfo)
	end
end

function ENT:Use(activator, caller)
	if self.Destroyed or not activator:IsPlayer() or activator:Team() ~= TEAM_HUMAN or self:GetMaterial() ~= "" then return end

	if self:GetObjectOwner():IsValid() then
		if activator:GetInfo("zs_nousetodeposit") == "0" then
			local curammo = self:GetAmmo()
			local togive = math.min(math.min(15, activator:GetAmmoCount("pulse")), self.MaxAmmo - curammo)
			if togive > 0 then
				self:SetAmmo(curammo + togive)
				activator:RemoveAmmo(togive, "pulse")
				activator:RestartGesture(ACT_GMOD_GESTURE_ITEM_GIVE)
				self:EmitSound("npc/scanner/combat_scan1.wav", 60, 250)
			end
		end
	else
		self:SetObjectOwner(activator)
		self:GetObjectOwner():SendDeployableClaimedMessage(self)
	end
end

function ENT:AltUse(activator, tr)
	self:PackUp(activator)
end

function ENT:OnPackedUp(pl)
	pl:GiveEmptyWeapon("weapon_zs_ffemitter")
	pl:GiveAmmo(1, "slam")

	pl:PushPackedItem(self:GetClass(), self:GetObjectHealth())
	pl:GiveAmmo(self:GetAmmo(), "pulse")

	self:Remove()
end

function ENT:Think()
	if self.Destroyed then
		self:Remove()
	end
end
