AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("animations.lua")

include("shared.lua")

function SWEP:Think()
	if self.IdleAnimation and self.IdleAnimation <= CurTime() then
		self.IdleAnimation = nil
		self:SendWeaponAnim(ACT_VM_IDLE)
	end
	if self:GetIronsights() and not self.Owner:KeyDown(IN_ATTACK2) then
		self:SetIronsights(false)
	end
	
	if self.LastFired + self.ConeResetDelay > CurTime() then
		local multiplier = 1
		multiplier = multiplier + (self.ConeMax * 10) * ((self.LastFired + self.ConeResetDelay - CurTime()) / self.ConeResetDelay)
		self.ConeMul = math.min(multiplier, 10)
	end
end
