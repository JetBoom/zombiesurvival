include("shared.lua")

ENT.RenderGroup = RENDERGROUP_NONE

function ENT:Initialize()
	self:DrawShadow(false)

	self.AmbientSound = CreateSound(self, "npc/antlion_guard/growl_idle.wav")
	self.AmbientSound:PlayEx(0.55, 110)
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
			self.AmbientSound:PlayEx(0.55, 110 + math.sin(RealTime()))
		end
	end
end

function ENT:Draw()
end
