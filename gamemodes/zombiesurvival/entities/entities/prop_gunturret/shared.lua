ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_BOTH

ENT.SWEP = "weapon_zs_gunturret"

ENT.AmmoType = "smg1"
ENT.FireDelay = 0.1
ENT.NumShots = 1
ENT.Damage = 9.6
ENT.PlayLoopingShootSound = true
ENT.Spread = 2
ENT.SearchDistance = 768
ENT.MinimumAimDot = 0.5
ENT.DefaultAmmo = 0 --250
ENT.MaxAmmo = 1000
ENT.MaxHealth = 150
ENT.ModelScale = 1

ENT.NoReviveFromKills = true

ENT.PosePitch = 0
ENT.PoseYaw = 0

ENT.m_NoNailUnfreeze = true
ENT.NoNails = true
ENT.IgnoreBullets = true

ENT.CanPackUp = true

ENT.AlwaysGhostable = true

local HITGROUP_HEAD = HITGROUP_HEAD
local MASK_SOLID = MASK_SOLID

function ENT:GetLocalAnglesToTarget(target)
	return self:WorldToLocalAngles(self:GetAnglesToTarget(target))
end

function ENT:GetAnglesToTarget(target)
	return self:GetAnglesToPos(self:GetTargetPos(target))
end

function ENT:GetLocalAnglesToPos(pos)
	return self:WorldToLocalAngles(self:GetAnglesToPos(pos))
end

function ENT:GetAnglesToPos(pos)
	return (pos - self:ShootPos()):Angle()
end

function ENT:IsValidTarget(target)
	return target:IsPlayer() and target:Team() == TEAM_UNDEAD and target:Alive() and not target:GetZombieClassTable().NoTurretTarget and not target:GetStatus("zombiespawnbuff")
	and self:GetForward():Dot(self:GetAnglesToTarget(target):Forward()) >= self.MinimumAimDot
	and TrueVisibleFilters(self:ShootPos(), self:GetTargetPos(target), self, self.Hitbox)
end

local M_Player = FindMetaTable("Player")
local P_Team = M_Player.Team
local temp_attacker
local temp_hb
local function ManualTraceFilter(ent)
	if ent == temp_attacker or ent == temp_hb or getmetatable(ent) == M_Player and P_Team(ent) == TEAM_HUMAN then
		return false
	end

	return true
end

local trace_manual = {mask = MASK_SHOT, filter = ManualTraceFilter}
function ENT:GetManualTrace()
	local owner = self:GetObjectOwner()
	local start = self:ShootPos()

	trace_manual.start = start
	trace_manual.endpos = start + owner:GetAimVector() * self.SearchDistance * (owner.TurretRangeMul or 1)

	temp_attacker = self
	temp_hb = self:GetTurretHitbox()

	return util.TraceLine(trace_manual)
end

function ENT:CalculatePoseAngles()
	local deltatime = FrameTime()

	local owner = self:GetObjectOwner()
	if not owner:IsValid() or self:GetAmmo() <= 0 or self:GetMaterial() ~= "" then
		self.PoseYaw = math.Approach(self.PoseYaw, 0, deltatime * 60)
		self.PosePitch = math.Approach(self.PosePitch, 15, deltatime * 30)
		return
	end

	if self:GetManualControl() then
		local ang = self:GetLocalAnglesToPos(self:GetManualTrace().HitPos)
		self.PoseYaw = math.Approach(self.PoseYaw, math.Clamp(math.NormalizeAngle(ang.yaw), -60, 60), deltatime * 140)
		self.PosePitch = math.Approach(self.PosePitch, math.Clamp(math.NormalizeAngle(ang.pitch), -15, 15), deltatime * 140)
	else
		local target = self:GetTarget()
		local angm = self:GetScanMaxAngle()
		if target:IsValid() then
			local ang = self:GetLocalAnglesToTarget(target)
			self.PoseYaw = math.Approach(self.PoseYaw, math.Clamp(math.NormalizeAngle(ang.yaw), -60 * angm, 60 * angm), deltatime * 140)
			self.PosePitch = math.Approach(self.PosePitch, math.Clamp(math.NormalizeAngle(ang.pitch), -15 * angm, 15 * angm), deltatime * 100)
		else
			local ct = CurTime() * self:GetScanSpeed()
			self.PoseYaw = math.Approach(self.PoseYaw, math.sin(ct) * 45 * angm, deltatime * 60)
			self.PosePitch = math.Approach(self.PosePitch, math.cos(ct * 1.4) * 15 * angm, deltatime * 30)
		end
	end
end

function ENT:GetScanFilter()
	local filter = team.GetPlayers(TEAM_HUMAN)
	filter[#filter + 1] = self
	filter[#filter + 1] = self:GetTurretHitbox()
	for  _, pl in pairs(team.GetPlayers(TEAM_UNDEAD)) do
		if pl:GetZombieClassTable().NoTurretTarget then
			filter[#filter + 1] = pl
		end
	end
	-- TODO: Cache this, should be relatively okay right now with just 1 second caches though.
	table.Add(filter, ents.FindByClass("prop_ffemitterfield"))
	return filter
end

-- Getting all of some team is straining every frame when there's 5 or so turrets.
local NextCache = 0
function ENT:GetCachedScanFilter()
	if CurTime() < NextCache and self.CachedFilter then return self.CachedFilter end

	self.CachedFilter = self:GetScanFilter()
	NextCache = CurTime() + 1

	return self.CachedFilter
end

function ENT:GetTargetPos(target)
	if not (target:IsPlayer() and target:GetZombieClassTable().NoHead) then
		local boneid = target:GetHitBoxBone(HITGROUP_HEAD, 0)
		if boneid and boneid > 0 then
			local bp = target:GetBonePositionMatrixed(boneid)
			if bp then
				return bp
			end
		end
	end

	return target:WorldSpaceCenter()
end

function ENT:HumanHoldable()
	return true
end

function ENT:DefaultPos()
	return self:GetPos() + self:GetUp() * 55
end

function ENT:ShootPos()
	local attachid = self:LookupAttachment("eyes")
	if attachid then
		local attach = self:GetAttachment(attachid)
		if attach then return attach.Pos end
	end

	return self:DefaultPos()
end

function ENT:LaserPos()
	local attachid = self:LookupAttachment("light")
	if attachid then
		local attach = self:GetAttachment(attachid)
		if attach then return attach.Pos end
	end

	return self:DefaultPos()
end
ENT.LightPos = ENT.LaserPos

function ENT:GetGunAngles()
	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Right(), -self.PosePitch)
	ang:RotateAroundAxis(ang:Up(), self.PoseYaw)
	return ang
end

function ENT:GetAmmo()
	return self:GetDTInt(0)
end

function ENT:GetObjectHealth()
	return self:GetDTFloat(3)
end

function ENT:GetMaxObjectHealth()
	return self:GetDTInt(1)
end

function ENT:GetChannel()
	return self:GetDTInt(2)
end

function ENT:GetTarget()
	return self:GetDTEntity(0)
end

function ENT:GetObjectOwner()
	return self:GetDTEntity(1)
end

function ENT:GetTurretHitbox()
	return self:GetDTEntity(2)
end

function ENT:GetTargetReceived()
	return self:GetDTFloat(0)
end

function ENT:GetTargetLost()
	return self:GetDTFloat(1)
end

function ENT:GetNextFire()
	return self:GetDTFloat(2)
end

function ENT:GetScanSpeed()
	return self:GetDTFloat(4)
end

function ENT:GetScanMaxAngle()
	return self:GetDTFloat(5)
end

function ENT:IsFiring()
	return self:GetDTBool(0)
end

function ENT:GetManualControl()
	local owner = self:GetObjectOwner()
	if owner:IsValid() and owner:Alive() and owner:Team() == TEAM_HUMAN then
		local wep = owner:GetActiveWeapon()
		if wep:IsValid() and wep:GetClass() == "weapon_zs_gunturretcontrol" and wep.GetTurret and wep:GetTurret() == self and wep:GetDTBool(0) then
			return true
		end
	end

	return false
end

util.PrecacheSound("npc/turret_floor/die.wav")
util.PrecacheSound("npc/turret_floor/active.wav")
util.PrecacheSound("npc/turret_floor/deploy.wav")
util.PrecacheSound("npc/turret_floor/shoot1.wav")
util.PrecacheSound("npc/turret_floor/shoot2.wav")
util.PrecacheSound("npc/turret_floor/shoot3.wav")
