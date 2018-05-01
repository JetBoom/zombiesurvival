SWEP.Base = "weapon_zs_poisonheadcrab"

SWEP.PrintName = "Barbed Headcrab"

SWEP.PounceDamage = 36

function SWEP:Think()
	local curtime = CurTime()
	local owner = self:GetOwner()

	if self:IsGoingToSpit() and self:GetNextSpit() <= curtime then
		self:SetNextSpit(0)
		self:SetNextPrimaryFire(curtime + 2.5)
		self:SetNextSecondaryFire(self:GetNextPrimaryFire())

		if SERVER then
			owner:EmitSound("npc/roller/mine/rmine_blades_out2.wav", 74, 220)
			owner.LastRangedAttack = CurTime()

			local ent = ents.Create("projectile_bristle")
			if ent:IsValid() then
				ent:SetOwner(owner)
				local aimvec = owner:GetAimVector()
				local vStart = owner:GetShootPos()
				local tr = util.TraceLine({start=vStart, endpos=vStart + owner:GetAimVector() * 30, filter=owner})
				if tr.Hit then
					ent:SetPos(tr.HitPos + tr.HitNormal * 4)
				else
					ent:SetPos(tr.HitPos)
				end

				local angs = owner:EyeAngles()
				angs:RotateAroundAxis(owner:EyeAngles():Up(), 90)
				ent:SetAngles(angs)

				ent:Spawn()
				local phys = ent:GetPhysicsObject()
				if phys:IsValid() then
					phys:SetVelocityInstantaneous(aimvec * 900)
				end
			end
		end
	elseif self:IsGoingToLeap() and self:GetNextLeap() <= curtime then
		self:SetNextLeap(0)
		if owner:IsOnGround() then
			local vel = owner:GetAimVector()
			vel.z = math.max(0.45, vel.z)
			vel:Normalize()

			owner:SetGroundEntity(NULL)
			owner:SetLocalVelocity(vel * 470)

			self:SetLeaping(true)

			if SERVER then
				owner:EmitSound("NPC_BlackHeadcrab.Attack")
			end
		end
	elseif self:IsLeaping() then
		if owner:IsOnGround() or 1 < owner:WaterLevel() then
			self:SetLeaping(false)
			self:SetNextPrimaryFire(curtime + 0.8)
		else
			--owner:LagCompensation(true)

			local vStart = owner:LocalToWorld(owner:OBBCenter())
			local trace = owner:CompensatedMeleeTrace(owner:BoundingRadius() + 8, 12, vStart, owner:GetForward())
			local ent = trace.Entity

			if ent:IsValid() then
				local phys = ent:GetPhysicsObject()

				if phys:IsValid() and not ent:IsPlayer() and phys:IsMoveable() then
					local vel = 12000 * owner:EyeAngles():Forward()

					phys:ApplyForceOffset(vel, (ent:NearestPoint(vStart) + ent:GetPos() * 2) / 3)
					ent:SetPhysicsAttacker(owner)
				end

				self:SetLeaping(false)
				self:SetNextPrimaryFire(curtime + 1)

				if SERVER then
					owner:EmitSound("NPC_BlackHeadcrab.Bite")
				end
				owner:ViewPunch(Angle(math.Rand(-20, 20), math.Rand(-20, 20), math.Rand(-20, 20)))

				if ent:IsPlayer() then
					ent:MeleeViewPunch(self.PounceDamage)
				end

				if ent:IsPlayer() then
					local bleed = ent:GiveStatus("bleed")
					if bleed and bleed:IsValid() then
						bleed:AddDamage(self.PounceDamage / 2)
						bleed.Damager = owner
					end

					ent:TakeSpecialDamage(self.PounceDamage / 2, DMG_SLASH, owner, self)
				else
					ent:TakeSpecialDamage(self.PounceDamage, DMG_SLASH, owner, self)
				end
			elseif trace.HitWorld then
				if SERVER then
					owner:EmitSound("NPC_BlackHeadcrab.Impact")
				end
				self:SetLeaping(false)
				self:SetNextPrimaryFire(curtime + 1)
			end

			--owner:LagCompensation(false)
		end
	end

	self:NextThink(curtime)
	return true
end

function SWEP:SecondaryAttack()
	local owner = self:GetOwner()
	if self:IsLeaping() or self:IsGoingToSpit() or self:IsGoingToLeap() or CurTime() < self:GetNextSecondaryFire() or not self:GetOwner():IsOnGround() then return end

	self:SetNextSpit(CurTime() + self.SpitWindUp)

	if SERVER then
		local sndname = "npc/headcrab_poison/ph_scream"..math.random(3)..".wav"
		for i = 1, 3 do
			timer.Simple(0.02 * i, function()
				if owner:IsValid() then owner:EmitSound(sndname, 75, 140 - i*2, 0.8) end
			end)
		end
	end
end
