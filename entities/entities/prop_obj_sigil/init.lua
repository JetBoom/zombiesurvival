AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")
--models/props_wasteland/antlionhill.mdl
function ENT:Initialize()
	self:DrawShadow(false)
	self:SetModel("models/props_wasteland/medbridge_post01.mdl")
	util.ResizePhysics(self, 0.55)
	--self:SetModelScale(self:GetModelScale(), 0)
	--self:PhysicsInitBox(Vector(-1, -1, -1), Vector(1, 1, 48))
	--self:PhysicsInit(SOLID_VPHYSICS)
	--self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE)
	self:SetMoveType(MOVETYPE_NONE)

	--self:SetCollisionBounds(Vector(-0, -0, -0), Vector(0, 0, 48))

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
	if IsValid(caller) and caller:IsPlayer() then

											local i=0
											for _, ent in pairs(sigils) do
												local nextSigil = util.IncreaseLetter(currentSigil)
												if nextSigil == ent:GetSigilLetter() then
													caller:SetPos(ent:GetPos())
													caller:SetBarricadeGhosting(true)
													break
												end
												i = i + 1
											end
											if i == #sigils then
												for _, ent in pairs(sigils) do
													if ent:GetSigilLetter() == "A" then
														caller:SetPos(ent:GetPos())
														caller:SetBarricadeGhosting(true)
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
