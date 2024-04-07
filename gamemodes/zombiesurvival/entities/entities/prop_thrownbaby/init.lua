INC_SERVER()

ENT.AlwaysProjectile = true -- Quick fix to stop people being able to use this as ammo to prop kill.

ENT.Created = 0

function ENT:Initialize()
	self:SetModel("models/props_c17/doll01.mdl")
	self:PhysicsInit(SOLID_VPHYSICS) --self:PhysicsInitBox(Vector(-10.8, -10.8, -10.8), Vector(10.8, 10.8, 10.8))
	self:SetModelScale(1.3, 0)
	self:SetCustomCollisionCheck(true)
	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
	self:CollisionRulesChanged()

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMass(1)
		phys:EnableMotion(true)
		phys:Wake()
	end

	self.Created = CurTime()

	self:Fire("kill", "", 20)
end

function ENT:Think()
	if not self:GetSettled() and CurTime() >= self.Created + 0.75 and self:GetVelocity():LengthSqr() <= 256 then
		self:SetSettled(true)
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

		net.Start("zs_nestbuilt")
		net.Broadcast()
	end
end

function ENT:OnTakeDamage(dmginfo)
	if dmginfo:GetDamage() <= 0 then return end

	local attacker = dmginfo:GetAttacker()
	if dmginfo:GetDamage() >= 1 and not (attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_UNDEAD) then
		self:Destroy()
	end
end

function ENT:Destroy()
	if self.Destroyed then return end
	self.Destroyed = true

	util.Blood(self:GetPos(), 5, Vector(0, 0, 1), 100, true)

	self:Fire("kill", "", 0.01)
end

function ENT:OnRemove()
	if self.Destroyed then
		self:EmitSound("ambient/voices/citizen_beaten"..math.random(5)..".wav", 70, math.random(140, 150))

		local ent = ents.Create("fakedeath")
		if ent:IsValid() then
			ent:SetModel("models/vinrax/player/doll_player.mdl")
			ent:SetPos(self:GetPos() + Vector(0, 0, 8))
			ent:Spawn()
			ent:SetModelScale(0.4, 0)

			ent:SetDeathSequence(ent:LookupSequence("death_0"..math.random(4)) or 1)
			ent:SetDeathAngles(Angle(0, math.Rand(0, 360), 0))
			ent:SetDeathSequenceLength(1)
		end
	end
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end
