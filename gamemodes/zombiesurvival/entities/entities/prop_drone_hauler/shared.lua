ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.m_NoNailUnfreeze = true
ENT.NoNails = true
ENT.CanPackUp = true
ENT.PackUpTime = 0.25

ENT.WrenchRepairMultiplier = 0.666

ENT.FirePitch = 0
ENT.FireYaw = 0

ENT.Acceleration = 350
ENT.MaxSpeed = 400
ENT.HoverSpeed = 40
ENT.HoverHeight = 92
ENT.HoverForce = 128
ENT.TurnSpeed = 90
ENT.IdleDrag = 0.25

ENT.MaxHealth = 190
ENT.CarryMass = 150

ENT.IgnoreBullets = true

ENT.PounceWeakness = 2
ENT.IsShadeGrabbable = true
ENT.FlyingControllable = true
ENT.NoBlockExplosions = true

ENT.DeployableAmmo = "drone_hauler"
ENT.SWEP = "weapon_zs_drone_hauler"

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

function ENT:IsGrappling()
	return self:GetDTBool(1)
end

function ENT:GetRedLightPos()
	return self:LocalToWorld(Vector(2, -6, 2))
end
