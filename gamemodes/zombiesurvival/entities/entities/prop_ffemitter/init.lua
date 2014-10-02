AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

ENT.m_Health = 150

function ENT:Initialize()
	self:SetModel("models/props_lab/lab_flourescentlight002b.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
		phys:Wake()
	end

	local ent = ents.Create("prop_ffemitterfield")
	if ent:IsValid() then
		self.Field = ent

		ent:SetPos(self:GetPos() + self:GetForward() * 48)
		ent:SetAngles(self:GetAngles())
		ent:SetOwner(self)
		ent:Spawn()
	end
end

function ENT:OnRemove()
	if self.Field and self.Field:IsValid() then
		self.Field:Remove()
	end
end

function ENT:OnTakeDamage(dmginfo)
	self:TakePhysicsDamage(dmginfo)

	if not self.Destroyed then
		local attacker = dmginfo:GetAttacker()
		if not (attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN) then
			if attacker.LifeBarricadeDamage ~= nil and self:HumanNearby() then
				attacker:AddLifeBarricadeDamage(dmginfo:GetDamage())
			end

			self.m_Health = self.m_Health - dmginfo:GetDamage()
			if self.m_Health <= 0 then
				self.Destroyed = true
				local effectdata = EffectData()
					effectdata:SetOrigin(self:LocalToWorld(self:OBBCenter()))
				util.Effect("Explosion", effectdata, true, true)
			end
		end
	end
end

function ENT:AltUse(activator, tr)
	self:PackUp(activator)
end

function ENT:OnPackedUp(pl)
	pl:GiveEmptyWeapon("weapon_zs_ffemitter")
	pl:GiveAmmo(1, "slam")

	pl:PushPackedItem(self:GetClass(), self.m_Health)

	self:Remove()
end

function ENT:Think()
	if self.Destroyed then
		self:Remove()
	end
end
