AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Think()
	-- First, all parent logic: ReviveTime, GodDisable, heal.
	-- BaseClass is available via ENT.Base = "status_revive_slump".
	self.BaseClass.Think(self)

	-- On top of that — our specifics: auto-initialization into a zombie.
	local owner = self:GetOwner()
	if not owner:IsValid() then return end

	local zombietime = self:GetZombieInitializeTime()
	if zombietime > 0 and CurTime() >= zombietime then
		self:SetZombieInitializeTime(0)

		if not owner:Alive() then
			owner:SecondWind()
			owner:TemporaryNoCollide()
		end
	end
end