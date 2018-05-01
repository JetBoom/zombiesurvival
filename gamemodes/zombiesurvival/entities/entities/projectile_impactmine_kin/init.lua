INC_SERVER()

ENT.NoNails = true
ENT.m_IsImpactMine = true

function ENT:Initialize()
	self:SetModel("models/props_c17/lamp_standard_off01.mdl")
	self:PhysicsInitSphere(2)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetModelScale(0.45, 0)
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

	local angle = vHitNormal:Angle()
	angle:RotateAroundAxis(angle:Right(), -90)

	self:SetMoveType(MOVETYPE_NONE)
	self:SetPos(vHitPos + vHitNormal)
	self:SetAngles(angle)

	self:EmitSound("weapons/slam/mine_mode.wav", 60)
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
		if not owner:IsValidLivingHuman() then
			local humans = team.GetPlayers(TEAM_HUMAN)
			if #humans > 0 then
				owner = humans[math.random(#humans)]

				dmginfo:SetAttacker(owner)
			end
		end

		if ent:IsPlayer() and math.random(3) == 1 then
			ent:Ignite(6)
			for __, fire in pairs(ents.FindByClass("entityflame")) do
				if fire:IsValid() and fire:GetParent() == ent then
					fire:SetOwner(owner)
					fire:SetPhysicsAttacker(owner)
					fire.AttackerForward = owner
				end
			end
		end
	end
end

local trace = {mask = MASK_SHOT}
function ENT:Think()
	if self.PhysicsData then
		self:Hit(self.PhysicsData.HitPos, self.PhysicsData.HitNormal, self.PhysicsData.HitEntity, self.PhysicsData.OurOldVelocity)
	end

	if self:IsActive() then
		trace.start = self:GetPos()
		trace.endpos = trace.start + self:GetUp() * self.Range
		trace.filter = self:GetCachedScanFilter()
		local ent = util.TraceLine(trace).Entity
		if ent:IsValidLivingZombie() and ent:Health() > 0 then -- Maybe they died from another mine in the same spot...
			self:Explode()
		end
	end

	self:NextThink(CurTime())
	return true
end

function ENT:Explode()
	if self.Exploded then return end
	self.Exploded = true

	local pos = self:GetStartPos()

	self:FireBulletsLua(pos, self:GetUp(), 3, 3, self.ProjDamage or 26.67, self:GetOwner(), 0.01, "AR2Tracer", BulletCallback, nil, nil, nil, nil, self)

	self:EmitSound("npc/roller/mine/rmine_tossed1.wav", 75, 160)
	self:EmitSound("npc/scanner/cbot_energyexplosion1.wav", 80, 110, 0.5, CHAN_AUTO)

	util.ScreenShake(pos, 100, 5, 0.5, 100)

	local effectdata = EffectData()
		effectdata:SetOrigin(pos)
	util.Effect("HelicopterMegaBomb", effectdata, true, true)

	self:Remove()
end
