INC_SERVER()

local function RefreshRepFieldOwners(pl)
	for _, ent in pairs(ents.FindByClass("prop_repairfield*")) do
		if ent:IsValid() and ent:GetObjectOwner() == pl then
			ent:ClearObjectOwner()
		end
	end
end
hook.Add("PlayerDisconnected", "RepairField.PlayerDisconnected", RefreshRepFieldOwners)
hook.Add("OnPlayerChangedTeam", "RepairField.OnPlayerChangedTeam", RefreshRepFieldOwners)

function ENT:Initialize()
	self:SetModel("models/props/de_nuke/smokestack01.mdl")
	self:SetModelScale(0.55, 0)
	self:PhysicsInitBox(Vector(-12.29, -12.29, 0), Vector(12.29, 12.29, 90.13))
	self:SetCollisionBounds(Vector(-12.29, -12.29, 0), Vector(12.29, 12.29, 90.13))
	self:SetCollisionGroup(COLLISION_GROUP_WORLD) -- I decided to make them not collide.
	self:SetUseType(SIMPLE_USE)

	self:CollisionRulesChanged()

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMaterial("metal")
		phys:EnableMotion(false)
		phys:Wake()
	end

	self:SetMaxObjectHealth(150)
	self:SetObjectHealth(self:GetMaxObjectHealth())
end

function ENT:SetObjectHealth(health)
	self:SetDTFloat(1, health)
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

		local pos = self:LocalToWorld(self:OBBCenter())

		local effectdata = EffectData()
			effectdata:SetOrigin(pos)
		util.Effect("Explosion", effectdata, true, true)

		local amount = math.ceil(self:GetAmmo() * 0.5)
		while amount > 0 do
			local todrop = math.min(amount, 50)
			amount = amount - todrop
			ent = ents.Create("prop_ammo")
			if ent:IsValid() then
				local heading = VectorRand():GetNormalized()
				ent:SetAmmoType("pulse")
				ent:SetAmmo(todrop)
				ent:SetPos(pos + heading * 8)
				ent:SetAngles(VectorRand():Angle())
				ent:Spawn()

				local phys = ent:GetPhysicsObject()
				if phys:IsValid() then
					phys:ApplyForceOffset(heading * math.Rand(8000, 32000), pos)
				end
			end
		end
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
	if self.Removing or not activator:IsPlayer() or self:GetMaterial() ~= "" then return end

	if activator:Team() == TEAM_HUMAN then
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
end

function ENT:AltUse(activator, tr)
	self:PackUp(activator)
end

function ENT:OnPackedUp(pl)
	pl:GiveEmptyWeapon(self.SWEP)
	pl:GiveAmmo(1, self.DeployableAmmo)

	pl:PushPackedItem(self:GetClass(), self:GetObjectHealth())
	pl:GiveAmmo(self:GetAmmo(), "pulse")

	self:Remove()
end

function ENT:Think()
	if self.Destroyed then
		self:Remove()
		return
	end

	if CurTime() < self:GetNextRepairPulse() or self:GetAmmo() <= 0 or not self:GetObjectOwner():IsValidLivingHuman() then return end

	local pos = self:LocalToWorld(Vector(0, 0, 30))
	local count = 0

	local totalheal = self.HealValue * (self:GetObjectOwner().RepairRateMul or 1)

	for _, hitent in pairs(ents.FindInSphere(pos, self.MaxDistance * (self:GetObjectOwner().FieldRangeMul or 1))) do
		if not hitent:IsValid() or hitent == self or not WorldVisible(pos, hitent:NearestPoint(pos)) then
			continue
		end

		local healed = false

		if hitent:IsNailed() then
			local oldhealth = hitent:GetBarricadeHealth()
			if oldhealth <= 0 or oldhealth >= hitent:GetMaxBarricadeHealth() or hitent:GetBarricadeRepairs() <= 0.01 then continue end

			hitent:SetBarricadeHealth(math.min(hitent:GetMaxBarricadeHealth(), hitent:GetBarricadeHealth() + math.min(hitent:GetBarricadeRepairs(), totalheal)))
			healed = hitent:GetBarricadeHealth() - oldhealth
			hitent:SetBarricadeRepairs(math.max(hitent:GetBarricadeRepairs() - healed, 0))

		elseif hitent.GetObjectHealth then
			-- Taking the nil tr parameter for granted for now
			if hitent.HitByWrench and hitent:HitByWrench(self, owner, nil) then continue end

			local oldhealth = hitent:GetObjectHealth()
			if oldhealth <= 0 or oldhealth >= hitent:GetMaxObjectHealth() or hitent.m_LastDamaged and CurTime() < hitent.m_LastDamaged + 4 then continue end

			hitent:SetObjectHealth(math.min(hitent:GetMaxObjectHealth(), hitent:GetObjectHealth() + totalheal/2))
			healed = hitent:GetObjectHealth() - oldhealth
		end

		if healed then
			hitent:EmitSound("npc/dog/dog_servo"..math.random(7, 8)..".wav", 70, math.random(100, 105))
			gamemode.Call("PlayerRepairedObject", self:GetObjectOwner(), hitent, healed, self)

			local effectdata = EffectData()
				effectdata:SetOrigin(hitent:GetPos())
				effectdata:SetNormal((self:GetPos() - hitent:GetPos()):GetNormalized())
				effectdata:SetMagnitude(1)
			util.Effect("nailrepaired", effectdata, true, true)

			self:SetAmmo(self:GetAmmo() - 1)

			count = count + 1

			if count >= 3 or self:GetAmmo() <= 0 then break end
		end
	end

	if count > 0 then
		self:SetNextRepairPulse(CurTime() + 2 * (self:GetObjectOwner().FieldDelayMul or 1))
	end

	self:NextThink(self:GetNextRepairPulse())
	return true
end
