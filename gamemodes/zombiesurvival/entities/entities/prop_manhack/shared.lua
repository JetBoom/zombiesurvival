ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.m_NoNailUnfreeze = true
ENT.NoNails = true

ENT.WrenchRepairMultiplier = 0.5

ENT.Model = "models/manhack.mdl"
ENT.HitBoxSize = 9.5
ENT.Mass = 50
ENT.WeaponClass = "weapon_zs_manhack"
ENT.ControllerClass = "weapon_zs_manhackcontrol"
ENT.AmmoType = "manhack"

ENT.Acceleration = 320
ENT.MaxSpeed = 315
ENT.HoverSpeed = 64
ENT.HoverHeight = 48
ENT.HoverForce = 96
ENT.TurnSpeed = 305
ENT.IdleDrag = 1

ENT.MaxHealth = 75
ENT.HitCooldown = 0.15
ENT.HitDamage = 15
ENT.BounceFleshVelocity = 66
ENT.BounceVelocity = 50
ENT.SelfDamageSpeed = 0.7
ENT.SelfDamageMul = 0.08

function ENT:ShouldNotCollide(ent)
	return ent:IsPlayer() and ent:Team() == TEAM_HUMAN
end

function ENT:SetObjectHealth(health)
	self:SetDTFloat(0, health)

	if health <= 0 and not self.Destroyed then
		self.Destroyed = true
	end
end

function ENT:BeingControlled()
	local owner = self:GetOwner()
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

function ENT:GetRedLightPos()
	return self:LocalToWorld(Vector(0, 0, -3))
end

function ENT:GetRedLightAngles()
	return self:GetAngles()
end
