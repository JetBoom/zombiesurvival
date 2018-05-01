INC_SERVER()

function SWEP:ThrowGibs()
	local owner = self:GetOwner()

	owner.LastRangedAttack = CurTime()

	local ent = ents.Create("projectile_doomcrab")
	if ent:IsValid() then
		ent:SetPos(owner:GetShootPos())
		ent:SetAngles(AngleRand())
		ent:SetOwner(owner)
		ent:Spawn()

		local phys = ent:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:SetVelocityInstantaneous(owner:GetAimVector() * 600)
			phys:AddAngleVelocity(VectorRand() * 360)
		end
	end
end

function SWEP:PoundAttackProcess()
	if CurTime() < self.PoundAttackStart + 0.4 then return end

	local owner = self:GetOwner()
	local pos = owner:GetPos() + Vector(0, 0, 2)

	owner:LagCompensation(true)

	owner:EmitSound("physics/concrete/concrete_break3.wav", 77, 70)

	util.ScreenShake(pos, 5, 5, 1, 300)

	local effectdata = EffectData()
		effectdata:SetOrigin(pos)
		effectdata:SetNormal(Vector(0, 0, 1))
	util.Effect("ThumperDust", effectdata, true, true)

	owner:GodEnable()
	util.BlastDamageEx(self, owner, pos, 112, 25, DMG_CLUB)
	util.BlastDamageEx(self, owner, pos, 22, 40, DMG_CLUB)
	owner:GodDisable()

	owner:LagCompensation(false)
end
