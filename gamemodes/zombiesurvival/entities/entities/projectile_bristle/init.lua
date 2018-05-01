INC_SERVER()

function ENT:Initialize()
	self:SetModel("models/props_wasteland/dockplank_chunk01d.mdl")
	self:SetModelScale(0.3)
	self:PhysicsInitSphere(1)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetColor(Color(0, 255, 0, 255))
	self:SetupGenericProjectile(false)

	self:Fire("kill", "", 0.45)
	self.LastPhysicsUpdate = UnPredictedCurTime()
end

local vecDown = Vector()
function ENT:PhysicsUpdate(phys)
	local dt = (UnPredictedCurTime() - self.LastPhysicsUpdate)
	self.LastPhysicsUpdate = UnPredictedCurTime()

	vecDown.z = dt * -75
	phys:AddVelocity(vecDown)
end

function ENT:Think()
	if self.PhysicsData then
		self:Hit(self.PhysicsData.HitPos, self.PhysicsData.HitNormal, self.PhysicsData.HitEntity)
	end

	if self.Exploded then
		self:Remove()
	end
end

function ENT:Hit(vHitPos, vHitNormal, eHitEntity)
	if self.Exploded then return end
	self.Exploded = true

	local owner = self:GetOwner()
	if not owner:IsValid() then owner = self end

	vHitPos = vHitPos or self:GetPos()
	vHitNormal = vHitNormal or Vector(0, 0, 1)

	if eHitEntity:IsValid() then
		if eHitEntity:IsPlayer() then
			eHitEntity:TakeDamage(3, owner, self)

			local bleed = eHitEntity:GiveStatus("bleed")
			if bleed and bleed:IsValid() then
				bleed:AddDamage(8)
				bleed.Damager = self:GetOwner()
			end
			if eHitEntity:Team() == TEAM_HUMAN then
				local attach = eHitEntity:GetAttachment(1)
				if attach and vHitPos:DistToSqr(attach.Pos) <= 324 then
					eHitEntity:PlayEyePainSound()
					local status = eHitEntity:GiveStatus("dimvision", 5)
					if status then
						status.EyeEffect = true
					end
				end
			end
		else
			eHitEntity:TakeDamage(11, owner, self)
		end
	end
end

function ENT:OnRemove()
	local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos())
		effectdata:SetNormal(self:GetVelocity():GetNormalized())
	util.Effect("hit_barb", effectdata)
end

function ENT:PhysicsCollide(data, phys)
	if not self:HitFence(data, phys) then
		self.PhysicsData = data
	end

	self:NextThink(CurTime())
end
