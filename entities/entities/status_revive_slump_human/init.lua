AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Think()
	local fCurTime = CurTime()
	local owner = self:GetOwner()
	if owner:IsValid() then
		local zombietime = self:GetZombieInitializeTime()
		if zombietime > 0 and CurTime() >= zombietime then
			self:SetZombieInitializeTime(0)

			if not owner:Alive() then
				owner:SecondWind()
				owner:Freeze(true)
				owner:TemporaryNoCollide()
			end
		end

		if self:GetReviveTime() <= fCurTime then
			self:Remove()
			return
		end

		self.HealCarryOver = self.HealCarryOver + FrameTime() * 15
		if self.HealCarryOver >= 1 then
			local toheal = math.floor(self.HealCarryOver)
			owner:SetHealth(math.min(owner:GetMaxHealth(), owner:Health() + toheal))
			self.HealCarryOver = self.HealCarryOver - toheal
		end
	end

	self:NextThink(fCurTime)
	return true
end
