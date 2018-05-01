INC_SERVER()

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetNoDraw(true)

	self:PhysicsInitBox(self.BoxMin, self.BoxMax)

	self:SetCustomCollisionCheck(true)
	self:CollisionRulesChanged()

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
	end
end

function ENT:AltUse(activator, tr)
	self:PackUp(activator)
end

function ENT:OnPackedUp(pl)
	self:GetParent():OnPackedUp(pl)
end

function ENT:OnTakeDamage(dmginfo)
	if dmginfo:GetDamage() <= 0 then return end

	local attacker = dmginfo:GetAttacker()
	if not (attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN) then
		local parent = self:GetParent()
		if parent and parent:IsValid() then
			parent:SetObjectHealth(parent:GetObjectHealth() - dmginfo:GetDamage())
			parent:ResetLastBarricadeAttacker(attacker, dmginfo)
		end
	end
end
