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
	for _, pl in pairs( player.GetAll() ) do
		if pl.SigilCoolDown ~= nil and pl.SigilCoolDown <= CurTime() then
			if pl:NearSigil() then
				self:TeleportPlayer(pl)
				pl.SigilCoolDown = nil
			end
		else
			if !pl:NearSigil() then
				pl.SigilCoolDown = nil
			end
		end
	end
end

function ENT:Use(activator, caller)
	caller.SigilCoolDown = CurTime() + 5
end

local function SigilTeleport(caller, currentsigil, index, first)
	local sigils = ents.FindByClass("prop_obj_sigil")
	local sigil = sigils[index]

	caller:ChatPrint(translate.Get("sigil_teleporting"))
	caller:SetPos(sigil:GetPos())
	
	caller:SetBarricadeGhosting(true)
	currentsigil:EmitSound("friends/message.wav")
	
	if first == true then
		sigil:EmitSound("friends/friend_join.wav")
		caller:SendLua("surface.PlaySound('friends/friend_join.wav')")
	else
		sigil:EmitSound("friends/friend_online.wav")
		caller:SendLua("surface.PlaySound('friends/friend_online.wav')")
	end
end

function ENT:TeleportPlayer(caller)
	local currentSigil = self:GetSigilLetter()
	local sigils = ents.FindByClass("prop_obj_sigil")
	
	if IsValid(caller) and caller:IsPlayer() then
		if caller.index == nil then caller.index = 0 end
		
		if caller:Team() ~= TEAM_UNDEAD then
			for _, sigil in pairs(sigils) do
				if sigil:GetSigilLetter() == self:GetSigilLetter() then
					caller.last_index = _
				end
			end
				
			caller.index = ( caller.index % #sigils ) + 1
			if caller.index == caller.last_index then 
				caller.index = ( caller.index % #sigils ) + 1
			end
			SigilTeleport(caller, self, caller.index, true)
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
