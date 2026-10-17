ENT.Type = "anim"
ENT.Base = "status__base"

ENT.GhostModel = Model("models/Combine_turrets/Floor_turret.mdl")
ENT.GhostRotation = Angle(270, 0, 0)
ENT.GhostEntity = "prop_gunturret"
ENT.GhostWeapon = "weapon_zs_gunturret"
ENT.GhostDistance = 64
ENT.GhostFlatGround = true
ENT.GhostRotateFunction = "Up"

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetMaterial("models/wireframe")
	self:SetModel(self.GhostModel)
	self:SetModelScale(self.GhostScale or 1)

	-- Static properties that do not change after Initialize.
	-- BoundingRadius depends on the model and the model scale already applied.
	self._GhostBoundingRadius     = self:BoundingRadius()
	self._GhostEntityWildCardLen  = self.GhostEntityWildCard and #self.GhostEntityWildCard or 0

	-- Caches for deduplicating network records.
	self._lastValid       = nil
	self._lastRotation    = nil
	self._lastSpawnPos    = nil
	self._lastSpawnBlocked = nil

	self:RecalculateValidity()
end

function ENT:IsInsideProp()
	-- Most ghosts (turrets, repair field, zapper) have
	-- GhostNotBarricadeProp set — exit before FindInSphere.
	if self.GhostNotBarricadeProp then return false end

	local mycenter = self:WorldSpaceCenter()
	local radius   = self._GhostBoundingRadius or self:BoundingRadius()

	for _, ent in pairs(ents.FindInSphere(mycenter, radius)) do
		if ent ~= self and ent:IsValid()
			and ent:GetMoveType() == MOVETYPE_VPHYSICS
			and ent:GetSolid() > 0 then

			local nearest = ent:NearestPoint(mycenter)
			if self:NearestPoint(nearest):DistToSqr(nearest) <= 144 then
				return true
			end
		end
	end

	return false
end

-- TODO: Rewrite this so it sets pos before the validation...
function ENT:RecalculateValidity()
	local owner = self:GetOwner()
	if not owner:IsValid() then return end

	if SERVER or MySelf == owner then
		local rotation = math.NormalizeAngle(owner:GetInfoNum("_zs_ghostrotation", 0))
		if rotation ~= self._lastRotation then
			self._lastRotation = rotation
			self:SetRotation(rotation)
		end
	end

	local rotation   = self.GhostNoRotation and 0 or self:GetRotation()
	local eyeangles  = owner:EyeAngles()
	local shootpos   = owner:GetShootPos()
	local entity
	local tr = util.TraceLine({
		start  = shootpos,
		endpos = shootpos + owner:GetAimVector() * 48,
		mask   = MASK_SOLID_BRUSHONLY,
		filter = owner,
	})

	if tr.HitWorld and not tr.HitSky or tr.HitNonWorld and self.GhostPlaceOnEntities then
		if self.GhostHitNormalOffset then
			tr.HitPos = tr.HitPos + tr.HitNormal * self.GhostHitNormalOffset
		end

		local rot = self.GhostRotation
		eyeangles = tr.HitNormal:Angle()
		eyeangles:RotateAroundAxis(eyeangles:Right(),   rot.pitch)
		eyeangles:RotateAroundAxis(eyeangles:Up(),      rot.yaw)
		eyeangles:RotateAroundAxis(eyeangles:Forward(), rot.roll)

		local valid = true

		if self.GhostLimitedNormal and tr.HitNormal.z < self.GhostLimitedNormal then
			valid = false
		elseif self.GhostDistance then
			-- Wildcard check without substring allocation.
			-- string.find(..., 1, true) == 1 is equivalent to cls:sub(1, len) == wc,
			-- but doesn't create a new string for every entity in the sphere.
			local wildcard    = self.GhostEntityWildCard
			local wildcardlen = self._GhostEntityWildCardLen

			for _, ent in pairs(ents.FindInSphere(tr.HitPos, self.GhostDistance)) do
				if ent:IsValid() then
					local cls = ent:GetClass()
					if wildcard then
						if string.find(cls, wildcard, 1, true) == 1 and wildcardlen == #wildcard then
							valid = false
							break
						end
					elseif cls == self.GhostEntity then
						valid = false
						break
					end
				end
			end
		end

		if valid and self.GhostFlatGround and math.abs(tr.HitNormal.z) < 0.75 then
			local start = tr.HitPos + tr.HitNormal
			if not util.TraceLine({
				start  = start,
				endpos = start + Vector(0, 0, -128),
				mask   = MASK_SOLID_BRUSHONLY,
			}).Hit then
				valid = false
			end
		end

		if valid and SERVER then
			-- GAMEMODE:EntityWouldBlockSpawn(self) iterates through ALL spawn points
			-- of the zombie team. Spawn points don't move, so we cache the result
			-- until self:GetPos() changes. And since the function reads
			-- GetPos() specifically (before SetPos in this same function), we cache by it as well.
			local curpos = self:GetPos()
			local last   = self._lastSpawnPos

			if not last
				or last.x ~= curpos.x
				or last.y ~= curpos.y
				or last.z ~= curpos.z then
				self._lastSpawnBlocked = GAMEMODE:EntityWouldBlockSpawn(self)
				self._lastSpawnPos     = Vector(curpos.x, curpos.y, curpos.z)
			end

			if self._lastSpawnBlocked then
				valid = false
			end
		end

		if valid then
			valid = self:CustomValidate(tr)
		end

		entity = tr.Entity

		if valid and self:IsInsideProp() then
			valid = false
		end

		if valid ~= self._lastValid then
			self._lastValid = valid
			self:SetValidPlacement(valid)
		end
	else
		local rot = self.GhostNoTraceRot
		if rot then
			eyeangles:RotateAroundAxis(eyeangles:Right(),   rot.pitch)
			eyeangles:RotateAroundAxis(eyeangles:Up(),      rot.yaw)
			eyeangles:RotateAroundAxis(eyeangles:Forward(), rot.roll)
		end

		if self._lastValid ~= false then
			self._lastValid = false
			self:SetValidPlacement(false)
		end
	end

	if tr.HitNormal.z >= 0.75 then
		eyeangles:RotateAroundAxis(
			eyeangles[self.GhostRotateFunction](eyeangles),
			owner:GetAngles().yaw + rotation
		)
	else
		eyeangles:RotateAroundAxis(
			eyeangles[self.GhostRotateFunction](eyeangles),
			rotation
		)
	end

	local pos, ang = tr.HitPos, eyeangles
	self:SetPos(pos)
	self:SetAngles(ang)

	return pos, ang, entity
end

function ENT:CustomValidate(tr)
	return true
end

function ENT:GetValidPlacement()
	return self:GetDTBool(0)
end

function ENT:SetValidPlacement(onoff)
	self:SetDTBool(0, onoff)
end

function ENT:GetRotation()
	return self:GetDTFloat(0)
end

function ENT:SetRotation(rotation)
	self:SetDTFloat(0, rotation)
end