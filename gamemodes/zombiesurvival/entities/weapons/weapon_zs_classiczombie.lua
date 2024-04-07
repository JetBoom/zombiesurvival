AddCSLuaFile()

SWEP.Base = "weapon_zs_zombie"

SWEP.MeleeDamage = 25

function SWEP:Reload()
	self.BaseClass.SecondaryAttack(self)
end

function SWEP:StartMoaning()
end

function SWEP:StopMoaning()
end

function SWEP:IsMoaning()
	return false
end

SWEP.NextClimbSound = 0
function SWEP:Think()
	local owner = self:GetOwner()

	if self:GetClimbing() then
		if self:GetClimbSurface() and owner:KeyDown(IN_ATTACK2) then
			if SERVER and CurTime() >= self.NextClimbSound then
				local speed = owner:GetVelocity():LengthSqr()
				if speed >= 256 then
					if speed >= 2500 then
						self.NextClimbSound = CurTime() + 0.75
					else
						self.NextClimbSound = CurTime() + 1
					end
					owner:EmitSound("player/footsteps/metalgrate"..math.random(4)..".wav")
				end
			end
		else
			self:StopClimbing()
		end
	end

	return self.BaseClass.Think(self)
end

local climblerp = 0
function SWEP:GetViewModelPosition(pos, ang)
	climblerp = math.Approach(climblerp, self:IsClimbing() and 1 or 0, FrameTime() * ((climblerp + 1) ^ 3))
	ang:RotateAroundAxis(ang:Right(), 64 * climblerp)
	if climblerp > 0 then
		pos = pos + -8 * climblerp * ang:Up() + -12 * climblerp * ang:Forward()
	end

	return self.BaseClass.GetViewModelPosition(self, pos, ang)
end

function SWEP:PrimaryAttack()
	if self:IsClimbing() then return end

	self.BaseClass.PrimaryAttack(self)
end

local climbtrace = {mask = MASK_SOLID_BRUSHONLY, mins = Vector(-5, -5, -5), maxs = Vector(5, 5, 5)}
function SWEP:GetClimbSurface()
	local owner = self:GetOwner()

	local fwd = owner:SyncAngles():Forward()
	local up = owner:GetUp()
	local pos = owner:GetPos()
	local height = owner:OBBMaxs().z
	local tr
	local ha
	for i=5, height, 5 do
		if not tr or not tr.Hit then
			climbtrace.start = pos + up * i
			climbtrace.endpos = climbtrace.start + fwd * 36
			tr = util.TraceHull(climbtrace)
			ha = i
			if tr.Hit and not tr.HitSky then break end
		end
	end

	if tr.Hit and not tr.HitSky then
		climbtrace.start = pos + up * ha --tr.HitPos + tr.HitNormal
		climbtrace.endpos = climbtrace.start + owner:SyncAngles():Up() * (height - ha)
		local tr2 = util.TraceHull(climbtrace)
		if tr2.Hit and not tr2.HitSky then
			return tr2
		end

		return tr
	end
end

function SWEP:SecondaryAttack()
	if self:IsClimbing() then return end

	if not self:GetOwner():IsOnGround() and self:GetOwner():GetVelocity():LengthSqr() < 40000 and self:GetClimbSurface() then
		self:StartClimbing()
	else
		self.BaseClass.SecondaryAttack(self)
	end
end

function SWEP:StartClimbing()
	if self:GetClimbing() then return end

	self:SetClimbing(true)

	self:SetNextPrimaryFire(math.huge)
end

function SWEP:StopClimbing()
	if not self:GetClimbing() then return end

	self:SetClimbing(false)

	self:SetNextPrimaryFire(CurTime() + 0.5)
end

function SWEP:Move(mv)
	if self:GetClimbing() then
		mv:SetMaxSpeed(0)
		mv:SetMaxClientSpeed(0)

		local owner = self:GetOwner()
		local tr = self:GetClimbSurface()
		local angs = self:GetOwner():SyncAngles()
		local dir = tr and tr.Hit and (tr.HitNormal.z <= -0.5 and (angs:Forward() * -1) or math.abs(tr.HitNormal.z) < 0.75 and tr.HitNormal:Angle():Up()) or Vector(0, 0, 1)
		local vel = Vector(0, 0, 4)

		if owner:KeyDown(IN_FORWARD) then
			owner:SetGroundEntity(nil)
			vel = vel + dir * 60
		end
		if owner:KeyDown(IN_BACK) then
			vel = vel + dir * -60
		end

		if vel.z == 4 then
			if owner:KeyDown(IN_MOVERIGHT) then
				vel = vel + angs:Right() * 35
			end
			if owner:KeyDown(IN_MOVELEFT) then
				vel = vel + angs:Right() * -35
			end
		end

		mv:SetVelocity(vel)

		return true
	end
end

function SWEP:SetClimbing(climbing)
	self:SetDTBool(1, climbing)
end

function SWEP:GetClimbing()
	return self:GetDTBool(1)
end
SWEP.IsClimbing = SWEP.GetClimbing
