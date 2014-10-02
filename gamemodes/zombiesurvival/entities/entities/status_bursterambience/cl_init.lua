include("shared.lua")

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:Initialize()
	self:DrawShadow(false)

	self.AmbientSound = CreateSound(self, "npc/zombie_poison/pz_breathe_loop2.wav")
	self.AmbientSound:PlayEx(0.55, 85)
end

function ENT:OnRemove()
	self.AmbientSound:Stop()
end

function ENT:Think()
	local owner = self:GetOwner()
	if owner:IsValid() then
		local wep = owner:GetActiveWeapon()
		if wep:IsValid() and wep.GetCharge and wep:GetCharge() > 0 then
			self.AmbientSound:Stop()
		else
			self.AmbientSound:PlayEx(0.55, 85 + math.sin(RealTime()))
		end
	end
end

function ENT:Draw()
	local owner = self:GetOwner()
	if owner:IsValid() then
		local wep = owner:GetActiveWeapon()
		if wep:IsValid() and wep.GetCharge then
			local charge = wep:GetCharge()
			if charge > 0 then
				
			end
		end
	end
end
