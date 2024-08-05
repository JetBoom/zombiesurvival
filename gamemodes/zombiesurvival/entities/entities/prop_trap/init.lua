AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

ENT.LifeTime = 300

function ENT:Initialize()
	self.m_Health = 25

	self:SetModel(Model("models/props_lab/tpplug.mdl"))

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	self:SetTrigger(true)
	self.DieTime = CurTime() + self.LifeTime
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
		phys:Wake()
	end
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	if key == "lifetime" then
		value = tonumber(value)
		if not value then return end

		if value <= 0 then
			self.DieTime = -1
		else
			self.DieTime = CurTime() + value
		end
	end
end

function ENT:OnTakeDamage(dmginfo)
		local attacker = dmginfo:GetAttacker()
		if not (attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_UNDEAD) or attacker == self.Owner then
			self.Destroyed = true
			self.DieTime = 0
			local effectdata = EffectData()
			effectdata:SetOrigin(self:GetPos())
			util.Effect("bonemeshexplode", effectdata)
			util.Blood(self:GetPos(), 150, Vector(0, 0, 1), 300, true)
		end
	end
	
function ENT:Think()
	if self.DieTime >= 0 and self.DieTime <= CurTime() then
		self:Remove()
	end
end

function ENT:StartTouch(ent)
	if self.DieTime ~= 0 and ent:IsPlayer() and ent:Alive() then
		if ent:Team() == TEAM_HUMANS then
			self:TakeDamage( 100 )
			ent:GiveStatus("trap")
			ent:TakeSpecialDamage(10, DMG_CLUB, owner, self)
		end
	end
end
