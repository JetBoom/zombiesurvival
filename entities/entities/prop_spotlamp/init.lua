INC_SERVER()

local function RefreshCrateOwners(pl)
	for _, ent in pairs(ents.FindByClass("prop_spotlamp")) do
		if ent:IsValid() and ent:GetObjectOwner() == pl then
			ent:SetObjectOwner(NULL)
		end
	end
end
hook.Add("PlayerDisconnected", "SpotLamp.PlayerDisconnected", RefreshCrateOwners)
hook.Add("OnPlayerChangedTeam", "SpotLamp.OnPlayerChangedTeam", RefreshCrateOwners)

function ENT:Initialize()
	self:SetModel("models/props_combine/combine_light001a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)

	self:CollisionRulesChanged()

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
	end

	self:SetMaxObjectHealth(100)
	self:SetObjectHealth(self:GetMaxObjectHealth())

	local ent = ents.Create("env_projectedtexture")
	if ent:IsValid() then
		ent:SetPos(self:GetSpotLightPos())
		ent:SetAngles(self:GetSpotLightAngles())
		ent:SetKeyValue("enableshadows", 0)
		ent:SetKeyValue("farz", 1500)
		ent:SetKeyValue("nearz", 8)
		ent:SetKeyValue("lightfov", 50)
		ent:SetKeyValue("lightcolor", "200 220 255 255")
		ent:SetParent(self)
		ent:Spawn()
		ent:Input("SpotlightTexture", NULL, NULL, "effects/flashlight001")
	end
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	if key == "maxobjecthealth" then
		value = tonumber(value)
		if not value then return end

		self:SetMaxObjectHealth(value)
	elseif key == "objecthealth" then
		value = tonumber(value)
		if not value then return end

		self:SetObjectHealth(value)
	end
end

function ENT:AcceptInput(name, activator, caller, args)
	if name == "setobjecthealth" then
		self:KeyValue("objecthealth", args)
		return true
	elseif name == "setmaxobjecthealth" then
		self:KeyValue("maxobjecthealth", args)
		return true
	end
end

function ENT:SetObjectHealth(health)
	self:SetDTFloat(0, health)

	if health <= 0 and not self.Destroyed then
		self.Destroyed = true

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

function ENT:AltUse(activator, tr)
	self:PackUp(activator)
end

function ENT:OnPackedUp(pl)
	pl:GiveEmptyWeapon("weapon_zs_spotlamp")
	pl:GiveAmmo(1, "spotlamp")

	pl:PushPackedItem(self:GetClass(), self:GetObjectHealth())

	self:Remove()
end

function ENT:Think()
	if self.Destroyed then
		self:Remove()
	end
end
