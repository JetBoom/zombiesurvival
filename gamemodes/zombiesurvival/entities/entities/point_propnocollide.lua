ENT.Type = "point"

AccessorFunc(ENT, "m_fTimeOut", "TimeOut", FORCE_NUMBER)
AccessorFunc(ENT, "m_fExtraRadius", "ExtraRadius", FORCE_NUMBER)
AccessorFunc(ENT, "m_iTeam", "Team", FORCE_NUMBER)
AccessorFunc(ENT, "m_entProp", "Prop")

function ENT:Initialize()
	self:SetTimeOut(0)
	self:SetExtraRadius(8)
	self:SetProp(NULL)
end

function ENT:SetProp(ent)
	self.m_entProp = ent

	if not IsValid(ent) then return end

	for _, e in pairs(ents.FindByClass(self:GetClass())) do
		if e ~= self and e and e:IsValid() and e:GetProp() == ent then return end
	end

	local teamid = self:GetTeam()
	local inrad = false
	for _, pl in pairs(ents.FindInSphere(ent:LocalToWorld(ent:OBBCenter()), ent:BoundingRadius() / 2 + self:GetExtraRadius())) do
		if pl and pl:IsValid() and pl:IsPlayer() and pl:Alive() and (teamid == 0 or pl:Team() == teamid) then
			inrad = true
			break
		end
	end

	if not inrad then return end

	self.OldMaterial = ent:GetMaterial()
	self.OldCollisionGroup = ent:GetCollisionGroup()

	ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	ent:SetMaterial("models/spawn_effect")
end

function ENT:OnRemove()
	local ent = self:GetProp()
	if not IsValid(ent) then return end

	if self.OldMaterial then
		ent:SetMaterial(self.OldMaterial)
	end

	if self.OldCollisionGroup then
		ent:SetCollisionGroup(self.OldCollisionGroup)
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
	local teamid = self:GetTeam()
	local rate = 900 * FrameTime()
	local center = ent:LocalToWorld(ent:OBBCenter())

	for _, pl in pairs(ents.FindInSphere(center, ent:BoundingRadius() / 2 + self:GetExtraRadius())) do
		if pl and pl:IsValid() and pl:IsPlayer() and pl:Alive() and (teamid == 0 or pl:Team() == teamid) then
			pushout = true

			if timeout then
				if ent:IsBarricadeProp() and pl:Team() == TEAM_HUMAN then
					pl:SetBarricadeGhosting(true)
				end
			else
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
