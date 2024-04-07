INC_SERVER()

function ENT:Initialize()
	self.Touched = {}
	self.Damaged = {}

	self:SetModel("models/Items/CrossbowRounds.mdl")
	self:PhysicsInitSphere(2)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetModelScale(0.5, 0)
	self:SetTrigger(true)
	self:SetupGenericProjectile(true)

	self:Fire("kill", "", 10)
end

function ENT:PhysicsCollide(data, phys)
	if self.Done or data.HitEntity.ZombieConstruction then return end
	if not self:HitFence(data, phys) then
		self.PhysicsData = data
		self.Done = true

		self:Fire("kill", "", 4)
		self:EmitSound("physics/metal/sawblade_stick"..math.random(3)..".wav", 75, 250)

		if hitent and hitent:IsValid() then
			local hitphys = hitent:GetPhysicsObject()
			if hitphys:IsValid() and hitphys:IsMoveable() then
				self.ParentEnt = hitent
			end
		end
	end
end

function ENT:PhysicsUpdate(phys)
	if not self.NoColl then
		local vel = self.PreVel or phys:GetVelocity()
		if self.PreVel then self.PreVel = nil end

		local velnorm = vel:GetNormalized()

		local ahead = (vel:LengthSqr() * FrameTime()) / 1200
		local fwd = velnorm * ahead
		local start = self:GetPos() - fwd
		local side = vel:Angle():Right() * GAMEMODE.ProjectileThickness

		local proj_trace = {mask = MASK_SHOT, filter = {self, team.GetPlayers(TEAM_HUMAN)}}

		proj_trace.start = start - side
		proj_trace.endpos = start - side + fwd

		local tr = util.TraceLine(proj_trace)

		proj_trace.start = start + side
		proj_trace.endpos = start + side + fwd

		local tr2 = util.TraceLine(proj_trace)
		local trs = {tr, tr2}

		for _, trace in pairs(trs) do
			if trace.Hit and not self.Touched[trace.Entity] then
				local ent = trace.Entity

				if ent:IsValidLivingZombie() or ent.ZombieConstruction then
					self.Touched[trace.Entity] = trace
				end

				break
			end
		end
	end
end

function ENT:Think()
	if self.Done and not self.NoColl then
		local data = self.PhysicsData
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableMotion(false)
		end

		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		self:SetPos(data.HitPos)
		self:SetAngles(data.HitNormal:Angle())

		if self.ParentEnt then
			self:SetParent(self.ParentEnt)
		end

		self.NoColl = true
	end

	self:NextThink(CurTime())

	-- Do this away from the StartTouch function. It has weird race condition issues I think.
	if table.Count(self.Damaged) >= 3 then return end

	local owner = self:GetOwner()
	if not owner:IsValid() then owner = self end
	local alt = self:GetDTBool(0)

	for ent, tr in pairs(self.Touched) do
		if table.Count(self.Damaged) < 3 and not self.Damaged[ent] then
			self.Damaged[ent] = true

			local damage = (self.ProjDamage or 81) / table.Count(self.Damaged)

			self:DealProjectileTraceDamage(damage, tr, owner)
			ent:EmitSound(math.random(2) == 1 and "weapons/crossbow/hitbod"..math.random(2)..".wav" or "ambient/machines/slicer"..math.random(4)..".wav", 75, 180)

			if alt then
				local status = ent:GiveStatus("zombiestrdebuff")
				status.DieTime = CurTime() + 5
				status.Applier = owner
			end

			util.Blood(ent:WorldSpaceCenter(), math.max(0, 20 - table.Count(self.Damaged) * 2), -self:GetForward(), math.Rand(100, 300), true)

			if ent.ZombieConstruction then
				self:Fire("kill", "", 0)
			end
		end
	end

	return true
end
