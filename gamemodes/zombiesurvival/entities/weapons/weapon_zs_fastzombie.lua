AddCSLuaFile()

DEFINE_BASECLASS("weapon_zs_zombie")

SWEP.PrintName = "Fast Zombie"

SWEP.ViewModel = Model("models/weapons/v_fza.mdl")
SWEP.WorldModel = ""

if CLIENT then
	SWEP.ViewModelFOV = 70
end

SWEP.MeleeDelay = 0
SWEP.MeleeReach = 42
SWEP.MeleeDamage = 7 --8
SWEP.MeleeForceScale = 0.1
SWEP.MeleeSize = 4.5 --1.5
SWEP.MeleeDamageType = DMG_SLASH
SWEP.Primary.Delay = 0.32

SWEP.SlowMeleeDelay = 0.8
SWEP.SlowMeleeDamage = 18

SWEP.PounceDamage = 20
SWEP.PounceDamageVsPlayerMul = 0.2
SWEP.PounceDamageType = DMG_IMPACT
SWEP.PounceReach = 26
SWEP.PounceSize = 12
SWEP.PounceStartDelay = 0.5
SWEP.PounceDelay = 1.25
SWEP.PounceVelocity = 700

SWEP.RoarTime = 1.6

SWEP.Secondary.Automatic = false

SWEP.NextClimbSound = 0
SWEP.NextAllowPounce = 0
function SWEP:Think()
	BaseClass.Think(self)

	local curtime = CurTime()
	local owner = self:GetOwner()

	if self.NextAllowJump and self.NextAllowJump <= curtime then
		self.NextAllowJump = nil

		owner:ResetJumpPower()
	end

	if self:GetClimbing() then
		if self:GetClimbSurface() and owner:KeyDown(IN_ATTACK2) then
			if curtime >= self.NextClimbSound and IsFirstTimePredicted() then
				local speed = owner:GetVelocity():LengthSqr()
				if speed >= 2500 then
					if speed >= 10000 then
						self.NextClimbSound = curtime + 0.25
					else
						self.NextClimbSound = curtime + 0.8
					end

					self:PlayClimbSound()
				end
			end
		else
			self:StopClimbing()
		end
	end

	if self:IsSlowSwinging() then
		if curtime >= self:GetSlowSwingEnd() then
			self:SetSlowSwingEnd(0)

			if IsFirstTimePredicted() then
				self.MeleeAnimationMul = 1 / owner:GetMeleeSpeedMul()
				self:SendAttackAnim()

				local hit = false
				local traces = owner:CompensatedZombieMeleeTrace(self.MeleeReach, self.MeleeSize)
				local prehit = self.PreHit
				if prehit then
					local ins = true
					for _, tr in pairs(traces) do
						if tr.Entity == prehit.Entity then
							ins = false
							break
						end
					end
					if ins then
						local eyepos = owner:EyePos()
						if prehit.Entity:IsValid() and prehit.Entity:NearestPoint(eyepos):DistToSqr(eyepos) <= self.MeleeReach * self.MeleeReach then
							table.insert(traces, prehit)
						end
					end
					self.PreHit = nil
				end

				local damage = self:GetSlowSwingDamage(self:GetTracesNumPlayers(traces))

				for _, trace in ipairs(traces) do
					if not trace.Hit then continue end

					hit = true

					if trace.HitWorld then
						self:MeleeHitWorld(trace)
					else
						local ent = trace.Entity
						if ent and ent:IsValid() then
							self:MeleeHit(ent, trace, damage)
							if ent:IsPlayer() then
								self:MeleeHitPlayer(ent, trace, damage)
							end
						end
					end
				end

				if hit then
					self:PlayHitSound()
				else
					self:PlayMissSound()
				end
			end
		end
	elseif self:GetSwinging() then
		if not owner:KeyDown(IN_ATTACK) and self.SwingStop and self.SwingStop <= curtime then
			self:SetSwinging(false)
			self.SwingStop = nil

			self.RoarCheck = curtime + 0.1

			self:StopSwingingSound()
		end
	elseif self.RoarCheck then
		if self.RoarCheck <= curtime then
			self.RoarCheck = nil

			if owner:GetVelocity():Length2DSqr() <= 1 and owner:IsOnGround() then
				self:SetRoarEndTime(curtime + self.RoarTime)

				if IsFirstTimePredicted() then
					self:PlaySwingEndSound()
				end
			end
		end
	elseif self:GetPouncing() then
		if owner:IsOnGround() or owner:WaterLevel() >= 2 then
			self:StopPounce()
		else
			local dir = owner:GetAimVector()
			dir.z = math.Clamp(dir.z, -0.5, 0.9)
			dir:Normalize()

			local traces = owner:CompensatedZombieMeleeTrace(self.PounceReach, self.PounceSize, owner:WorldSpaceCenter(), dir)
			local damage = self:GetDamage(self:GetTracesNumPlayers(traces), self.PounceDamage)

			local hit = false
			for _, trace in ipairs(traces) do
				if not trace.Hit then continue end

				if trace.HitWorld then
					if trace.HitNormal.z < 0.8 then
						hit = true
						self:MeleeHitWorld(trace)
					end
				else
					local ent = trace.Entity
					if ent and ent:IsValid() then
						hit = true
						self:MeleeHit(ent, trace, damage * (ent:IsPlayer() and self.PounceDamageVsPlayerMul or ent.PounceWeakness or 1), ent:IsPlayer() and 1 or 10)
					end
				end
			end

			if hit then
				if IsFirstTimePredicted() then
					self:PlayPounceHitSound()
				end

				self:StopPounce()
			end
		end
	elseif self:GetPounceTime() > 0 and curtime >= self:GetPounceTime() then
		self:StartPounce()
	end

	self:NextThink(curtime)
	return true
end

function SWEP:PlayClimbSound()
	self:EmitSound("player/footsteps/metalgrate"..math.random(4)..".wav")
end

function SWEP:PlayPounceHitSound()
	self:EmitSound("physics/flesh/flesh_strider_impact_bullet1.wav")
	self:EmitSound("npc/fast_zombie/wake1.wav", nil, nil, nil, CHAN_AUTO)
end

function SWEP:PlaySwingEndSound()
	self:EmitSound("NPC_FastZombie.Frenzy")
end

function SWEP:MeleeHitPlayer(ent, trace, damage)
	ent:MeleeViewPunch(damage)
	local nearest = ent:NearestPoint(trace.StartPos)
	util.Blood(nearest, math.Rand(damage * 0.5, damage * 0.75), (nearest - trace.StartPos):GetNormalized(), math.Rand(damage * 5, damage * 10), true)
end

function SWEP:GetSlowSwingDamage(numplayers, basedamage)
	basedamage = basedamage or self.SlowMeleeDamage

	if numplayers then
		return basedamage * math.Clamp(1.2 - numplayers * 0.2, 0.5, 1)
	end

	return basedamage
end

function SWEP:Move(mv)
	if self:IsPouncing() or self:GetPounceTime() > 0 then
		mv:SetMaxSpeed(0)
		mv:SetMaxClientSpeed(0)
	elseif self:GetClimbing() then
		mv:SetMaxSpeed(0)
		mv:SetMaxClientSpeed(0)

		local owner = self:GetOwner()
		local tr = self:GetClimbSurface()
		local angs = owner:SyncAngles()
		local dir = tr and tr.Hit and (tr.HitNormal.z <= -0.5 and (angs:Forward() * -1) or math.abs(tr.HitNormal.z) < 0.75 and tr.HitNormal:Angle():Up()) or Vector(0, 0, 1)
		local vel = Vector(0, 0, 4)

		if owner:KeyDown(IN_FORWARD) then
			owner:SetGroundEntity(nil)
			vel = vel + dir * 250 --160
		end
		if owner:KeyDown(IN_BACK) then
			vel = vel + dir * -250 ---160
		end

		if vel.z == 4 then
			if owner:KeyDown(IN_MOVERIGHT) then
				vel = vel + angs:Right() * 100 --60
			end
			if owner:KeyDown(IN_MOVELEFT) then
				vel = vel + angs:Right() * -100 ---60
			end
		end

		mv:SetVelocity(vel)

		return true
	elseif self:GetSwinging() then
		mv:SetMaxSpeed(mv:GetMaxSpeed() * 0.6666)
		mv:SetMaxClientSpeed(mv:GetMaxClientSpeed() * 0.6666)
	elseif self:IsSlowSwinging() then
		mv:SetMaxSpeed(mv:GetMaxSpeed() * 0.85)
		mv:SetMaxClientSpeed(mv:GetMaxClientSpeed() * 0.85)
	end
end

function SWEP:MeleeHitEntity(ent, trace, damage, forcescale)
	BaseClass.MeleeHitEntity(self, ent, trace, damage, forcescale ~= nil and forcescale * 0.25)
end

local climblerp = 0
function SWEP:GetViewModelPosition(pos, ang)
	climblerp = math.Approach(climblerp, self:IsClimbing() and not self:IsSwinging() and 1 or 0, FrameTime() * ((climblerp + 1) ^ 3))
	ang:RotateAroundAxis(ang:Right(), 64 * climblerp)
	if climblerp > 0 then
		pos = pos + -8 * climblerp * ang:Up() + -12 * climblerp * ang:Forward()
	end

	return pos, ang
end

function SWEP:Swung()
	self.SwingStop = CurTime() + 0.5

	if not self:GetSwinging() then
		self:SetSwinging(true)

		self:StartSwingingSound()
	end

	BaseClass.Swung(self)
end

function SWEP:PrimaryAttack()
	if self:IsSlowSwinging() or self:IsPouncing() or self:GetPounceTime() > 0 then return end

	local owner = self:GetOwner()

	if self:IsClimbing() or owner:WaterLevel() >= 2 or owner:GetVelocity():LengthSqr() < 64 then
		BaseClass.PrimaryAttack(self)
	elseif CurTime() >= self:GetNextPrimaryFire() then
		local armdelay = owner:GetMeleeSpeedMul()

		self:SetNextPrimaryFire(CurTime() + (self.SlowMeleeDelay + 0.25) * armdelay)
		self:SetNextSecondaryFire(self:GetNextPrimaryFire() + 0.5)

		self:SetSlowSwingEnd(CurTime() + self.SlowMeleeDelay * armdelay)
		owner:DoAttackEvent()

		if IsFirstTimePredicted() then
			self:PlaySlowSwingSound()
		end

		self:StopSwingingSound()
		self:SetSwinging(false)

		local trace = self:GetOwner():CompensatedMeleeTrace(self.MeleeReach, self.MeleeSize)
		if trace.HitNonWorld then
			trace.IsPreHit = true
			self.PreHit = trace
		end

		self.IdleAnimation = CurTime() + self:SequenceDuration() * armdelay
	end
end

function SWEP:PlaySlowSwingSound()
	self:EmitSound("npc/fast_zombie/leap1.wav")
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
	if self:IsPouncing() or self:IsClimbing() or self:GetPounceTime() > 0 then return end

	if self:GetOwner():IsOnGround() then
		if CurTime() < self:GetNextPrimaryFire() or CurTime() < self:GetNextSecondaryFire() or CurTime() < self.NextAllowPounce then return end

		self:SetNextPrimaryFire(math.huge)
		self:SetPounceTime(CurTime() + self.PounceStartDelay)

		self:GetOwner():ResetJumpPower()

		if IsFirstTimePredicted() then
			self:PlayPounceStartSound()
		end
	elseif self:GetClimbSurface() then
		self:StartClimbing()
	end
end

function SWEP:StartClimbing()
	if self:GetClimbing() then return end

	self:SetClimbing(true)

	self:SetNextSecondaryFire(CurTime() + 0.5)
end

function SWEP:StopClimbing()
	if not self:GetClimbing() then return end

	self:SetClimbing(false)

	self:SetNextSecondaryFire(CurTime())
end

function SWEP:StartPounce()
	if self:IsPouncing() then return end

	self:SetPounceTime(0)

	local owner = self:GetOwner()
	if owner:IsOnGround() then
		self:SetPouncing(true)

		self.m_ViewAngles = owner:EyeAngles()

		if IsFirstTimePredicted() then
			self:PlayPounceSound()
		end

		local ang = owner:EyeAngles()
		ang.pitch = math.min(-20, ang.pitch)

		owner:SetGroundEntity(NULL)
		owner:SetVelocity((1 - 0.5 * (owner:GetLegDamage() / GAMEMODE.MaxLegDamage)) * self.PounceVelocity * ang:Forward())
		owner:SetAnimation(PLAYER_JUMP)
	else
		self:SetNextSecondaryFire(CurTime())
		self.m_ViewAngles = nil
		self.NextAllowJump = CurTime()
		self.NextAllowPounce = CurTime() + self.PounceDelay
		self:SetNextPrimaryFire(CurTime() + 0.1)
		self:GetOwner():ResetJumpPower()
	end
end

function SWEP:PlayPounceStartSound()
	self:EmitSound("npc/fast_zombie/leap1.wav", nil, nil, nil, CHAN_AUTO)
end

function SWEP:PlayPounceSound()
	self:EmitSound("NPC_FastZombie.Scream", nil, nil, nil, CHAN_AUTO)
end

function SWEP:StopPounce()
	if not self:IsPouncing() then return end

	self:SetPouncing(false)
	self:SetNextSecondaryFire(CurTime())
	self.m_ViewAngles = nil
	self.NextAllowJump = CurTime() + 0.25
	self.NextAllowPounce = CurTime() + self.PounceDelay
	self:SetNextPrimaryFire(CurTime() + 0.1)
	self:GetOwner():ResetJumpPower()
end

function SWEP:Reload()
	BaseClass.SecondaryAttack(self)
end

function SWEP:OnRemove()
	self.Removing = true

	local owner = self:GetOwner()
	if owner and owner:IsValid() then
		self:StopSwingingSound()
		owner:ResetJumpPower()
	end

	BaseClass.OnRemove(self)
end

function SWEP:Holster()
	local owner = self:GetOwner()
	if owner and owner:IsValid() then
		self:StopSwingingSound()
		owner:ResetJumpPower()
	end

	BaseClass.Holster(self)
end

function SWEP:ResetJumpPower(power)
	if self.Removing then return end

	if self.NextAllowJump and CurTime() < self.NextAllowJump or self:IsPouncing() or self:GetPounceTime() > 0 then
		return 1
	end
end

--[[function SWEP:CheckIdleAnimation()
end
SWEP.CheckAttackAnimation = SWEP.CheckIdleAnimation]]

function SWEP:CheckMoaning()
end
SWEP.StartMoaning = SWEP.CheckMoaning
SWEP.StopMoaning = SWEP.CheckMoaning
SWEP.StartMoaningSound = SWEP.CheckMoaning
SWEP.DoSwingEvent = SWEP.CheckMoaning

function SWEP:PlayHitSound()
	self:EmitSound("NPC_FastZombie.AttackHit", nil, nil, nil, CHAN_AUTO)
end

function SWEP:PlayMissSound()
	self:EmitSound("NPC_FastZombie.AttackMiss", nil, nil, nil, CHAN_AUTO)
end

function SWEP:PlayAttackSound()
end

function SWEP:PlayIdleSound()
	self:GetOwner():EmitSound("NPC_FastZombie.AlertFar")
	self:SetRoarEndTime(CurTime() + self.RoarTime)
end

function SWEP:PlayAlertSound()
	self:GetOwner():EmitSound("NPC_FastZombie.Frenzy")
	self:SetRoarEndTime(CurTime() + self.RoarTime)
end

function SWEP:StartSwingingSound()
	self:EmitSound("NPC_FastZombie.Gurgle")
end

function SWEP:StopSwingingSound()
	self:StopSound("NPC_FastZombie.Gurgle")
end

function SWEP:IsMoaning()
	return false
end

function SWEP:SetRoarEndTime(time)
	self:SetDTFloat(1, time)
end

function SWEP:GetRoarEndTime()
	return self:GetDTFloat(1)
end

function SWEP:IsRoaring()
	return CurTime() < self:GetRoarEndTime()
end

function SWEP:SetPounceTime(time)
	self:SetDTFloat(2, time)
end

function SWEP:GetPounceTime()
	return self:GetDTFloat(2)
end

function SWEP:SetPounceTime(time)
	self:SetDTFloat(2, time)
end

function SWEP:GetPounceTime()
	return self:GetDTFloat(2)
end

function SWEP:SetClimbing(climbing)
	self:SetDTBool(1, climbing)
end

function SWEP:GetClimbing()
	return self:GetDTBool(1)
end
SWEP.IsClimbing = SWEP.GetClimbing

function SWEP:SetSwinging(swinging)
	self:SetDTBool(2, swinging)
end

function SWEP:GetSwinging()
	return self:GetDTBool(2)
end

function SWEP:SetPouncing(leaping)
	self:SetDTBool(3, leaping)
end

function SWEP:SetSlowSwingEnd(time)
	self:SetDTFloat(3, time)
end

function SWEP:GetSlowSwingEnd()
	return self:GetDTFloat(3)
end

function SWEP:IsSlowSwinging()
	return self:GetSlowSwingEnd() > 0
end

function SWEP:GetPouncing()
	return self:GetDTBool(3)
end
SWEP.IsPouncing = SWEP.GetPouncing

if CLIENT then return end

function SWEP:Deploy()
	self:GetOwner():CreateAmbience("fastzombieambience")

	return BaseClass.Deploy(self)
end
