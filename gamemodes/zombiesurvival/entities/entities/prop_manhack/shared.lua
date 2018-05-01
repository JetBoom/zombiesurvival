ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.m_NoNailUnfreeze = true
ENT.NoNails = true

ENT.WrenchRepairMultiplier = 0.25

ENT.Model = "models/manhack.mdl"
ENT.HitBoxSize = 11.5
ENT.Mass = 50
ENT.WeaponClass = "weapon_zs_manhack"
ENT.ControllerClass = "weapon_zs_manhackcontrol"
ENT.AmmoType = "manhack"

ENT.Acceleration = 250
ENT.MaxSpeed = 230
ENT.HoverSpeed = 64
ENT.HoverHeight = 48
ENT.HoverForce = 64
ENT.TurnSpeed = 30
ENT.IdleDrag = 0.25

ENT.MaxHealth = 150
ENT.HitCooldown = 0.25
ENT.HitDamage = 17
ENT.BounceFleshVelocity = 33
ENT.BounceVelocity = 25
ENT.SelfDamageSpeed = 0.7
ENT.SelfDamageMul = 0.08

ENT.IgnoreBullets = true

--ENT.PounceWeakness = 3
ENT.IsShadeGrabbable = true
ENT.FlyingControllable = true
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
