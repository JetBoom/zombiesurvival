INC_SERVER()

ENT.NoNails = true
ENT.m_IsImpactMine = true

function ENT:Initialize()
	self:SetModel("models/props_lab/tpplug.mdl")
	self:PhysicsInitSphere(1)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetModelScale(0.75, 0)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

	self:SetUseType(SIMPLE_USE)

	self.CreateTime = CurTime()

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMass(0.1)
		phys:SetBuoyancyRatio(0.002)
		phys:EnableMotion(true)
		phys:Wake()
	end

	self:Fire("kill", "", 900)

	self.Charges = 11
end

function ENT:Use(activator, caller)
	if not self.Exploded and activator:Team() == TEAM_HUMAN and (activator == self:GetOwner() or not self:GetOwner():IsValid()) then
		self.Exploded = true

		activator:GiveAmmo(1, "impactmine")

		net.Start("zs_ammopickup")
			net.WriteUInt(1, 16)
			net.WriteString("impactmine")
		net.Send(activator)

		self:Remove()
	end
end

function ENT:Hit(vHitPos, vHitNormal, eHitEntity, vOldVelocity)
	if self:GetHitTime() ~= 0 or not eHitEntity:IsWorld() then return end
	self:SetHitTime(CurTime())

	local owner = self:GetOwner()
	if not owner:IsValid() then owner = self end

	vHitPos = vHitPos or self:GetPos()
	vHitNormal = (vHitNormal or Vector(0, 0, -1)) * -0.1

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
		phys:Sleep()
	end

	self:SetMoveType(MOVETYPE_NONE)
	self:SetPos(vHitPos + vHitNormal)
	self:SetAngles(vHitNormal:Angle())

	self:EmitSound("weapons/slam/mine_mode.wav", 60)
end

local trace = {mask = MASK_SHOT}
function ENT:Think()
	if self.PhysicsData then
		self:Hit(self.PhysicsData.HitPos, self.PhysicsData.HitNormal, self.PhysicsData.HitEntity, self.PhysicsData.OurOldVelocity)
	end

	if self:IsActive() then
		trace.start = self:GetPos()
		trace.endpos = trace.start + self:GetForward() * self.Range
		trace.filter = self:GetCachedScanFilter()
		local ent = util.TraceLine(trace).Entity
		if ent:IsValidLivingZombie() and ent:Health() > 0 then -- Maybe they died from another mine in the same spot...
			self:Explode()
		end
	end

	local alt = self:GetDTBool(0)

	self:NextThink(CurTime() + (alt and 0.15 or 0.01))
	return true
end

function ENT:OnTakeDamage(dmginfo)
	self:TakePhysicsDamage(dmginfo)

	local attacker = dmginfo:GetAttacker()
	if not (attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN) then
		self:RemoveEffect(self:GetPos())
	end
end

function ENT:PhysicsCollide(data, phys)
	self.PhysicsData = data
	self:NextThink(CurTime())
end

local function BulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity
	local mine = dmginfo:GetInflictor()
	local falloff = mine.Range ^ 2 * 0.5
	if ent:IsValid() then
		if mine:GetStartPos():DistToSqr(tr.HitPos) > falloff then
			dmginfo:SetDamage(math.max(1, dmginfo:GetDamage() * (1 - ((mine:GetStartPos():DistToSqr(tr.HitPos) - falloff) / falloff))))
		end

		local owner = dmginfo:GetInflictor():GetOwner()
		if not owner:IsValidHuman() then
			local humans = team.GetPlayers(TEAM_HUMAN)
			if #humans > 0 then
				owner = humans[math.random(#humans)]

				dmginfo:SetAttacker(owner)
			end
		end
	end
end

function ENT:RemoveEffect(pos)
	util.ScreenShake(pos, 100, 5, 0.5, 100)

	local effectdata = EffectData()
		effectdata:SetOrigin(pos)
	util.Effect("HelicopterMegaBomb", effectdata, true, true)

	self:EmitSound("npc/roller/mine/rmine_tossed1.wav", 75, 200)

	self:Remove()
end

function ENT:Explode()
	if self.Exploded then return end
	local alt = self:GetDTBool(0)

	local pos = self:GetStartPos()
	if alt and self.Charges == 0 or not alt then
		self.Exploded = true

		if self.Charges == 0 then
			self:RemoveEffect(pos)
		end
	end

	self:FireBulletsLua(pos, self:GetForward(), 3, alt and 1 or 3, self.ProjDamage or 26.67, self:GetOwner(), 0.01, alt and "" or "AR2Tracer", BulletCallback, nil, nil, nil, nil, self)

	self:EmitSound(alt and "weapons/airboat/airboat_gun_energy2.wav" or "npc/scanner/cbot_energyexplosion1.wav", alt and 65 or 80, alt and 250 or 120)

	if not alt then
		self:RemoveEffect(pos)
	else
		self.Charges = self.Charges - 1
	end
end
