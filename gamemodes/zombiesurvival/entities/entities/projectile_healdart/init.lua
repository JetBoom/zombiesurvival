INC_SERVER()

ENT.Heal = 5.1
ENT.Gravity = true

function ENT:Initialize()
	self:SetModel("models/Items/CrossbowRounds.mdl")
	self:PhysicsInitSphere(1)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetModelScale(0.3, 0)
	self:SetupGenericProjectile(self.Gravity)

	self:Fire("kill", "", 30)

	if self:GetSeeked():IsValidLivingHuman() and self:GetOwner():IsValidLivingHuman() then
		local owner = self:GetOwner()
		local seeked = self:GetSeeked()

		local meforward = self:GetForward()
		local angtoseek = (self:GetPos() - seeked:GetPos()):GetNormalized()
		local dot = meforward:Dot(angtoseek)

		if dot > -0.35 or owner:GetPos():DistToSqr(seeked:GetPos()) > 700000 then
			self:SetSeeked(NULL)
		else
			self:EmitSound("buttons/blip1.wav", 65, 150)
		end
	end
end

function ENT:Think()
	if self.PhysicsData then
		self:Hit(self.PhysicsData.HitPos, self.PhysicsData.HitNormal, self.PhysicsData.HitEntity, self.PhysicsData.OurOldVelocity)
	end

	local parent = self:GetParent()
	if parent:IsValid() and parent:IsPlayer() and not parent:Alive() then
		self:Remove()
	end

	if self:GetSeeked():IsValidLivingHuman() then
		local target = self:GetSeeked()

		local targetpos = target:LocalToWorld(target:OBBCenter())
		local direction = (targetpos - self:GetPos()):GetNormal()

		self:SetAngles(direction:Angle())

		local phys = self:GetPhysicsObject()
		phys:SetVelocityInstantaneous(direction * 2000)
	end

	self:NextThink(CurTime())
end

function ENT:DoRefund(owner)
	if self.Refunded or not owner:IsSkillActive(SKILL_RECLAIMSOL) then return end

	self.Refunded = true
	owner:GiveAmmo(3, "Battery")
end

function ENT:AttachToPlayer(vHitPos, eHitEntity)
	self:AddEFlags(EFL_SETTING_UP_BONES)

	local followed = false
	local bonecount = eHitEntity:GetBoneCount()
	if bonecount and bonecount > 1 then
		local boneindex = eHitEntity:NearestBone(vHitPos)
		if boneindex and boneindex > 0 then
			self:FollowBone(eHitEntity, boneindex)
			self:SetPos((eHitEntity:GetBonePositionMatrixed(boneindex) * 2 + vHitPos) / 3)
			followed = true
		end
	end
	if not followed then
		self:SetParent(eHitEntity)
	end
	self:SetOwner(eHitEntity)
end

function ENT:Hit(vHitPos, vHitNormal, eHitEntity, vOldVelocity)
	if self:GetHitTime() ~= 0 then return end

	self:SetHitTime(CurTime())

	self:Fire("kill", "", 10)

	local owner = self:GetOwner()
	if not owner:IsValid() then owner = self end

	vHitPos = vHitPos or self:GetPos()
	vHitNormal = (vHitNormal or Vector(0, 0, -1)) * -1

	self:SetSolid(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)

	self:SetPos(vHitPos + vHitNormal)

	if eHitEntity:IsValid() then
		self:AttachToPlayer(vHitPos, eHitEntity)

		if eHitEntity:IsPlayer() and eHitEntity:Team() ~= TEAM_UNDEAD then
			local ehithp, ehitmaxhp = eHitEntity:Health(), eHitEntity:GetMaxHealth()

			if eHitEntity:IsSkillActive(SKILL_D_FRAIL) and ehithp >= ehitmaxhp * 0.25 then
				owner:CenterNotify(COLOR_RED, translate.Format("frail_healdart_warning", eHitEntity:GetName()))
				self:EmitSound("buttons/button8.wav", 70, math.random(115,128))
				self:DoRefund(owner)
			elseif not (owner:IsSkillActive(SKILL_RECLAIMSOL) and ehithp >= ehitmaxhp) then
				eHitEntity:GiveStatus("healdartboost", self.BuffDuration or 10)
				owner:HealPlayer(eHitEntity, self.Heal)
			else
				self:DoRefund(owner)
			end
		else
			self:DoRefund(owner)
		end
	else
		self:DoRefund(owner)
	end

	self:SetAngles(vOldVelocity:Angle())

	local effectdata = EffectData()
		effectdata:SetOrigin(vHitPos)
		effectdata:SetNormal(vHitNormal)
		if eHitEntity:IsValid() then
			effectdata:SetEntity(eHitEntity)
		else
			effectdata:SetEntity(NULL)
		end
	util.Effect("hit_healdart", effectdata)
end

function ENT:PhysicsCollide(data, phys)
	if not self:HitFence(data, phys) then
		self.PhysicsData = data
	end

	self:NextThink(CurTime())
end
