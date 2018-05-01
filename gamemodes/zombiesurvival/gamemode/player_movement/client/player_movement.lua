--CACHED GLOBALS (TODO)
local TEAM_HUMAN = TEAM_HUMAN
local TEAM_UNDEAD = TEAM_UNDEAD
local math = math
local bit = bit
local IN_JUMP = IN_JUMP
local IN_DUCK = IN_DUCK
local IN_ZOOM = IN_ZOOM
local FrameTime = FrameTime
--

local staggerdir = VectorRand():GetNormalized()

local function PressingJump(cmd)
	return bit.band(cmd:GetButtons(), IN_JUMP) ~= 0
end

local function PressingDuck(cmd)
	return bit.band(cmd:GetButtons(), IN_DUCK) ~= 0
end

local function PressJump(cmd, press)
	if press then
		cmd:SetButtons(bit.bor(cmd:GetButtons(), IN_JUMP))
	elseif PressingJump(cmd) then
		cmd:SetButtons(cmd:GetButtons() - IN_JUMP)
	end
end

local function PressDuck(cmd, press)
	if press then
		cmd:SetButtons(bit.bor(cmd:GetButtons(), IN_DUCK))
	elseif PressingDuck(cmd) then
		cmd:SetButtons(cmd:GetButtons() - IN_DUCK)
	end
end

local TimeDuckHeld = 0
function GM:_CreateMove(cmd)
	if MySelf:IsPlayingTaunt() and MySelf:Alive() then
		self:CreateMoveTaunt(cmd)
		return
	end

	-- Don't allow jumping if our legs are damaged or we're pulse slowed
	if MySelf:GetLegDamage() >= 0.5 then
		PressJump(cmd, false)
	end

	-- Anti spaz out method A. Forces player to stay ducking until 0.5s after landing if they crouch in mid-air AND disables jumping during that time.
	if MySelf:Team() == TEAM_HUMAN or MySelf:GetZombieClassTable().CrouchedWalkSpeed ~= 1 then
		-- Forces duck to be held for 0.5s after pressing it if in mid-air
		if MySelf:OnGround() then
			TimeDuckHeld = 0
		elseif PressingDuck(cmd) then
			TimeDuckHeld = 0.9
		elseif TimeDuckHeld > 0 then
			TimeDuckHeld = TimeDuckHeld - FrameTime()
			PressDuck(cmd, true)
		end
	end

	local myteam = MySelf:Team()
	if myteam == TEAM_HUMAN then
		if MySelf:Alive() then
			local lockon = self.HumanMenuLockOn
			if lockon then
				if self:ValidMenuLockOnTarget(MySelf, lockon) and self.HumanMenuPanel and self.HumanMenuPanel:IsValid() and self.HumanMenuPanel:IsVisible() and MySelf:KeyDown(self.MenuKey) then
					local oldang = cmd:GetViewAngles()
					local newang = (lockon:EyePos() - EyePos()):Angle()
					--oldang.pitch = math.ApproachAngle(oldang.pitch, newang.pitch, FrameTime() * math.max(45, math.abs(math.AngleDifference(oldang.pitch, newang.pitch)) ^ 1.3))
					oldang.yaw = math.ApproachAngle(oldang.yaw, newang.yaw, FrameTime() * math.max(45, math.abs(math.AngleDifference(oldang.yaw, newang.yaw)) ^ 1.5))
					cmd:SetViewAngles(oldang)
				else
					self.HumanMenuLockOn = nil
				end
			else
				local maxhealth = MySelf:GetMaxHealth()
				local threshold = MySelf.HasPalsy and maxhealth - 1 or maxhealth * 0.25
				local health = MySelf:Health()
				local frightened = MySelf:GetStatus("frightened")
				local gunsway = MySelf.GunSway

				if (health <= threshold or frightened or gunsway) and not GAMEMODE.ZombieEscape then
					local ft = FrameTime()

					staggerdir = (staggerdir + ft * 8 * VectorRand()):GetNormalized()

					local ang = cmd:GetViewAngles()
					local rate = MySelf:GetRateOfPalsy(ft, frightened, health, threshold, gunsway)

					ang.pitch = math.NormalizeAngle(ang.pitch + staggerdir.z * rate)
					ang.yaw = math.NormalizeAngle(ang.yaw + staggerdir.x * rate)
					cmd:SetViewAngles(ang)
				end

				if self:UseOverTheShoulder() and not (MySelf.Revive and MySelf.Revive:IsValid()) and not (MySelf.KnockedDown and MySelf.KnockedDown:IsValid()) then
					self:CreateMoveOTS(cmd)
				end
			end
		end
	elseif myteam == TEAM_UNDEAD then
		local buttons = cmd:GetButtons()
		if bit.band(buttons, IN_ZOOM) ~= 0 then -- Zombies can't use this for anything
			cmd:SetButtons(buttons - IN_ZOOM)
		end

		MySelf:CallZombieFunction1("CreateMove", cmd)
	end
end
