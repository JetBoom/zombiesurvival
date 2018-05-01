INC_SERVER()

ENT.TickTime = 0.5

function ENT:Initialize()
	self:DrawShadow(false)
	self:Fire("attack", "", self.TickTime)

	if self:GetRadius() == 0 then self:SetRadius(400) end
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	if key == "radius" then
		self:SetRadius(tonumber(value))
	end
end

function ENT:AcceptInput(name, activator, caller, arg)
	if name ~= "attack" then return end

	if GAMEMODE.ZombieEscape then
		return true
	end

	self:Fire("attack", "", self.TickTime)

	local vPos = self:GetPos()

	for _, ent in pairs(ents.FindInSphere(vPos, self:GetRadius())) do
		if ent and ent:IsValidLivingPlayer() and WorldVisible(vPos, ent:WorldSpaceCenter()) then
			if ent:Team() == TEAM_UNDEAD then
				if CurTime() >= (ent.LastRangedAttack or 0) + 3 then
					ent:GiveStatus("zombiespawnbuff", self.TickTime + 0.1)
				end
			elseif GAMEMODE:GetWave() ~= 0 then
				ent:GiveStatus("spawnslow", self.TickTime + 0.1)
			end
		end
	end

	return true
end
