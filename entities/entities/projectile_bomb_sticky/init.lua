INC_SERVER()

ENT.NoNails = true

function ENT:Initialize()
	self:SetModel("models/combine_helicopter/helicopter_bomb01.mdl")
	self:SetColor(Color(255, 0, 0))
	self:SetMaterial("models/props_combine/masterinterface01c")
	self:PhysicsInitSphere(2)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetModelScale(0.2, 0)
	self:SetupGenericProjectile(true)

	self:SetTrigger(true)
	self:DrawShadow(false)
	self:SetUseType(SIMPLE_USE)
	self:SetTimeCreated(CurTime())
	self.PostOwner = self:GetOwner() --GetOwner sets to nil on remove
end

function ENT:OnRemove()
	if not self.Exploded and not self.PickedUp then
		self:Explode()

		local pos = self:GetPos()
		local alt = self:GetDTBool(0)

		local effectdata = EffectData()
			effectdata:SetOrigin(pos)
		util.Effect("Explosion", effectdata)
		if alt then
			util.Effect("explosion_cold", effectdata)
		end
	end
end

function ENT:Use(activator, caller)
	if not self.Exploded and activator:Team() == TEAM_HUMAN and (activator == self:GetOwner() or not self:GetOwner():IsValid()) then
		self.Exploded = true
		self.PickedUp = true

		activator:GiveAmmo(1, "impactmine")

		net.Start("zs_ammopickup")
			net.WriteUInt(1, 16)
			net.WriteString("impactmine")
		net.Send(activator)

		self:Remove()
	end
end

function ENT:Think()
	if self.Stuck and (not self.Stuck:IsValid() or self.Stuck:IsPlayer() and not self.Stuck:IsValidLivingZombie()) then
		self:Explode()
	end
	if self.Exploded and not self.PickedUp then
		local pos = self:GetPos()
		local alt = self:GetDTBool(0)

		local effectdata = EffectData()
			effectdata:SetOrigin(pos)
		util.Effect("Explosion", effectdata)
		if alt then
			util.Effect("explosion_cold", effectdata)
		end

		self:Remove()
	end
	if self.PhysicsData then
		self:Hit(self.PhysicsData.HitPos, self.PhysicsData.HitNormal, self.PhysicsData.HitEntity, self.PhysicsData.OurOldVelocity)
	end

	self:NextThink(CurTime())
	return true
end

function ENT:Hit(vHitPos, vHitNormal, eHitEntity, vOldVelocity)
	if self:GetHitTime() ~= 0 then return end
	self:SetHitTime(CurTime())

	vHitPos = vHitPos or self:GetPos()
	vHitNormal = (vHitNormal or Vector(0, 0, -1)) * -1

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
		phys:Sleep()
	end

	self:SetMoveType(MOVETYPE_NONE)
	self:SetPos(vHitPos + vHitNormal)

	if eHitEntity:IsValid() then
		self:SetSolid(SOLID_NONE)
		self:AddEFlags(EFL_SETTING_UP_BONES)
		self.Stuck = eHitEntity

		local followed = false
		local bonecount = eHitEntity:GetBoneCount()
		if bonecount and bonecount > 1 then
			local boneindex = eHitEntity:NearestBone(vHitPos)
			if boneindex and boneindex > 0 then
				self:FollowBone(eHitEntity, boneindex)
				self:SetPos(eHitEntity:GetBonePositionMatrixed(boneindex))
				followed = true
			end
		end
		if not followed then
			self:SetParent(eHitEntity)
		end
	end
end

function ENT:StartTouch(ent)
	if self:GetHitTime() ~= 0 or not ent:IsValid() then return end

	local owner = self:GetOwner()

	if ent == owner or not ent:IsValidLivingZombie() then return end

	self:SetHitTime(CurTime())

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
		phys:Sleep()
	end

	self:SetMoveType(MOVETYPE_NONE)

	if ent:IsValid() then
		self:SetSolid(SOLID_NONE)
		self:AddEFlags(EFL_SETTING_UP_BONES)
		self.Stuck = ent

		local followed = false
		local bonecount = ent:GetBoneCount()
		if bonecount and bonecount > 1 then
			local boneindex = ent:NearestBone(self:GetPos())
			if boneindex and boneindex > 0 then
				self:FollowBone(ent, boneindex)
				self:SetPos(ent:GetBonePositionMatrixed(boneindex))
				followed = true
			end
		end
		if not followed then
			self:SetParent(ent)
		end
	end
end

function ENT:Explode()
	if self.Exploded then return end
	self.Exploded = true

	local alt = self:GetDTBool(0)
	local owner = self.PostOwner:IsValid() and self.PostOwner or self:GetOwner()

	if owner:IsValidLivingHuman() then
		local source = self:ProjectileDamageSource()
		local pos = self:GetPos()
		local radius = 70
		if alt then
			for _, ent in pairs(util.BlastAlloc(inflictor, owner, pos, radius * (owner.ExpDamageRadiusMul or 1))) do
				if ent:IsValidLivingPlayer() and gamemode.Call("PlayerShouldTakeDamage", ent, owner) then
					ent:AddLegDamageExt(15 * self:GetCharge(), owner, inflictor, SLOWTYPE_COLD)
				end
			end

			POINTSMULTIPLIER = 1.25
		end
		util.BlastDamagePlayer(source, owner, pos, radius, (self.ProjDamage or 75) * self:GetCharge(), DMG_ALWAYSGIB)
		if alt then
			POINTSMULTIPLIER = 1
		end
	end
end

function ENT:OnTakeDamage(dmginfo)
	self:TakePhysicsDamage(dmginfo)

	local attacker = dmginfo:GetAttacker()
	if not (attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN) and dmginfo:GetDamage() >= 5 and bit.band(dmginfo:GetDamageType(), DMG_ACID) == 0 then
		self:Explode()
	end
end

function ENT:PhysicsCollide(data, physobj)
	self.PhysicsData = data
	self:NextThink(CurTime())
end
