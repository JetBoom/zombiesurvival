include("shared.lua")

ENT.RenderGroup = RENDERGROUP_NONE

function ENT:Initialize()
	self:DrawShadow(false)

	self.AmbientSound = CreateSound(self, "npc/zombie_poison/pz_breathe_loop2.wav")
	self.AmbientSound:PlayEx(0.55, 85)
end

function ENT:OnRemove()
	self.AmbientSound:Stop()
end

function ENT:Think()
	owner = self:GetOwner()
	if owner:IsValid() then
		local wep = owner:GetActiveWeapon()
		if wep:IsValid() and wep.IsSwinging and wep:IsSwinging() then
			self.AmbientSound:Stop()
		else
			self.AmbientSound:PlayEx(0.55, 85 + math.sin(RealTime()))
		end
	end
end

function ENT:Draw()
end
