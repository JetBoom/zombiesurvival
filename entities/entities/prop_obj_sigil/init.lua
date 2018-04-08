AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)

	self:SetModel("models/d3/other/concrete_obelisc/concrete_obelisc.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
		phys:Wake()
	end

	self:SetSigilHealthBase(self.MaxHealth)
	self:SetSigilHealthRegen(self.HealthRegen)
	self:SetSigilLastDamaged(0)
end

function ENT:Think()
end

function ENT:Use(activator, caller)
	local currentSigil = self:GetSigilLetter()
	local sigils = ents.FindByClass("prop_obj_sigil")

	if IsValid(caller) and caller:IsPlayer() and caller:Team() == TEAM_HUMAN then
		for _, ent in pairs(sigils) do
			local sigilIndex = 0
			local nextSigilIndex = 0
			if currentSigil == ent:GetSigilLetter() then
				sigilIndex = _
				nextSigilIndex = sigilIndex + 1
			end
			if sigils[nextSigilIndex] ~= nil then
				caller:SetPos(sigils[nextSigilIndex]:GetPos())
				caller:SetBarricadeGhosting(true)
				self:EmitSound("friends/message.wav")
				sigils[nextSigilIndex]:EmitSound("friends/friend_online.wav")
			else
				if nextSigilIndex ~= 0 then
					caller:SetPos(sigils[1]:GetPos())

	if IsValid(caller) and caller:IsPlayer() then
		if caller:Team() ~= TEAM_UNDEAD then
			for _, ent in pairs(sigils) do
				local sigilIndex = 0
				local nextSigilIndex = 0
				if currentSigil == ent:GetSigilLetter() then
					sigilIndex = _
					nextSigilIndex = sigilIndex + 1
				end
				if sigils[nextSigilIndex] ~= nil then
					caller:SetPos(sigils[nextSigilIndex]:GetPos())
					caller:SetBarricadeGhosting(true)
					self:EmitSound("friends/message.wav")
					sigils[nextSigilIndex]:EmitSound("friends/friend_online.wav")
				else
					if nextSigilIndex ~= 0 then
						caller:SetPos(sigils[1]:GetPos())
						caller:SetBarricadeGhosting(true)
						self:EmitSound("friends/message.wav")
						sigils[1]:EmitSound("friends/friend_join.wav")
					end
				end
			end
		end
	end
end

function ENT:OnTakeDamage(dmginfo)
	if self:GetSigilHealth() <= 0 then return end

	local attacker = dmginfo:GetAttacker()
	if not (attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_UNDEAD and dmginfo:GetDamage() > 2) then return end

	local oldhealth = self:GetSigilHealth()
	self:SetSigilLastDamaged(CurTime())
	self:SetSigilHealthBase(oldhealth - dmginfo:GetDamage())

	if self:GetSigilHealth() <= 0 then
		self:SetSigilHealthBase(0)

		gamemode.Call("OnSigilDestroyed", self, dmginfo)

		self:Destroy()
	end
end

function ENT:Destroy()
	local effectdata = EffectData()
	effectdata:SetOrigin(self:LocalToWorld(self:OBBCenter()))
	util.Effect("Explosion", effectdata, true, true)

	self:Fire("kill", "", 0.01)
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end
