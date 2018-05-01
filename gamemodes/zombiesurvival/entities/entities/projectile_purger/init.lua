INC_SERVER()

function ENT:Initialize()
	self.Touched = {}
	self.Damaged = {}

	self:Fire("kill", "", 0.7)

	self:SetModel("models/Items/CrossbowRounds.mdl")
	self:PhysicsInitSphere(10)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetupGenericProjectile(false)
end

function ENT:Think()
	self:NextThink(CurTime())

	local owner = self:GetOwner()
	if not owner:IsValid() then owner = self end

	if table.Count(self.Damaged) >= 4 then return true end

	for ent, _ in pairs(self.Touched) do
		if not self.Damaged[ent] and ent:IsValidLivingHuman() then
			if ent:GetPoisonDamage() > 0 then
				self.Damaged[ent] = true
				owner:HealPlayer(ent, self.Heal, nil, nil, true)
			end

			for _,v in ipairs(GAMEMODE.ResistableStatuses) do
				if ent:GetStatus(v) then
					self.Damaged[ent] = true

					ent:RemoveStatus(v, false, true)
					owner:AddPoints(0.2)
				end
			end
		end
	end
	return true
end

function ENT:PhysicsCollide(data, phys)
	if self.Done then return end
	self.Done = true

	self:Fire("kill", "", 0.1)
	self:EmitSound("ambient/machines/steam_release_2.wav", 70, 175)
end

function ENT:StartTouch(ent)
	if self.Touched[ent] or not ent:IsValid() then return end

	local owner = self:GetOwner()
	if not owner:IsValid() then owner = self end

	if ent == owner or not ent:IsPlayer() then return end

	self.Touched[ent] = true
end
