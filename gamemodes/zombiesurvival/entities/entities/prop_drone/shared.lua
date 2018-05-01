ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.m_NoNailUnfreeze = true
ENT.NoNails = true
ENT.CanPackUp = true
ENT.PackUpTime = 0.25

ENT.WrenchRepairMultiplier = 0.666
ENT.MaxAmmo = 450

ENT.FirePitch = 0
ENT.FireYaw = 0

ENT.Acceleration = 170
ENT.MaxSpeed = 180
ENT.HoverSpeed = 40
ENT.HoverHeight = 92
ENT.HoverForce = 128
ENT.TurnSpeed = 55
ENT.IdleDrag = 0.25

ENT.MaxHealth = 190
ENT.GunRange = 275
ENT.CarryMass = 80

ENT.IgnoreBullets = true

ENT.PounceWeakness = 2
ENT.IsShadeGrabbable = true
ENT.FlyingControllable = true
ENT.NoBlockExplosions = true

ENT.DeployableAmmo = "drone"
ENT.SWEP = "weapon_zs_drone"
ENT.AmmoType = "smg1"

AccessorFuncDT(ENT, "ObjectOwner", "Entity", 0)

function ENT:ShouldNotCollide(ent)
	if not ent.ChargeTime and ent:IsProjectile() then
		local owner = ent:GetOwner()
		if owner:IsValidHuman() then
			return true
		end
	end

	return ent:IsPlayer() and ent:Team() == TEAM_HUMAN
end

function ENT:BeingControlled()
	local owner = self:GetObjectOwner()
	if owner:IsValid() then
		local wep = owner:GetActiveWeapon()
		return wep:IsValid() and wep:GetClass() == "weapon_zs_dronecontrol" and wep:GetDTBool(0)
	end

	return false
end

local M_Player = FindMetaTable("Player")
local P_Team = M_Player.Team
local temp_attacker
local function ManualTraceFilter(ent)
	if ent == temp_attacker or getmetatable(ent) == M_Player and P_Team(ent) == TEAM_HUMAN or ent.FHB or ent.IsCreeperNest then
		return false
	end

	return true
end

function ENT:GetTraceFilter()
	temp_attacker = self
	return ManualTraceFilter
end

local trace_manual = {mask = MASK_SHOT, filter = ManualTraceFilter}
function ENT:GetManualTrace()
	local owner = self:GetObjectOwner()
	local start = self:GetCameraPosition()

	trace_manual.start = start
	trace_manual.endpos = start + owner:GetAimVector() * (self.GunRange * (owner.DroneGunRangeMul or 1))

	temp_attacker = self

	return util.TraceLine(trace_manual)
end

function ENT:GetLocalAnglesToPos(pos)
	return self:WorldToLocalAngles(self:GetAnglesToPos(pos))
end

function ENT:GetAnglesToPos(pos)
	return (pos - self:GetRedLightPos()):Angle()
end

function ENT:CalculateFireAngles()
	local owner = self:GetObjectOwner()
	if not owner:IsValid() or self:GetMaterial() ~= "" then
		self.FireYaw = math.Approach(self.FireYaw, 0, FrameTime() * 60)
		self.FirePitch = math.Approach(self.FirePitch, 15, FrameTime() * 30)
		return
	end

	if owner:IsValidPlayer() and owner:GetActiveWeapon():IsValid() and owner:GetActiveWeapon():GetClass() == "weapon_zs_dronecontrol" then
		local ang = self:GetLocalAnglesToPos(self:GetManualTrace().HitPos)
		self.FireYaw = math.Clamp(math.NormalizeAngle(ang.yaw), -80, 80)
		self.FirePitch = math.Clamp(math.NormalizeAngle(ang.pitch), -45, 37.5)
	end
end

function ENT:GetGunAngles()
	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Right(), -self.FirePitch)
	ang:RotateAroundAxis(ang:Up(), self.FireYaw)
	return ang
end

function ENT.ScanFilter(ent)
	return not (ent:IsPlayer() or ent.ScanFilter or ent.GetNestMaxHealth)
end

local trace_cam = {mask = MASK_VISIBLE, mins = Vector(-4, -4, -4), maxs = Vector(4, 4, 4)}
function ENT:GetCameraPosition(angles)
	local owner = self:GetObjectOwner()
	if owner:IsValidPlayer() then
		angles = angles or owner:EyeAngles()
		trace_cam.start = self:GetPos()
		trace_cam.endpos = self:GetRedLightPos()
		trace_cam.filter = self.ScanFilter
		local tr = util.TraceHull(trace_cam)

		return tr.HitPos + tr.HitNormal * 3
	end

	return self:GetRedLightPos()
end

function ENT:GetObjectHealth()
	return self:GetDTFloat(0)
end

function ENT:GetMaxObjectHealth()
	return self:GetDTFloat(1)
end

function ENT:GetNextFire()
	return self:GetDTFloat(2)
end

function ENT:GetAmmo()
	return self:GetDTInt(0)
end

function ENT:IsFiring()
	return self:GetDTBool(0)
end

function ENT:GetRedLightPos()
	return self:LocalToWorld(Vector(3, 0, 13.75))
end
