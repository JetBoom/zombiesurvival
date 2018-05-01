INC_SERVER()

function SWEP:Reload()
	if CurTime() < self:GetNextPrimaryFire() then return end

	local owner = self:GetOwner()
	if owner:GetBarricadeGhosting() then return end

	local tr = owner:CompensatedMeleeTrace(self.MeleeRange, self.MeleeSize)
	local trent = tr.Entity
	if not trent:IsValid() or not trent:IsNailed() then return end

	local ent
	local dist

	for _, e in pairs(ents.FindByClass("prop_nail")) do
		if not e.m_PryingOut and e:GetParent() == trent then
			local edist = e:GetActualPos():DistToSqr(tr.HitPos)
			if not dist or edist < dist then
				ent = e
				dist = edist
			end
		end
	end

	if not ent or not gamemode.Call("CanRemoveNail", owner, ent) then return end

	local nailowner = ent:GetOwner()
	if nailowner:IsValid() and nailowner:IsPlayer() and nailowner ~= owner and nailowner:Team() == TEAM_HUMAN and not gamemode.Call("CanRemoveOthersNail", owner, nailowner, ent) then return end

	self:SetNextPrimaryFire(CurTime() + (#trent.Nails > 2 and 0.5 or 1))

	ent.m_PryingOut = true -- Prevents infinite loops

	self:SendWeaponAnim(self.Alternate and ACT_VM_HITCENTER or ACT_VM_MISSCENTER)
	self.Alternate = not self.Alternate

	owner:DoAnimationEvent(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE)

	owner:EmitSound("weapons/melee/crowbar/crowbar_hit-"..math.random(4)..".ogg")

	ent:GetParent():RemoveNail(ent, nil, self:GetOwner())
	ent:GetParent():SetPhysicsAttacker(self:GetOwner())

	if nailowner and nailowner:IsValid() and nailowner:IsPlayer() and nailowner ~= owner and nailowner:Team() == TEAM_HUMAN then
		if gamemode.Call("PlayerShouldTakeNailRemovalPenalty", owner, ent, nailowner, trent) then
			owner:GivePenalty(30)
			owner:ReflectDamage(20)
		end

		if nailowner:NearestPoint(tr.HitPos):DistToSqr(tr.HitPos) <= 589824 and (nailowner:HasWeapon("weapon_zs_hammer") or nailowner:HasWeapon("weapon_zs_electrohammer")) then --768^2
			nailowner:GiveAmmo(1, self.Primary.Ammo)
		else
			owner:GiveAmmo(1, self.Primary.Ammo)
		end
	else
		owner:GiveAmmo(1, self.Primary.Ammo)
	end
end

function SWEP:OnMeleeHit(hitent, hitflesh, tr)
	if not hitent:IsValid() then return end

	local owner = self:GetOwner()

	if hitent.HitByHammer and hitent:HitByHammer(self, owner, tr) then
		return
	end

	if hitent:IsNailed() then
		if owner:IsSkillActive(SKILL_BARRICADEEXPERT) then
			hitent.ReinforceEnd = CurTime() + 2
			hitent.ReinforceApplier = owner
		end

		local healstrength = self.HealStrength * GAMEMODE.NailHealthPerRepair * (owner.RepairRateMul or 1)
		local oldhealth = hitent:GetBarricadeHealth()
		if oldhealth <= 0 or oldhealth >= hitent:GetMaxBarricadeHealth() or hitent:GetBarricadeRepairs() <= 0.01 then return end

		hitent:SetBarricadeHealth(math.min(hitent:GetMaxBarricadeHealth(), hitent:GetBarricadeHealth() + math.min(hitent:GetBarricadeRepairs(), healstrength)))
		local healed = hitent:GetBarricadeHealth() - oldhealth
		hitent:SetBarricadeRepairs(math.max(hitent:GetBarricadeRepairs() - healed, 0))
		self:PlayRepairSound(hitent)
		gamemode.Call("PlayerRepairedObject", owner, hitent, healed, self)

		local effectdata = EffectData()
			effectdata:SetOrigin(tr.HitPos)
			effectdata:SetNormal(tr.HitNormal)
			effectdata:SetMagnitude(1)
		util.Effect("nailrepaired", effectdata, true, true)

		return true
	end
end

function SWEP:SecondaryAttack()
	if self:GetPrimaryAmmoCount() <= 0 or CurTime() < self:GetNextPrimaryFire() or self:GetOwner():GetBarricadeGhosting() then return end

	local owner = self:GetOwner()

	if GAMEMODE:IsClassicMode() then
		owner:PrintTranslatedMessage(HUD_PRINTCENTER, "cant_do_that_in_classic_mode")
		return
	end

	local tr = owner:CompensatedMeleeTrace(64, self.MeleeSize, nil, nil, nil, true)
	local trent = tr.Entity

	if not trent:IsValid()
	or not util.IsValidPhysicsObject(trent, tr.PhysicsBone)
	or tr.Fraction == 0
	or trent:GetMoveType() ~= MOVETYPE_VPHYSICS and not trent:GetNailFrozen()
	or trent.NoNails
	or trent:IsProjectile()
	or trent:IsNailed() and (#trent.Nails >= 8 or trent:GetPropsInContraption() >= GAMEMODE.MaxPropsInBarricade)
	or trent:GetMaxHealth() == 1 and trent:Health() == 0 and not trent.TotalHealth
	or trent.PreHoldCollisionGroup and (trent.PreHoldCollisionGroup == COLLISION_GROUP_DEBRIS or trent.PreHoldCollisionGroup == COLLISION_GROUP_DEBRIS_TRIGGER or trent.PreHoldCollisionGroup == COLLISION_GROUP_INTERACTIVE_DEBRIS)
	or not trent:IsNailed() and not trent:GetPhysicsObject():IsMoveable() then return end

	if not gamemode.Call("CanPlaceNail", owner, tr) then return end

	local count = 0
	for _, nail in pairs(trent:GetNails()) do
		if nail:GetDeployer() == owner then
			count = count + 1
			if count >= GAMEMODE.MaxNails then
				return
			end
		end
	end

	if tr.MatType == MAT_GRATE or tr.MatType == MAT_CLIP then
		owner:PrintTranslatedMessage(HUD_PRINTCENTER, "impossible")
		return
	end
	if tr.MatType == MAT_GLASS then
		owner:PrintTranslatedMessage(HUD_PRINTCENTER, "trying_to_put_nails_in_glass")
		return
	end

	for _, nail in pairs(ents.FindByClass("prop_nail")) do
		if nail:GetParent() == trent and nail:GetActualPos():DistToSqr(tr.HitPos) <= 81 then
			owner:PrintTranslatedMessage(HUD_PRINTCENTER, "too_close_to_another_nail")
			return
		end
	end

	if trent:GetBarricadeHealth() <= 0 and trent:GetMaxBarricadeHealth() > 0 then
		owner:PrintTranslatedMessage(HUD_PRINTCENTER, "object_too_damaged_to_be_used")
		return
	end

	-- Specical case for nailing things a drone is towing
	local ropeconstraint = constraint.FindConstraint(trent, "Rope")
	if ropeconstraint then
		if ropeconstraint.Ent1 and ropeconstraint.Ent1:IsValid() and ropeconstraint.Ent1:GetClass() == "prop_drone" then return end
		if ropeconstraint.Ent2 and ropeconstraint.Ent2:IsValid() and ropeconstraint.Ent2:GetClass() == "prop_drone" then return end
	end

	local aimvec = owner:GetAimVector()
	local trtwo = util.TraceLine({start = tr.HitPos, endpos = tr.HitPos + aimvec * 24, filter = table.Add({owner, trent}, GAMEMODE.CachedInvisibleEntities), mask = MASK_SOLID})

	if trtwo.HitSky then return end

	local ent = trtwo.Entity
	if trtwo.HitWorld
	or ent:IsValid() and util.IsValidPhysicsObject(ent, trtwo.PhysicsBone) and (ent:GetMoveType() == MOVETYPE_VPHYSICS or ent:GetNailFrozen()) and not ent.NoNails and not (not ent:IsNailed() and not ent:GetPhysicsObject():IsMoveable()) and not (ent:GetMaxHealth() == 1 and ent:Health() == 0 and not ent.TotalHealth) then
		if trtwo.MatType == MAT_GRATE or trtwo.MatType == MAT_CLIP then
			owner:PrintTranslatedMessage(HUD_PRINTCENTER, "impossible")
			return
		end
		if trtwo.MatType == MAT_GLASS then
			owner:PrintTranslatedMessage(HUD_PRINTCENTER, "trying_to_put_nails_in_glass")
			return
		end

		if ent and ent:IsValid() and (ent:IsProjectile() or ent.NoNails or ent:IsNailed() and (#ent.Nails >= 8 or ent:GetPropsInContraption() >= GAMEMODE.MaxPropsInBarricade)) then return end

		if ent:GetBarricadeHealth() <= 0 and ent:GetMaxBarricadeHealth() > 0 then
			owner:PrintTranslatedMessage(HUD_PRINTCENTER, "object_too_damaged_to_be_used")
			return
		end

		if GAMEMODE:EntityWouldBlockSpawn(ent) then return end

		local cons = constraint.Weld(trent, ent, tr.PhysicsBone, trtwo.PhysicsBone, 0, true)
		if cons ~= nil then
			for _, oldcons in pairs(constraint.FindConstraints(trent, "Weld")) do
				if oldcons.Ent1 == ent or oldcons.Ent2 == ent then
					cons = oldcons.Constraint
					break
				end
			end
		end

		if not cons then return end

		self:SendWeaponAnim(self.Alternate and ACT_VM_HITCENTER or ACT_VM_MISSCENTER)
		self.Alternate = not self.Alternate

		owner:DoAnimationEvent(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE)

		self:SetNextPrimaryFire(CurTime() + 1)
		self:TakePrimaryAmmo(1)

		local nail = ents.Create("prop_nail")
		if nail:IsValid() then
			nail:SetActualOffset(tr.HitPos, trent)
			nail:SetPos(tr.HitPos - aimvec * 8)
			nail:SetAngles(aimvec:Angle())
			nail:AttachTo(trent, ent, tr.PhysicsBone, trtwo.PhysicsBone)
			nail:Spawn()
			nail:SetDeployer(owner)

			cons:DeleteOnRemove(nail)

			gamemode.Call("OnNailCreated", trent, ent, nail)

			nail:EmitSound(string.format("weapons/melee/crowbar/crowbar_hit-%d.ogg", math.random(4)))
		end
	end
end
