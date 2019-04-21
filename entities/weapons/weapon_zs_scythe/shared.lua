SWEP.PrintName = "Great Scythe"
SWEP.Description = "A great scythe that can pierce and cut through multiple zombies. Has a 3 hit combo, the last hit deals extra damage."

SWEP.Base = "weapon_zs_basemelee"

SWEP.HoldType = "melee2"

SWEP.DamageType = DMG_CLUB

SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.UseHands = true

SWEP.MeleeDamage = 97.5
SWEP.MeleeRange = 75
SWEP.MeleeSize = 3.5
SWEP.MeleeKnockBack = 0

SWEP.Primary.Delay = 1.4

SWEP.WalkSpeed = SPEED_SLOWER

SWEP.SwingRotation = Angle(0, -120, -70)
SWEP.SwingOffset = Vector(0, 30, -40)
SWEP.SwingTime = 0.35
SWEP.SwingHoldType = "melee"

SWEP.Tier = 4
SWEP.MaxStock = 3

SWEP.AllowQualityWeapons = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.12)

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(55, 65))
end

function SWEP:PlayHitSound()
	self:EmitSound("ambient/machines/slicer"..math.random(4)..".wav", 75, 90)
	self:EmitSound("physics/metal/metal_computer_impact_hard2.wav", 65, 90, 0.5, CHAN_WEAPON + 1)
end

function SWEP:GetTracesNumPlayers(traces)
	local numplayers = 0

	local ent
	for _, trace in pairs(traces) do
		ent = trace.Entity
		if ent and ent:IsValidPlayer() then
			numplayers = numplayers + 1
		end
	end

	return numplayers
end

function SWEP:GetDamage(numplayers, basedamage)
	basedamage = basedamage or self.MeleeDamage

	if numplayers then
		return basedamage * math.Clamp(1.25 - numplayers * 0.25, 0.5, 1)
	end

	return basedamage
end

function SWEP:MeleeSwing()
	local owner = self:GetOwner()
	local combo = self:GetDTInt(10)

	owner:DoAttackEvent()
	self:SendWeaponAnim(self.MissAnim)
	self.IdleAnimation = CurTime() + self:SequenceDuration()

	local hit = false
	local tr = owner:CompensatedPenetratingMeleeTrace(self.MeleeRange * (owner.MeleeRangeMul or 1), self.MeleeSize)
	local damage = self:GetDamage(self:GetTracesNumPlayers(tr))
	local ent

	local damagemultiplier = owner:Team() == TEAM_HUMAN and owner.MeleeDamageMultiplier or 1 --(owner.BuffMuscular and owner:Team()==TEAM_HUMAN) and 1.2 or 1
	if owner:IsSkillActive(SKILL_LASTSTAND) then
		if owner:Health() <= owner:GetMaxHealth() * 0.25 then
			damagemultiplier = damagemultiplier * 2
		else
			damagemultiplier = damagemultiplier * 0.85
		end
	end

	if combo == 2 then
		damagemultiplier = damagemultiplier * 1.35
	end

	for _, trace in ipairs(tr) do
		if not trace.Hit then continue end

		ent = trace.Entity

		hit = true

		local hitflesh = trace.MatType == MAT_FLESH or trace.MatType == MAT_BLOODYFLESH or trace.MatType == MAT_ANTLION or trace.MatType == MAT_ALIENFLESH

		if hitflesh then
			util.Decal(self.BloodDecal, trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal)

			if SERVER then
				self:ServerHitFleshEffects(ent, trace, damagemultiplier)
			end

		end

		if ent and ent:IsValid() then
			if SERVER then
				self:ServerMeleeHitEntity(trace, ent, damagemultiplier)
			end

			self:MeleeHitEntity(trace, ent, damagemultiplier, damage)

			if SERVER then
				self:ServerMeleePostHitEntity(trace, ent, damagemultiplier)
			end

			if owner.GlassWeaponShouldBreak then break end
		end
	end

	if hit then
		self:PlayHitSound()
	else
		self:PlaySwingSound()

		if owner.MeleePowerAttackMul and owner.MeleePowerAttackMul > 1 then
			self:SetPowerCombo(0)
		end
	end

	local armdelay = owner:GetMeleeSpeedMul()
	self:SetNextPrimaryFire(CurTime() +
		self.Primary.Delay * (combo < 2 and 0.36 or 1.25) * armdelay
	)

	self:SetDTInt(10, combo >= 2 and 0 or combo + 1)
end

function SWEP:MeleeHitEntity(tr, hitent, damagemultiplier, damage)
	if not IsFirstTimePredicted() then return end

	local owner = self:GetOwner()

	if SERVER and hitent:IsPlayer() and owner:IsSkillActive(SKILL_GLASSWEAPONS) then
		damagemultiplier = damagemultiplier * 3.5
		owner.GlassWeaponShouldBreak = not owner.GlassWeaponShouldBreak
	end

	damage = damage * damagemultiplier

	local dmginfo = DamageInfo()
	dmginfo:SetDamagePosition(tr.HitPos)
	dmginfo:SetAttacker(owner)
	dmginfo:SetInflictor(self)
	dmginfo:SetDamageType(self.DamageType)
	dmginfo:SetDamage(damage)
	dmginfo:SetDamageForce(math.min(self.MeleeDamage, 50) * 50 * owner:GetAimVector())

	local vel
	if hitent:IsPlayer() then

		if owner.MeleePowerAttackMul and owner.MeleePowerAttackMul > 1 then
			self:SetPowerCombo(self:GetPowerCombo() + 1)

			damage = damage + damage * (owner.MeleePowerAttackMul - 1) * (self:GetPowerCombo()/4)
			dmginfo:SetDamage(damage)

			if self:GetPowerCombo() >= 4 then
				self:SetPowerCombo(0)
				if SERVER then
					local pitch = math.Clamp(math.random(90, 110) + 15 * (1 - damage/45), 50 , 200)
					owner:EmitSound("npc/strider/strider_skewer1.wav", 75, pitch)
				end
			end
		end

		hitent:MeleeViewPunch(damage)
		if hitent:IsHeadcrab() then
			damage = damage * 2
			dmginfo:SetDamage(damage)
		end

		if SERVER then
			hitent:SetLastHitGroup(tr.HitGroup)
			if tr.HitGroup == HITGROUP_HEAD then
				hitent:SetWasHitInHead()
			end

			if hitent:WouldDieFrom(damage, tr.HitPos) then
				dmginfo:SetDamageForce(math.min(self.MeleeDamage, 50) * 400 * owner:GetAimVector())
			end
		end

		vel = hitent:GetVelocity()
	else
		if owner.MeleePowerAttackMul and owner.MeleePowerAttackMul > 1 then
			self:SetPowerCombo(0)
		end
	end

	--if not hitent.LastHeld or CurTime() >= hitent.LastHeld + 0.1 then -- Don't allow people to shoot props out of their hands
		if self.PointsMultiplier then
			POINTSMULTIPLIER = self.PointsMultiplier
		end

		hitent:DispatchTraceAttack(dmginfo, tr, owner:GetAimVector())

		if self.PointsMultiplier then
			POINTSMULTIPLIER = nil
		end

		-- Invalidate the engine knockback vs. players
		if vel then
			hitent:SetLocalVelocity(vel)
		end
	--end

	-- Perform our own knockback vs. players
	if hitent:IsPlayer() then
		local knockback = self.MeleeKnockBack * (owner.MeleeKnockbackMultiplier or 1)
		if knockback > 0 then
			hitent:ThrowFromPositionSetZ(tr.StartPos, knockback, nil, true)
		end

		if owner.MeleeLegDamageAdd and owner.MeleeLegDamageAdd > 0 then
			hitent:AddLegDamage(owner.MeleeLegDamageAdd)
		end
	end

	local effectdata = EffectData()
	effectdata:SetOrigin(tr.HitPos)
	effectdata:SetStart(tr.StartPos)
	effectdata:SetNormal(tr.HitNormal)
	util.Effect("RagdollImpact", effectdata)
	if not tr.HitSky then
		effectdata:SetSurfaceProp(tr.SurfaceProps)
		effectdata:SetDamageType(self.DamageType)
		effectdata:SetHitBox(tr.HitBox)
		effectdata:SetEntity(hitent)
		util.Effect("Impact", effectdata)
	end
end
