AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Think()
	local owner = self:GetOwner()
	if not owner:IsValid() or not owner:Alive() then return end

	if owner:Team() ~= TEAM_HUMAN then self:Remove() return end

	if self:IsUnderwater() then
		if owner:WaterLevel() < 3 and not (owner.NoAirBrush and owner.NoAirBrush:IsValid()) then
			self:SetUnderwater(false)
		end
	elseif owner:WaterLevel() >= 3 or owner.NoAirBrush and owner.NoAirBrush:IsValid() then
		self:SetUnderwater(true)
	end

	if self:IsDrowning() then
		owner:TakeSpecialDamage(10, DMG_DROWN, game.GetWorld())

		self:NextThink(CurTime() + 1)
		return true
	elseif not self:IsUnderwater() and self:GetDrown() == 0 then
		self:Remove()
	end
end
