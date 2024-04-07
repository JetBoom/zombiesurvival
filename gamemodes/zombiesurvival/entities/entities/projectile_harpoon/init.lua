INC_SERVER()

function ENT:Initialize()
	self.Touched = {}
	self.OriginalAngles = self:GetAngles()

	self:SetModel("models/props_junk/harpoon002a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetupGenericProjectile(true)

	self:Fire("kill", "", 30)
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(35, 45))
	self.LastPhysicsUpdate = UnPredictedCurTime()
end

function ENT:PhysicsUpdate(phys)
	self.LastPhysicsUpdate = UnPredictedCurTime()
	local vel = phys:GetVelocity()
	phys:SetAngles(phys:GetVelocity():Angle())
	phys:SetVelocityInstantaneous(vel)
end

function ENT:Think()
	if self.PhysicsData then
		self:Hit(self.PhysicsData.HitPos, self.PhysicsData.HitNormal, self.PhysicsData.OurOldVelocity, self.PhysicsData.HitEntity)
	end

	self:NextThink(CurTime())
	return true
end

function ENT:Hit(vHitPos, vHitNormal, vel, hitent)
	if self.Done then return end
	self.Done = true

	local owner = self:GetOwner()

	if hitent and hitent:IsValid() and hitent:IsPlayer() then
		hitent:AddLegDamage(30)

		local ent = ents.Create("prop_harpoon")
		if ent:IsValid() then
			ent:SetPos(vHitPos)
			ent.BaseWeapon = self.BaseWeapon
			ent.BleedPerTick = 2
			ent:Spawn()
			ent:SetOwner(self:GetOwner())
			ent:SetParent(hitent)
			ent:SetAngles(self:GetAngles())
		end

		hitent:TakeSpecialDamage(self.ProjDamage or 45, DMG_GENERIC, owner, self, self:GetPos())
		hitent:EmitSound("npc/strider/strider_skewer1.wav", 70, 112)
	else
		local ang = self:GetAngles()
		ang:RotateAroundAxis(ang:Up(), 180)

		local ent = ents.Create("prop_weapon")
		if ent:IsValid() then
			ent:SetWeaponType(self.BaseWeapon)
			ent:SetPos(self:GetPos())
			ent:SetAngles(ang)
			ent:Spawn()

			if owner:IsValidHuman() then
				ent.NoPickupsTime = CurTime() + 15
				ent.NoPickupsOwner = self:GetOwner()
			end

			local physob = ent:GetPhysicsObject()
			if physob:IsValid() then
				physob:Wake()
				physob:SetVelocityInstantaneous(vel)
			end
		end

		self:EmitSound("physics/metal/metal_sheet_impact_bullet"..math.random(2)..".wav", 70, math.random(90, 95))
	end

	self:Remove()
end

function ENT:PhysicsCollide(data, phys)
	self.PhysicsData = data
	self:NextThink(CurTime())
end
