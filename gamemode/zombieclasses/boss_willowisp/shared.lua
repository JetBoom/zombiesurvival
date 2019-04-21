CLASS.Name = "Wil O' Wisp"
CLASS.TranslationName = "class_wilowisp"
CLASS.Description = "description_wilowisp"
CLASS.Help = "controls_wilowisp"

CLASS.Boss = true

CLASS.KnockbackScale = 0

CLASS.FearPerInstance = 0.05

CLASS.Points = 20

CLASS.Model = Model("models/dav0r/hoverball.mdl")

CLASS.SWEP = "weapon_zs_special_wow"

CLASS.Health = 1000
CLASS.Speed = 240
CLASS.JumpPower = 0

CLASS.PainSounds = {Sound("npc/scanner/scanner_photo1.wav")}
CLASS.DeathSounds = {Sound("npc/scanner/scanner_electric2.wav")}

CLASS.Hull = {Vector(-6, -6, 0), Vector(6, 6, 12)}
CLASS.HullDuck = {Vector(-6, -6, 0), Vector(6, 6, 12)}
CLASS.ViewOffset = Vector(0, 0, 3)
CLASS.ViewOffsetDucked = Vector(0, 0, 3)
CLASS.CrouchedWalkSpeed = 1
CLASS.Mass = 40
--CLASS.Gravity = -0.0001

CLASS.NoGibs = true
CLASS.NoCollideAll = true
CLASS.NoFallDamage = true
CLASS.NoFallSlowdown = true

CLASS.BloodColor = BLOOD_COLOR_MECH

CLASS.CameraDistance = 64

--[[function CLASS:ShouldDrawLocalPlayer(pl)
	return true
end]]

function CLASS:PlayerFootstep(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	return true
end

function CLASS:CalcMainActivity(pl, velocity)
	return 1, -1
end

function CLASS:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	return true
end

function CLASS:DoAnimationEvent(pl, event, data)
	return ACT_INVALID
end

function CLASS:Move(pl, mv)
	pl:SetGroundEntity(NULL)

	mv:SetMaxSpeed(0)
	mv:SetMaxClientSpeed(0)

	local dir = Vector(mv:GetForwardSpeed(), mv:GetSideSpeed(), 0)
	dir:Normalize()
	if pl:KeyDown(IN_JUMP) then
		dir.z = 1
	end
	if pl:KeyDown(IN_DUCK) then
		dir.z = dir.z - 1
	end
	dir:Normalize()

	local vel = mv:GetVelocity()

	if dir == vector_origin then
		vel = vel * math.max(1 - FrameTime() * 0.75, 0)
	else
		local eyeang = mv:GetAngles()
		vel = vel + 260 * FrameTime() * (eyeang:Forward() * dir.x + eyeang:Right() * dir.y + eyeang:Up() * dir.z)
	end

	if vel:Length() >= self.Speed then
		vel:Normalize()
		vel = vel * self.Speed
	end

	vel.z = vel.z + FrameTime() * 590

	mv:SetVelocity(vel)

	return true
end
