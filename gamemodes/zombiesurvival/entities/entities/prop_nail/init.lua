INC_SERVER()

ENT.m_NextStrainSound = 0

hook.Add("PlayerInitialSpawn", "NailPlayerInitialSpawn", function(pl)
	local uid = pl:UniqueID()

	for _, nail in pairs(ents.FindByClass("prop_nail")) do
		if nail:GetOwnerUID() == uid then
			nail:SetDeployer(pl)
		end
	end
end)

function ENT:Initialize()
	self:SetModel("models/crossbow_bolt.mdl")
	self:SetModelScale(0.75)
	self.m_NailUnremovable = self.m_NailUnremovable or false
	self.HealthOveride = self.HealthOveride or -1
	self.HealthMultiplier = self.HealthMultiplier or 1
end

function ENT:OnDamaged(damage, attacker, inflictor, dmginfo)
	if CurTime() >= self.m_NextStrainSound then
		self.m_NextStrainSound = CurTime() + math.min(damage * 0.025, 1)
		self:EmitSound("physics/metal/metal_box_impact_hard"..math.random(3)..".wav", math.Clamp(damage * 2.5, 60, 80), math.min(255, 150 + (1 - (self:GetNailHealth() / self:GetMaxNailHealth())) * 100))
	end
end

function ENT:AttachTo(baseent, attachent, physbone, physbone2)
	self:SetBaseEntity(baseent)
	self:SetAttachEntity(attachent, physbone, physbone2)

	if not baseent.Nails then baseent.Nails = {} end
	if not attachent.Nails then attachent.Nails = {} end

	table.insert(baseent.Nails, self)
	table.insert(attachent.Nails, self)

	self:SetParentPhysNum(physbone or 0)
	self:SetParent(baseent)

	if baseent:IsValid() then
		baseent:CollisionRulesChanged()
	end
	if attachent:IsValid() then
		attachent:CollisionRulesChanged()
	end

	if baseent:GetBarricadeHealth() == 0 then
		local health = baseent:GetDefaultBarricadeHealth()
		if self.HealthOveride and self.HealthOveride > 0 then health = self.HealthOveride end
		health = health * (self.HealthMultiplier or 1)
		baseent:SetMaxBarricadeHealth(health)
		baseent:SetBarricadeHealth(health)
		baseent:SetBarricadeRepairs(baseent:GetMaxBarricadeRepairs())
	end

	baseent:RecalculateNailBonuses()
end

function ENT:SetAttachEntity(ent, physbone1, physbone2)
	self.m_AttachEntity = ent

	local baseent = self:GetBaseEntity()
	if not baseent:IsValid() then return end

	local cons = constraint.Weld(baseent, ent, physbone1 or 0, physbone2 or 0, 0, true)
	if cons ~= nil then
		for _, oldcons in pairs(constraint.FindConstraints(baseent, "Weld")) do
			if oldcons.Ent1 == ent or oldcons.Ent2 == ent then
				cons = oldcons.Constraint
				break
			end
		end
	end

	cons:DeleteOnRemove(self)
	self:SetNailConstraint(cons)

	if baseent:IsValid() then
		baseent:CollisionRulesChanged()
	end
	if ent and ent:IsValid() then
		ent:CollisionRulesChanged()
	end

	timer.Simple(0.1, function() GAMEMODE:EvaluatePropFreeze() end)

	return cons
end

function ENT:SetNailConstraint(const)
	self.m_Constraint = const
end

function ENT:GetNailConstraint()
	return self.m_Constraint or NULL
end

function ENT:SetOwnerUID(uid)
	self.OwnerUID = uid
end

function ENT:GetOwnerUID()
	return self.OwnerUID
end

function ENT:SetDeployer(pl)
	if not pl then return end

	if type(pl) == "string" then
		self:SetDTString(0, pl)
		self:SetOwner(NULL)
		self:SetOwnerUID(nil)
	elseif pl:IsValid() then
		self:SetDTString(0, "")
		self:SetOwner(pl)
		self:SetOwnerUID(pl:UniqueID())
	end
end

function ENT:SetNewHealth(health)
	baseent = self:GetBaseEntity()
	baseent:SetBarricadeHealth(health)
end

function ENT:AcceptInput(name, activator, caller, args)
	name = string.lower(name)
	if name == "attachto" then
		local ent = ents.FindByName(args)[1]
		if ent and ent:IsValid() then
			self:SetParent(ent)
		end

		return true
	elseif name == "nailto" then
		if self:GetParent():IsValid() then
			local ent = args == "worldspawn" and game.GetWorld() or ents.FindByName(args)[1]
			if ent then
				self:AttachTo(self:GetParent(), ent)
			end
		end

		return true
	elseif name == "setname" or name == "setdeployer" then
		self:SetDeployer(args)

		return true
	elseif name == "sethealth" then
		self:SetNewHealth(args)

		return true
	elseif name == "setunremoveable" or name == "setunremovable" then
		self.m_NailUnremovable = tonumber(args) == 1

		return true
	elseif name == "toggleunremoveable" or name == "toggleunremovable" then
		self.m_NailUnremovable = not self.m_NailUnremovable

		return true
	end
end

function ENT:OnRemove()
	if self.m_IsRemoving then return end

	local baseent = self:GetBaseEntity()
	if baseent:IsValid() and not baseent:IsWorld() then
		baseent:RemoveNail(self, nil, nil, true)
	end
	local attachent = self:GetAttachEntity()
	if attachent:IsValid() and not attachent:IsWorld() then
		attachent:RemoveNail(self, nil, nil, true)
	end
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	if key == "unremoveable" or key == "unremovable" then
		self.m_NailUnremovable = tonumber(value) == 1
	elseif key == "healthoverride" then
		self.HealthOveride = tonumber(value)
	elseif key == "healthmultiplier" then
		self.HealthMultiplier = tonumber(value)
	end
end
