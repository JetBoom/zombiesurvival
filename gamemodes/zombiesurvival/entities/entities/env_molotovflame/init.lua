INC_SERVER()

ENT.TickTime = 0.45
ENT.Ticks = 12
ENT.Damage = 7

function ENT:Initialize()
	self:DrawShadow(false)

	self:Fire("burn", "", self.TickTime)
	self:Fire("kill", "", self.TickTime * self.Ticks + 0.01)

	self:DropToFloor()
end

function ENT:AcceptInput(name, activator, caller, arg)
	if name ~= "burn" then return end

	self.Ticks = self.Ticks - 1

	local owner = self:GetOwner()
	if not owner:IsValidLivingHuman() then owner = self end

	local vPos = self:GetPos()
	-- We collect all entityflame once, then work by the index "parent → flames".
	local flamesByParent = {}
	for _, fire in pairs(ents.FindByClass("entityflame")) do
		if fire:IsValid() then
			local parent = fire:GetParent()
			if parent and parent:IsValid() then
				local list = flamesByParent[parent]
				if list then
					list[#list + 1] = fire
				else
					flamesByParent[parent] = { fire }
				end
			end
		end
	end

	for _, ent in pairs(ents.FindInSphere(vPos, self.Radius)) do
		if ent and (ent:IsValidLivingPlayer() and (ent:Team() == TEAM_UNDEAD or ent == owner)) and WorldVisible(vPos, ent:NearestPoint(vPos)) then
			ent:Ignite(2)

			local flames = flamesByParent[ent]
			if flames then
				for i = 1, #flames do
					local fire = flames[i]
					fire:SetOwner(owner)
					fire:SetPhysicsAttacker(owner)
					fire.AttackerForward = owner
				end
			end

			if owner:IsValidLivingHuman() then
				ent:AddLegDamage(7)
				ent:TakeSpecialDamage(self.Damage, DMG_BURN, owner, self)
			end
		end
	end

	if self.Ticks > 0 then
		self:Fire("burn", "", self.TickTime)
	end

	return true
end
