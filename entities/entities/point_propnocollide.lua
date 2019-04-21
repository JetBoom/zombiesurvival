ENT.Type = "point"

AccessorFunc(ENT, "m_fTimeOut", "TimeOut", FORCE_NUMBER)
AccessorFunc(ENT, "m_fExtraRadius", "ExtraRadius", FORCE_NUMBER)
AccessorFunc(ENT, "m_iTeam", "Team", FORCE_NUMBER)
AccessorFunc(ENT, "m_entProp", "Prop")

ENT.PushRamp = 2.5

ENT.PushPeak = 0

function ENT:Initialize()
	self.PushPeak = CurTime() + self.PushRamp

	self:SetTimeOut(0)
	self:SetExtraRadius(8)
	self:SetProp(NULL)
end

function ENT:SetProp(ent)
	self.m_entProp = ent

	if not IsValid(ent) then return end

	for _, e in pairs(ents.FindByClass(self:GetClass())) do
		if e ~= self and e and e:IsValid() and e:GetProp() == ent then
			self.m_entProp = NULL
			return
		end
	end

	--local teamid = self:GetTeam()
	local inrad = false
	for _, pl in pairs(ents.FindInSphere(ent:LocalToWorld(ent:OBBCenter()), ent:BoundingRadius() / 2 + self:GetExtraRadius())) do
		if pl and pl:IsValidLivingPlayer() then --and (teamid == 0 or pl:Team() == teamid) then
			inrad = true
			break
		end
	end

	if not inrad then return end

	self.OldMaterial = ent:GetMaterial()
	ent.PreHoldCollisionGroup = ent.PreHoldCollisionGroup or ent:GetCollisionGroup()

	ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	ent:SetMaterial("models/spawn_effect")
end

function ENT:OnRemove()
	local ent = self:GetProp()
	if not IsValid(ent) then return end

	if self.OldMaterial then
		ent:SetMaterial(self.OldMaterial)
	end

	for _, e in pairs(ents.FindByClass("status_human_holding")) do
		if e:IsValid() and e:GetObject() == ent then
			return
		end
	end

	if ent.PreHoldCollisionGroup then
		ent:SetCollisionGroup(ent.PreHoldCollisionGroup)
	end
end

function ENT:Think()
	local ent = self:GetProp()
	if not IsValid(ent) then
		self:Remove()
		return
	end

	local pushout = false
	local timeout = self:GetTimeOut() > 0 and CurTime() >= self:GetTimeOut()
	--local teamid = self:GetTeam()
	local rate = 900 * FrameTime()
	local center = ent:LocalToWorld(ent:OBBCenter())

	rate = rate * math.Clamp(1 - (self.PushPeak - CurTime()) / self.PushRamp, 0, 1)

	for _, pl in pairs(ents.FindInSphere(center, ent:BoundingRadius() / 2 + self:GetExtraRadius())) do
		if pl and pl:IsValidLivingHuman() or (pl:IsPlayer() and pl:Team() == TEAM_UNDEAD and pl:GetZombieClassTable().Boss) then
			pushout = true

			if timeout then
				if ent:IsBarricadeProp() and pl:Team() == TEAM_HUMAN then
					pl:SetBarricadeGhosting(true)
				end
			elseif not pl:GetBarricadeGhosting() then
				local plpos = pl:LocalToWorld(pl:OBBCenter())
				local diff = plpos - center
				diff.z = 0
				diff:Normalize()
				local heading = diff * rate
				local starttrace = plpos + heading
				if util.TraceLine({start = starttrace, endpos = starttrace + Vector(0, 0, -80), mask = MASK_SOLID_BRUSHONLY}).Hit then
					pl:SetVelocity(heading)
				end
			end
		end
	end

	if not pushout or timeout then
		self:Remove()
	end

	self:NextThink(CurTime())
	return true
end
