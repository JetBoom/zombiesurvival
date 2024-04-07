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

	self:RecalculateValidity()
end

function ENT:IsInsideProp()
	if self.GhostNotBarricadeProp then return false end

	local mycenter = self:WorldSpaceCenter()
	for _, ent in pairs(ents.FindInSphere(mycenter, self:BoundingRadius())) do
		if ent and ent ~= self and ent:IsValid() and ent:GetMoveType() == MOVETYPE_VPHYSICS and ent:GetSolid() > 0 then
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
		self:SetRotation(math.NormalizeAngle(owner:GetInfoNum("_zs_ghostrotation", 0)))
	end

	local rotation = self.GhostNoRotation and 0 or self:GetRotation()
	local eyeangles = owner:EyeAngles()
	local shootpos = owner:GetShootPos()
	local entity
	local tr = util.TraceLine({start = shootpos, endpos = shootpos + owner:GetAimVector() * 48, mask = MASK_SOLID_BRUSHONLY, filter = owner})

	if tr.HitWorld and not tr.HitSky or tr.HitNonWorld and self.GhostPlaceOnEntities then
		if self.GhostHitNormalOffset then
			tr.HitPos = tr.HitPos + tr.HitNormal * self.GhostHitNormalOffset
		end

		local rot = self.GhostRotation
		eyeangles = tr.HitNormal:Angle()
		eyeangles:RotateAroundAxis(eyeangles:Right(), rot.pitch)
		eyeangles:RotateAroundAxis(eyeangles:Up(), rot.yaw)
		eyeangles:RotateAroundAxis(eyeangles:Forward(), rot.roll)

		local valid = true
		if self.GhostLimitedNormal and tr.HitNormal.z < self.GhostLimitedNormal then
			valid = false
		elseif self.GhostDistance then
			for _, ent in pairs(ents.FindInSphere(tr.HitPos, self.GhostDistance)) do
				if ent and ent:IsValid() then
					if self.GhostEntityWildCard then
						if self.GhostEntityWildCard == ent:GetClass():sub(1, #self.GhostEntityWildCard) then
							valid = false
							break
						end
					elseif ent:GetClass() == self.GhostEntity then
						valid = false
						break
					end
				end
			end
		end

		if valid and self.GhostFlatGround and math.abs(tr.HitNormal.z) < 0.75 then
			local start = tr.HitPos + tr.HitNormal
			if not util.TraceLine({start = start, endpos = start + Vector(0, 0, -128), mask = MASK_SOLID_BRUSHONLY}).Hit then
				valid = false
			end
		end

		if valid and SERVER and GAMEMODE:EntityWouldBlockSpawn(self) then -- This isn't predicted but why would they be in the zombie spawn...
			valid = false
		end

		if valid then
			valid = self:CustomValidate(tr)
		end

		entity = tr.Entity

		self:SetValidPlacement(valid)
	else
		local rot = self.GhostNoTraceRot
		if rot then
			eyeangles:RotateAroundAxis(eyeangles:Right(), rot.pitch)
			eyeangles:RotateAroundAxis(eyeangles:Up(), rot.yaw)
			eyeangles:RotateAroundAxis(eyeangles:Forward(), rot.roll)
		end

		self:SetValidPlacement(false)
	end

	if tr.HitNormal.z >= 0.75 then
		eyeangles:RotateAroundAxis(eyeangles[self.GhostRotateFunction](eyeangles), owner:GetAngles().yaw + rotation)
	else
		eyeangles:RotateAroundAxis(eyeangles[self.GhostRotateFunction](eyeangles), rotation)
	end

	local pos, ang = tr.HitPos, eyeangles
	self:SetPos(pos)
	self:SetAngles(ang)

	if self:GetValidPlacement() and self:IsInsideProp() then
		self:SetValidPlacement(false)
	end

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
