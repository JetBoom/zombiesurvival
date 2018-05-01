GM.OverTheShoulder = false

local otscameraangles = Angle()
local otsdesiredright = 0
local staggerdir = VectorRand():GetNormalized()

function GM:UseOverTheShoulder()
	return self.OverTheShoulder and not engine.IsPlayingDemo()
end

function GM:ToggleOTSCamera()
	if self.OverTheShoulder then
		if otsdesiredright == -1 then
			otsdesiredright = 0
			self.OverTheShoulder = false
			otscameraangles.roll = 0
			MySelf:SetEyeAngles(otscameraangles)
		else
			otsdesiredright = -1
		end
	else
		self.OverTheShoulder = true
		otsdesiredright = 1
		otscameraangles = MySelf:EyeAngles()
	end
end

function GM:InputMouseApplyOTS(cmd, x, y, ang)
	otscameraangles.pitch = math.Clamp(math.NormalizeAngle(otscameraangles.pitch + y / 50), -89, 89)
	otscameraangles.yaw = math.NormalizeAngle(otscameraangles.yaw - x / 50)
	otscameraangles.roll = ang.roll
end

function GM:CreateMoveOTS(cmd)
	local maxhealth = MySelf:GetMaxHealth()
	local threshold = MySelf.HasPalsy and maxhealth - 1 or maxhealth * 0.25
	local health = MySelf:Health()
	local frightened = MySelf:GetStatus("frightened")
	local gunsway = MySelf.GunSway

	if (health <= threshold or frightened or gunsway) and not GAMEMODE.ZombieEscape then
		local ft = FrameTime()

		staggerdir = (staggerdir + ft * 8 * VectorRand()):GetNormalized()

		local ang = otscameraangles
		local rate = MySelf:GetRateOfPalsy(ft, frightened, health, threshold, gunsway)

		ang.pitch = math.NormalizeAngle(ang.pitch + staggerdir.z * rate)
		ang.yaw = math.NormalizeAngle(ang.yaw + staggerdir.x * rate)
		otscameraangles = ang
	end

	local offsetyaw = otscameraangles.yaw - cmd:GetViewAngles().yaw --ply:EyeAngles( ).y

	local corrected = Vector(cmd:GetForwardMove(), cmd:GetSideMove(), 0)
	local sign = cmd:GetForwardMove() < 0
	local length = corrected:Length()

	corrected = Angle(0, corrected:Angle().y - offsetyaw, 0):Forward()

	-- Not possible to get a perfect solution, but this is better.
	cmd:SetForwardMove(math.Clamp(corrected.x * length, sign and -length or 0, length))
	cmd:SetSideMove(corrected.y * length)
end

local trace_wall = {mask = MASK_SOLID_BRUSHONLY, mins = Vector(-3, -3, -3), maxs = Vector(3, 3, 3)}
local trace_crosshair = {mask = MASK_SHOT--[[, mins = Vector(-1, -1, -1), maxs = Vector(1, 1, 1)]]}
local maxdiff = 70

local myteam = 0
local function IgnoreTeam(ent)
	return not (ent:IsPlayer() and ent:Team() == myteam)
end
function GM:CalcViewOTS(pl, origin, angles, fov, znear, zfar)
	local camPos = origin - otscameraangles:Forward() * 28 + otsdesiredright * 12 * otscameraangles:Right() -- - otscameraangles:Up() * 2
	local eyepos = pl:EyePos()

	trace_wall.start = eyepos
	trace_wall.endpos = camPos
	trace_wall.filter = pl
	camPos = util.TraceHull(trace_wall).HitPos

	myteam = pl:Team()
	trace_crosshair.start = camPos
	trace_crosshair.endpos = camPos + otscameraangles:Forward() * 32768
	trace_crosshair.filter = IgnoreTeam
	local crosshair_tr = util.TraceLine(trace_crosshair)
	local crosshair_pos = crosshair_tr.HitPos
	local desired_angles = (crosshair_pos - eyepos):Angle()

	-- Don't face away more than a certain amount of degrees
	desired_angles.yaw = math.ApproachAngle(otscameraangles.yaw, desired_angles.yaw, maxdiff)

	pl:SetEyeAngles(desired_angles)

	origin:Set(camPos)
	angles:Set(otscameraangles)

	-- Let gamemode know if our LOS to crosshair target is blocked.
	trace_wall.start = eyepos
	trace_wall.endpos = crosshair_tr.HitPos
	GAMEMODE.LastOTSBlocked = util.TraceLine(trace_wall).Fraction <= 0.5
end
