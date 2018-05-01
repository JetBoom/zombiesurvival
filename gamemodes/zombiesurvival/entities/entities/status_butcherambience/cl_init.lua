INC_CLIENT()

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
			self.AmbientSound:PlayEx(0.6, 100 + math.Rand(-30, 30) + math.sin(RealTime() * 4) * 20)
		end
	end
end

function ENT:Draw()
end
