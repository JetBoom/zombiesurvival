ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.m_NoNailUnfreeze = true
ENT.NoNails = true

ENT.WrenchRepairMultiplier = 0.25

ENT.Model = "models/roller.mdl"
ENT.HitBoxSize = 11.5
ENT.Mass = 50
ENT.WeaponClass = "weapon_zs_rollermine"
ENT.ControllerClass = "weapon_zs_rollerminecontrol"
ENT.AmmoType = "rollermine"

ENT.Acceleration = 900
ENT.MaxSpeed = 450
ENT.TurnSpeed = 30
ENT.IdleDrag = 0.25

ENT.MaxHealth = 225
ENT.HitCooldown = 1.15
ENT.HitDamage = 25
ENT.BounceFleshVelocity = 320

ENT.IgnoreBullets = true
ENT.IsShadeGrabbable = true
ENT.NoBlockExplosions = true

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

function ENT:SetObjectHealth(health)
	self:SetDTFloat(0, health)

	if health <= 0 and not self.Destroyed then
		self.Destroyed = true
	end
end

function ENT:BeingControlled()
	local owner = self:GetObjectOwner()
	if owner:IsValid() then
		local wep = owner:GetActiveWeapon()
		return wep:IsValid() and wep:GetClass() == self.ControllerClass and wep:GetDTBool(0)
	end

	return false
end

function ENT:GetObjectHealth()
	return self:GetDTFloat(0)
end

function ENT:SetMaxObjectHealth(health)
	self:SetDTFloat(1, health)
end

function ENT:GetMaxObjectHealth()
	return self:GetDTFloat(1)
end

local vecOffset = Vector(0, 0, -3)
function ENT:GetRedLightPos()
	return self:LocalToWorld(vecOffset)
end

function ENT:GetRedLightAngles()
	return self:GetAngles()
end
