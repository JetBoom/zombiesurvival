include("shared.lua")

ENT.RenderGroup = RENDERGROUP_NONE

function ENT:Initialize()
	self:DrawShadow(false)

	self.AmbientSound = CreateSound(self, "npc/fast_zombie/breathe_loop1.wav")
	self.AmbientSound:PlayEx(0.55, 100)
end

function ENT:OnRemove()
	self.AmbientSound:Stop()
end

function ENT:Think()
	owner = self:GetOwner()
	if owner:IsValid() then
		local wep = owner:GetActiveWeapon()
		if wep:IsValid() and (wep.IsSwinging and wep:IsSwinging() or wep.IsRoaring and wep:IsRoaring() or wep.IsClimbing and wep:IsClimbing() or wep.IsPouncing and wep:IsPouncing()) then
			self.AmbientSound:Stop()
		else
			self.AmbientSound:PlayEx(0.55, math.min(60 + owner:GetVelocity():Length2D() * 0.15, 100) + math.sin(RealTime()))
		end
	end
end

function ENT:Draw()
end
