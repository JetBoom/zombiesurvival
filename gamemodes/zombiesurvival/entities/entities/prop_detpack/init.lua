INC_SERVER()

local function RefreshDetpackOwners(pl)
	for _, ent in pairs(ents.FindByClass("prop_detpack")) do
		if ent:IsValid() and ent:GetOwner() == pl then
			ent:SetOwner(NULL)
		end
	end
end
hook.Add("PlayerDisconnected", "Detpack.PlayerDisconnected", RefreshDetpackOwners)
hook.Add("OnPlayerChangedTeam", "Detpack.OnPlayerChangedTeam", RefreshDetpackOwners)

ENT.NextBlip = 0

function ENT:Initialize()
	self.CreateTime = CurTime()

	self:SetModel("models/weapons/w_c4_planted.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
		phys:Wake()
	end

	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
end

function ENT:AltUse(activator, tr)
	self:PackUp(activator)
end

function ENT:OnTakeDamage(dmginfo)
	self:TakePhysicsDamage(dmginfo)

	if dmginfo:GetDamage() <= 0 then return end

	if not self.Exploded and dmginfo:GetDamage() >= 9 then
		local attacker = dmginfo:GetAttacker()
		if not (attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN) then
			self.ForceExplode = true
			self:Explode()
		end
	end
end

function ENT:Use(activator, caller)
	if self.Exploded or self:GetExplodeTime() ~= 0 or not activator:IsPlayer() or activator:Team() ~= TEAM_HUMAN or self:GetMaterial() ~= "" then return end

	if self:GetOwner() == activator or not self:GetOwner():IsValid() then
		self:SetOwner(activator)

		if not activator:HasWeapon("weapon_zs_detpackremote") then
			activator:Give("weapon_zs_detpackremote")
		end
		activator:SelectWeapon("weapon_zs_detpackremote")
	end
end

function ENT:Explode()
	if self.Exploded then return end
	self.Exploded = true

	local owner = self:GetOwner()
	if owner:IsValidHuman() then
		local pos = self:GetPos()

		util.BlastDamagePlayer(self, owner, pos, 256, 480, DMG_ALWAYSGIB)

		local effectdata = EffectData()
			effectdata:SetOrigin(pos)
			effectdata:SetNormal(self:GetUp() * -1)
		util.Effect("decal_scorch", effectdata)

		for i=1, 3 do
			self:EmitSound("npc/env_headcrabcanister/explosion.wav", 75 + i * 5, 100)
		end
		for i=1, 2 do
			ParticleEffect("dusty_explosion_rockets", pos, angle_zero)
		end
	end
end

function ENT:Think()
	if self.Exploded then
		self:Remove()
		return
	end

	if self:GetExplodeTime() ~= 0 then
		if CurTime() >= self:GetExplodeTime() then
			self:Explode()
		elseif self.NextBlip <= CurTime() then
			self.NextBlip = CurTime() + 0.4
			self:EmitSound("weapons/c4/c4_beep1.wav")
		end
	end

	self:NextThink(CurTime())
	return true
end

function ENT:OnPackedUp(pl)
	pl:GiveEmptyWeapon("weapon_zs_detpack")
	pl:GiveAmmo(1, "sniperpenetratedround")

	self:Remove()
end

function ENT:SetExplodeTime(time)
	if self.CreateTime + self.ArmTime > CurTime() then return end

	self:SetDTFloat(0, time)
end
