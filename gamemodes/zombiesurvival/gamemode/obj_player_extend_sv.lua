local meta = FindMetaTable("Player")
local P_Team = meta.Team

local DMG_TAKE_BLEED = DMG_SLASH + DMG_CLUB + DMG_BULLET + DMG_BUCKSHOT + DMG_CRUSH
function meta:ProcessDamage(dmginfo)
	if not self:IsValidLivingPlayer() then return end --??? Apparently player was null sometimes on server?

	local attacker, inflictor, dmgtype = dmginfo:GetAttacker(), dmginfo:GetInflictor(), dmginfo:GetDamageType()

	if not GAMEMODE:PlayerShouldTakeDamage(self, attacker) then return true end

	local dmgbypass = bit.band(dmgtype, DMG_DIRECT) ~= 0

	if self.DamageVulnerability and not dmgbypass then
		dmginfo:SetDamage(dmginfo:GetDamage() * self.DamageVulnerability)
	end

	if attacker.AttackerForward and attacker.AttackerForward:IsValid() then
		dmginfo:SetAttacker(attacker.AttackerForward)
		attacker = attacker.AttackerForward

		if attacker:IsPlayer() and attacker:Team() == P_Team(self) and attacker ~= self then
			dmginfo:SetDamage(0)
		end
	end

	if attacker.PBAttacker and attacker.PBAttacker:IsValid() then
		attacker = attacker.PBAttacker
	end

	if P_Team(self) == TEAM_UNDEAD then
		if self.SpawnProtection then
			dmginfo:SetDamage(0)
			dmginfo:ScaleDamage(0)
			dmginfo:SetDamageForce(vector_origin)
			return
		end

		local corrosion = self.Corrosion and self.Corrosion + 2 > CurTime()
		if self ~= attacker and not corrosion and not dmgbypass then
			dmginfo:SetDamage(dmginfo:GetDamage() * GAMEMODE:GetZombieDamageScale(dmginfo:GetDamagePosition(), self))
		end

		self.ShouldFlinch = true

		if attacker:IsValidLivingHuman() and inflictor:IsValid() and inflictor == attacker:GetActiveWeapon() then
			local damage = dmginfo:GetDamage()
			local wep = attacker:GetActiveWeapon()
			local attackermaxhp = math.floor(attacker:GetMaxHealth() * (attacker:IsSkillActive(SKILL_D_FRAIL) and 0.25 or 1))

			if wep.IsMelee then
				if attacker:IsSkillActive(SKILL_CHEAPKNUCKLE) and math.abs(self:GetForward():Angle().yaw - attacker:GetForward():Angle().yaw) <= 90 then
					self:AddLegDamage(12)
				end

				if attacker.MeleeDamageToBloodArmorMul and attacker.MeleeDamageToBloodArmorMul > 0 and attacker:GetBloodArmor() < attacker.MaxBloodArmor then
					attacker:SetBloodArmor(math.min(attacker.MaxBloodArmor, attacker:GetBloodArmor() + math.min(damage, self:Health()) * attacker.MeleeDamageToBloodArmorMul * attacker.BloodarmorGainMul))
				end

				if attacker:IsSkillActive(SKILL_HEAVYSTRIKES) and not self:GetZombieClassTable().Boss and (wep.IsFistWeapon and attacker:IsSkillActive(SKILL_CRITICALKNUCKLE) or wep.MeleeKnockBack > 0) then
					attacker:TakeSpecialDamage(damage * (wep.Unarmed and 1 or 0.08), DMG_SLASH, self, self:GetActiveWeapon())
				end

				if attacker:IsSkillActive(SKILL_BLOODLUST) and attacker:GetPhantomHealth() > 0 and attacker:Health() < attackermaxhp then
					local toheal = math.min(attacker:GetPhantomHealth(), math.min(self:Health(), damage * 0.25))
					attacker:SetHealth(math.min(attacker:Health() + toheal, attackermaxhp))
					attacker:SetPhantomHealth(attacker:GetPhantomHealth() - toheal)
				end

				if attacker:HasTrinket("sharpkit") then
					dmginfo:SetDamage(dmginfo:GetDamage() * (1 + self:GetFlatLegDamage()/75))
				end

				if wep.Culinary and attacker:IsSkillActive(SKILL_MASTERCHEF) and math.random(9) == 1 then
					self.ChefMarkOwner = attacker
					self.ChefMarkTime = CurTime() + 1
				end
			end
		end

		return not dmgbypass and self:CallZombieFunction1("ProcessDamage", dmginfo)
	end

	-- Opted for multiplicative.
	if attacker == self and dmgtype ~= DMG_CRUSH and dmgtype ~= DMG_FALL and self.SelfDamageMul then
		dmginfo:SetDamage(dmginfo:GetDamage() * self.SelfDamageMul)
	end
	if bit.band(dmgtype, DMG_ALWAYSGIB) ~= 0 and self.ExplosiveDamageTakenMul then
		dmginfo:SetDamage(dmginfo:GetDamage() * self.ExplosiveDamageTakenMul)
	end
	if bit.band(dmgtype, DMG_BURN) ~= 0 and self.FireDamageTakenMul then
		dmginfo:SetDamage(dmginfo:GetDamage() * self.FireDamageTakenMul)
	end

	if inflictor:IsValid() and (inflictor:IsPhysicsModel() or inflictor.IsPhysbox) and self:IsValidLivingHuman() then
		local damage = dmginfo:GetDamage()
		local forcedamp = self:HasTrinket("forcedamp")
		local noadj = attacker:IsValidLivingZombie() and attacker:GetZombieClassTable().NoAdjustPhysDamage

		if forcedamp or (attacker:IsValidLivingZombie() and not noadj) then
			damage = math.max(5, (math.log10(damage) * 26)-5)
		end
		if self.PhysicsDamageTakenMul then
			damage = damage * self.PhysicsDamageTakenMul
		end
		if damage >= 30 and not forcedamp and not noadj and inflictor ~= attacker then
			self:KnockDown(damage * 0.05)
		end

		dmginfo:SetDamage(damage)
	end

	if attacker:IsValid() and attacker:IsPlayer() and inflictor:IsValid() and attacker:Team() == TEAM_UNDEAD then
		if inflictor == attacker:GetActiveWeapon() then
			local damage = dmginfo:GetDamage()

			if self:IsBarricadeGhosting() then
				self:SetLegDamage(21 * (self.SlowEffTakenMul or 1))
			else
				local scale = inflictor.SlowDownScale or 1
				if damage >= 45 or scale > 1 then
					local dolegdamage = true
					if inflictor.SlowDownImmunityTime then
						if CurTime() < (self.SlowDownImmunityTime or 0) then
							dolegdamage = false
						else
							self.SlowDownImmunityTime = CurTime() + inflictor.SlowDownImmunityTime
						end
					end
					if dolegdamage then
						self:RawCapLegDamage(self:GetLegDamage() + CurTime() + damage * 0.04 * (inflictor.SlowDownScale or 1) * (self.SlowEffTakenMul or 1))
					end
				end
			end

			if bit.band(dmgtype, DMG_SLASH) ~= 0 or inflictor.IsMelee then
				if self.BarbedArmor and self.BarbedArmor > 0 then
					attacker:TakeSpecialDamage(self.BarbedArmor, DMG_SLASH, self, self)
					attacker:AddArmDamage(self.BarbedArmor)
				end

				if self.BarbedArmorPercent and self.BarbedArmorPercent > 0 then
					attacker:TakeSpecialDamage(damage * self.BarbedArmorPercent, DMG_SLASH, self, self)
				end

				if self:HasTrinket("reactiveflasher") and (not self.LastReactiveFlash or self.LastReactiveFlash + 75 < CurTime()) then
					attacker:ScreenFade(SCREENFADE.IN, nil, 1, 1)
					attacker:SetDSP(36)
					attacker:GiveStatus("disorientation", 2)

					self:EmitSound("weapons/flashbang/flashbang_explode2.wav")

					local effectdata = EffectData()
						effectdata:SetOrigin(self:GetPos())
					util.Effect("HelicopterMegaBomb", effectdata)

					self.LastReactiveFlash = CurTime()
					self.ReactiveFlashMessage = nil
				elseif self:HasTrinket("bleaksoul") and (not self.LastBleakSoul or self.LastBleakSoul + 35 < CurTime()) then
					attacker:GiveStatus("dimvision", 3)
					attacker:SetGroundEntity(nil)
					attacker:SetLocalVelocity((attacker:GetPos() - self:GetPos()):GetNormalized() * 450 + Vector(0, 0, 140))

					self:EmitSound("ambient/creatures/town_child_scream1.wav", 70, 60)
					self:EmitSound("npc/stalker/go_alert2a.wav", 70, 45, 0.25)

					self.LastBleakSoul = CurTime()
					self.BleakSoulMessage = nil
				end

				if self:HasTrinket("iceburst") and (not self.LastIceBurst or self.LastIceBurst + 40 < CurTime()) then
					attacker:AddLegDamageExt(17, attacker, attacker, SLOWTYPE_COLD)

					local effectdata = EffectData()
						effectdata:SetOrigin(self:GetPos())
					util.Effect("explosion_cold", effectdata)

					self.LastIceBurst = CurTime()
					self.IceBurstMessage = nil
				end

				if self.MeleeDamageTakenMul and not dmgbypass then
					dmginfo:SetDamage(dmginfo:GetDamage() * self.MeleeDamageTakenMul)
				end

				if self:IsSkillActive(SKILL_BACKPEDDLER) then
					self:AddLegDamage(8)
				end
			end

			if self.HasHemophilia and (damage >= 4 and dmgtype == 0 or bit.band(dmgtype, DMG_TAKE_BLEED) ~= 0) then
				local bleed = self:GiveStatus("bleed")
				if bleed and bleed:IsValid() then
					bleed:AddDamage(damage * 0.25)
					if attacker:IsValid() and attacker:IsPlayer() then
						bleed.Damager = attacker
					end
				end
			end
		elseif inflictor:IsProjectile() then
			if self.ProjDamageTakenMul and not dmgbypass then
				dmginfo:SetDamage(dmginfo:GetDamage() * self.ProjDamageTakenMul)
			end
		end
	end

	self.NextBloodArmorRegen = CurTime() + 5
	if self:GetBloodArmor() > 0 then
		local damage = dmginfo:GetDamage()
		if damage > 0 then
			if damage >= self:GetBloodArmor() and self:IsSkillActive(SKILL_BLOODLETTER) then
				local bleed = self:GiveStatus("bleed")
				if bleed and bleed:IsValid() then
					bleed:AddDamage(5)
					bleed.Damager = self
				end
			end

			local ratio = 0.5 + self.BloodArmorDamageReductionAdd + (self:IsSkillActive(SKILL_IRONBLOOD) and self:Health() <= self:GetMaxHealth() * 0.5 and 0.25 or 0)
			local absorb = math.min(self:GetBloodArmor(), damage * ratio)
			dmginfo:SetDamage(damage - absorb)
			self:SetBloodArmor(self:GetBloodArmor() - absorb)

			if attacker:IsValid() and attacker:IsPlayer() then
				local myteam = attacker:Team()
				local otherteam = P_Team(self)
				attacker.DamageDealt[myteam] = attacker.DamageDealt[myteam] + absorb

				if myteam == TEAM_UNDEAD and otherteam == TEAM_HUMAN then
					attacker:AddLifeHumanDamage(absorb)
				end
			end

			if damage > 20 and damage - absorb <= 0 then
				self:EmitSound("physics/flesh/flesh_strider_impact_bullet3.wav", 55)
			end
		end
	end

	if self:IsSkillActive(SKILL_BLOODLUST) and attacker:IsValid() and attacker:IsPlayer() and inflictor:IsValid() and attacker:Team() == TEAM_UNDEAD then
		self:SetPhantomHealth(math.min(self:GetPhantomHealth() + dmginfo:GetDamage() / 2, self:GetMaxHealth()))
	end

	if dmginfo:GetDamage() > 0 and not self:HasGodMode() then
		self.NextRegenTrinket = CurTime() + 12

		self.ShouldFlinch = true
	end
end

GM.TrinketRecharges = {
	reactiveflasher = {"ReactiveFlashMessage", "LastReactiveFlash", "Reactive Flasher", 75},
	bleaksoul = {"BleakSoulMessage", "LastBleakSoul", "Bleak Soul", 35},
	biocleanser = {"BioCleanserMessage", "LastBioCleanser", "Bio Cleanser", 20},
	iceburst = {"IceBurstMessage", "LastIceBurst", "Iceburst Shield", 40}
}

function meta:CheckTrinketRecharges()
	local time = CurTime()

	for trinket, data in pairs(GAMEMODE.TrinketRecharges) do
		local msg, last, name, delay = data[1], data[2], data[3], data[4]

		if self:HasTrinket(trinket) and not self[msg] and self[last] and time > self[last] + delay then
			self:CenterNotify(COLOR_ORANGE, translate.ClientFormat(self, "trinket_recharged", name))
			self:SendLua("surface.PlaySound(\"buttons/button5.wav\")")
			self[msg] = true
		end
	end
end

function meta:HasWon()
	if P_Team(self) == TEAM_HUMAN and self:GetObserverMode() == OBS_MODE_ROAMING then
		local target = self:GetObserverTarget()
		return target and target:IsValid() and target:GetClass() == "prop_obj_exit"
	end

	return false
end

function meta:GetBossZombieIndex()
	local bossclasses = {}
	for _, classtable in pairs(GAMEMODE.ZombieClasses) do
		if classtable.Boss then
			table.insert(bossclasses, classtable.Index)
		end
	end

	if #bossclasses == 0 then return -1 end

	local desired = self:GetInfo("zs_bossclass") or ""
	if GAMEMODE:IsBabyMode() then
		desired = "Giga Gore Child"
	elseif desired == "[RANDOM]" or desired == "" then
		desired = "Nightmare"
	end

	local bossindex
	for _, classindex in pairs(bossclasses) do
		local classtable = GAMEMODE.ZombieClasses[classindex]
		if string.lower(classtable.Name) == string.lower(desired) then
			bossindex = classindex
			break
		end
	end

	return bossindex or bossclasses[1]
end

function meta:ShouldReviveFrom(dmginfo, hullzplane)
	return not self.Revive
	and not dmginfo:GetInflictor().IsMelee and not dmginfo:GetInflictor().NoReviveFromKills
	and dmginfo:GetAttacker() ~= self and dmginfo:GetAttacker():IsPlayer()
	and dmginfo:GetDamageType() ~= DMG_ALWAYSGIB and dmginfo:GetDamageType() ~= DMG_BURN
	and (not hullzplane and (self:LastHitGroup() == HITGROUP_LEFTLEG or self:LastHitGroup() == HITGROUP_RIGHTLEG)
	or dmginfo:GetDamagePosition().z < self:LocalToWorld(Vector(0, 0, hullzplane)).z)
end

function meta:NearestArsenalCrateOwnedByOther()
	local pos = self:EyePos()

	local arseents = {}
	table.Add(arseents, ents.FindByClass("prop_arsenalcrate"))
	table.Add(arseents, ents.FindByClass("status_arsenalpack"))

	for _, ent in pairs(arseents) do
		local nearest = ent:NearestPoint(pos)
		local owner = ent.GetObjectOwner and ent:GetObjectOwner() or ent:GetOwner()
		if owner ~= self and owner:IsValidHuman() and pos:DistToSqr(nearest) <= 10000 and (WorldVisible(pos, nearest) or self:TraceLine(100).Entity == ent) then
			return ent
		end
	end
end

local OldLastHitGroup = meta.LastHitGroup
function meta:LastHitGroup()
	return self.m_LastHitGroupUnset and CurTime() <= self.m_LastHitGroupUnset and self.m_LastHitGroup or OldLastHitGroup(self)
end

function meta:SetLastHitGroup(hitgroup)
	self.m_LastHitGroup = hitgroup
	self.m_LastHitGroupUnset = CurTime() + 0.2
end

function meta:WasHitInHead()
	return self.m_LastHitInHead and CurTime() <= self.m_LastHitInHead
end

function meta:SetWasHitInHead()
	self.m_LastHitInHead = CurTime() + 0.2
end

function meta:SetPoints(points)
	self:SetDTInt(1, points)
end

function meta:SetBloodArmor(armor)
	self:SetDTInt(DT_PLAYER_INT_BLOODARMOR, armor)
end

function meta:WouldDieFrom(damage, hitpos)
	return self:Health() <= damage * GAMEMODE:GetZombieDamageScale(hitpos, self)
end

function meta:KnockDown(time)
	if P_Team(self) == TEAM_HUMAN then
		self:GiveStatus("knockdown", time or 3)
	end
end

function meta:FakeDeath(sequenceid, modelscale, length, start)
	for _, ent in pairs(ents.FindByClass("fakedeath")) do
		if ent:GetOwner() == self then
			ent:Remove()
		end
	end

	local ent = ents.Create("fakedeath")
	if ent:IsValid() then
		ent:SetOwner(self)
		ent:SetModel(self:GetModel())
		ent:SetSkin(self:GetSkin())
		ent:SetColor(self:GetColor())
		ent:SetMaterial(self:GetMaterial())
		ent:SetPos(self:GetPos() + Vector(0, 0, 64))
		ent:Spawn()
		ent:SetModelScale(modelscale or self:GetModelScale(), 0)

		ent:SetDeathSequence(sequenceid or 0)
		ent:SetDeathAngles(self:GetAngles())
		ent:SetDeathSequenceLength(length or 1)
		ent:SetDeathSequenceStart(start or 0)

		self:DeleteOnRemove(ent)
	end

	return ent
end

function meta:TrySpawnAsGoreChild(ent)
	if ent and ent:IsValid() and not ent.SpawnedOn and ent:GetSettled() then
		ent.SpawnedOn = true

		local ang = self:EyeAngles()
		ang.roll = 0
		ang.pitch = 0

		self.OldDeathClass = self.DeathClass
		self:SetZombieClassName(ent:GetClass() == "prop_thrownbaby" and "Gore Child" or "Shadow Child")
		self.DeathClass = nil
		self.DidntSpawnOnSpawnPoint = true
		self:UnSpectateAndSpawn()
		self.Master = ent:GetOwner()
		self.DeathClass = self.OldDeathClass
		self:SetPos(ent:GetPos())
		self:SetEyeAngles(ang)
		self:StartFeignDeath(true)
		if IsValid(self.FeignDeath) then
			self.FeignDeath:SetState(1)
			self.FeignDeath:SetDirection(math.random(2) == 1 and DIR_FORWARD or DIR_BACK)
		end

		ent:Remove()
	end
end

function meta:SendLifeStats()
	if self.LifeStatSend and self.LifeStatSend > CurTime() then return end
	self.LifeStatSend = CurTime() + 0.33

	net.Start("zs_lifestats")
		net.WriteUInt(math.ceil(self.LifeBarricadeDamage or 0), 16)
		net.WriteUInt(math.ceil(self.LifeHumanDamage or 0), 16)
		net.WriteUInt(self.LifeBrainsEaten or 0, 8)
	net.Send(self)
end

function meta:AddLifeBarricadeDamage(amount)
	self.LifeBarricadeDamage = self.LifeBarricadeDamage + amount
	self.WaveBarricadeDamage = self.WaveBarricadeDamage + amount

	if not self:Alive() and not self:GetZombieClassTable().NeverAlive then
		timer.Simple(0, function() if self:IsValid() then self:SendLifeStats() end end)
	end
end

function meta:AddLifeHumanDamage(amount)
	self.LifeHumanDamage = self.LifeHumanDamage + amount
	self.WaveHumanDamage = self.WaveHumanDamage + amount

	if not self:Alive() then
		timer.Simple(0, function() if self:IsValid() then self:SendLifeStats() end end)
	end
end

function meta:AddLifeBrainsEaten(amount)
	self.LifeBrainsEaten = self.LifeBrainsEaten + amount

	if not self:Alive() then
		timer.Simple(0, function() if self:IsValid() then self:SendLifeStats() end end)
	end
end

function meta:RemoveEphemeralStatuses()
	for _, status in pairs(ents.FindByClass("status_*")) do
		if status.Ephemeral and status:IsValid() and status:GetOwner() == self then
			status:Remove()
		end
	end
end

function meta:AddPoisonDamage(damage, attacker)
	--damage = math.ceil(damage)

	if damage > 0 then
		local status = self:GiveStatus("poison")
		if status and status:IsValid() then
			status:AddDamage(damage, attacker)
		end
	else
		local status = self:GetStatus("poison")
		if status and status:IsValid() then
			status:AddDamage(damage)
		end
	end
end

function meta:AddBleedDamage(damage, attacker)
	--damage = math.ceil(damage)

	if damage > 0 then
		local status = self:GiveStatus("bleed")
		if status and status:IsValid() then
			status:AddDamage(damage, attacker)
		end
	else
		local status = self:GiveStatus("bleed")
		if status and status:IsValid() then
			status:AddDamage(damage)
		end
	end
end

function meta:FloatingScore(victimorpos, effectname, frags, flags)
	if type(victimorpos) == "Vector" then
		net.Start("zs_floatscore_vec")
			net.WriteVector(victimorpos)
			net.WriteString(effectname)
			net.WriteInt(frags, 24)
			net.WriteUInt(flags, 8)
		net.Send(self)
	else
		net.Start("zs_floatscore")
			net.WriteEntity(victimorpos)
			net.WriteString(effectname)
			net.WriteInt(frags, 24)
			net.WriteUInt(flags, 8)
		net.Send(self)
	end
end

function meta:CollectDamageNumberSession(dmg, lastpos, hasplayer)
	self.DamageNumberTally = (self.DamageNumberTally or 0) + dmg
	self.DamageNumberLastPos = self.DamageNumberLastPos and ((self.DamageNumberLastPos + lastpos)/2) or lastpos
	self.DamageNumberHasPlayer = self.DamageNumberHasPlayer or hasplayer
end

function meta:StartDamageNumberSession()
	self.DamageNumberTally = 0
end

function meta:HasDamageNumberSession()
	return self.DamageNumberTally
end

function meta:PopDamageNumberSession()
	local tally, lastpos, hasplayer =
		self.DamageNumberTally,
		self.DamageNumberLastPos,
		self.DamageNumberHasPlayer

	self.DamageNumberTally = nil
	self.DamageNumberLastPos = nil
	self.DamageNumberHasPlayer = nil

	return tally, lastpos, hasplayer
end

function meta:MarkAsBadProfile()
	self.NoProfiling = true
end

function meta:CenterNotify(...)
	net.Start("zs_centernotify")
		net.WriteTable({...})
	net.Send(self)
end

function meta:TopNotify(...)
	net.Start("zs_topnotify")
		net.WriteTable({...})
	net.Send(self)
end

function meta:RefreshDynamicSpawnPoint()
	local target = self:GetObserverTarget()
	if (GAMEMODE:GetDynamicSpawning() and self:GetObserverMode() == OBS_MODE_CHASE and target and target:IsValid()) and
			(self.ZombieEscape and target:IsPlayer() and target:Team() == TEAM_UNDEAD
			or not self.ZombieEscape and (target.IsCreeperNest and target:GetNestBuilt() or target.MinionSpawn and target:GetSettled())
			or string.sub(target:GetClass(), 1, 12) == "info_player_") then
		self.ForceDynamicSpawn = target
		self.ForceSpawnAngles = self:EyeAngles()
	else
		self.ForceDynamicSpawn = nil
		self.ForceSpawnAngles = nil
	end
end

function meta:PushPackedItem(class, ...)
	if self.PackedItems and ... ~= nil then
		local packed = {...}

		self.PackedItems[class] = self.PackedItems[class] or {}

		table.insert(self.PackedItems[class], packed)
	end
end

function meta:PopPackedItem(class)
	if self.PackedItems and self.PackedItems[class] and self.PackedItems[class][1] ~= nil then
		local index = #self.PackedItems[class]
		local data = self.PackedItems[class][index]
		table.remove(self.PackedItems[class], index)

		return data
	end
end

function meta:ChangeToCrow()
	self.StartCrowing = nil

	local crowclass = GAMEMODE.ZombieClasses["Crow"]
	if not crowclass then return end

	local curclass = self.DeathClass or self:GetZombieClass()
	local crowindex = crowclass.Index
	self:SetZombieClass(crowindex)
	self:DoHulls(crowindex, TEAM_UNDEAD)

	self.DeathClass = nil
	self:UnSpectateAndSpawn()
	self.DeathClass = curclass
end

function meta:SelectRandomPlayerModel()
	self:SetModel(player_manager.TranslatePlayerModel(GAMEMODE.RandomPlayerModels[math.random(#GAMEMODE.RandomPlayerModels)]))
end

function meta:GiveEmptyWeapon(weptype)
	if not self:HasWeapon(weptype) then
		local wep = self:Give(weptype)
		if wep and wep:IsValid() and wep:IsWeapon() then
			wep:EmptyAll()
		end

		return wep
	end
end

local OldGive = meta.Give
function meta:Give(weptype, noammo)
	if P_Team(self) ~= TEAM_HUMAN then
		return OldGive(self, weptype, noammo)
	end

	local weps = self:GetWeapons()
	local autoswitch = #weps == 1 and weps[1]:IsValid() and weps[1].AutoSwitchFrom

	local ret = OldGive(self, weptype, noammo)

	if autoswitch then
		self:SelectWeapon(weptype)
	end

	return ret
end

function meta:StartFeignDeath(force)
	local feigndeath = self.FeignDeath
	if feigndeath and feigndeath:IsValid() then
		if CurTime() >= feigndeath:GetStateEndTime() then
			feigndeath:SetState(1)
			feigndeath:SetStateEndTime(CurTime() + 1.5)
		end
	elseif force or self:IsOnGround() and not self:IsPlayingTaunt() then
		local wep = self:GetActiveWeapon()
		if force or wep:IsValid() and not (wep.IsSwinging and wep:IsSwinging()) and CurTime() > wep:GetNextPrimaryFire() then
			if wep:IsValid() and wep.StopMoaning then
				wep:StopMoaning()
			end

			local status = self:GiveStatus("feigndeath")
			if status and status:IsValid() then
				status:SetStateEndTime(CurTime() + 1.5)
			end
		end
	end
end

function meta:UpdateLegDamage()
	net.Start("zs_legdamage")
		net.WriteFloat(self.LegDamage)
	net.Send(self)
end

function meta:UpdateArmDamage()
	net.Start("zs_armdamage")
		net.WriteFloat(self.ArmDamage)
	net.Send(self)
end

function meta:CoupleWith(plheadcrab)
	if self:GetZombieClassTable().Headcrab == plheadcrab:GetZombieClassTable().Name then
		local status = self:GiveStatus("headcrabcouple")
		if status:IsValid() then
			status:SetCouple(plheadcrab)
		end
	end
end

function meta:FixModelAngles(velocity)
	local eye = self:EyeAngles()
	self:SetLocalAngles(eye)
	self:SetPoseParameter("move_yaw", math.NormalizeAngle(velocity:Angle().yaw - eye.y))
end

function meta:RemoveAllStatus(bSilent, bInstant)
	if bInstant then
		for _, ent in pairs(ents.FindByClass("status_*")) do
			if not ent.NoRemoveOnDeath and ent:GetOwner() == self then
				ent:Remove()
			end
		end
	else
		for _, ent in pairs(ents.FindByClass("status_*")) do
			if not ent.NoRemoveOnDeath and ent:GetOwner() == self then
				ent.SilentRemove = bSilent
				ent:SetDie()
			end
		end
	end
end

function meta:RemoveStatus(sType, bSilent, bInstant, sExclude)
	local removed

	for _, ent in pairs(ents.FindByClass("status_"..sType)) do
		if ent:GetOwner() == self and not (sExclude and ent:GetClass() == "status_"..sExclude) then
			if bInstant then
				ent:Remove()
			else
				ent.SilentRemove = bSilent
				ent:SetDie()
			end
			removed = true
		end
	end

	return removed
end

function meta:GetStatus(sType)
	local ent = self["status_"..sType]
	if ent and ent:IsValid() and ent:GetOwner() == self then return ent end
end

function meta:GiveStatus(sType, fDie)
	local resistable = table.HasValue(GAMEMODE.ResistableStatuses, sType)

	if resistable and self:IsSkillActive(SKILL_HAEMOSTASIS) and self:GetBloodArmor() >= 2 then
		self:SetBloodArmor(self:GetBloodArmor() - 2)
		return
	end

	if resistable and self:HasTrinket("biocleanser") and (not self.LastBioCleanser or self.LastBioCleanser + 20 < CurTime()) then
		self.LastBioCleanser = CurTime()
		self.BioCleanserMessage = nil
	end

	local cur = self:GetStatus(sType)
	if cur then
		if fDie then
			cur:SetDie(fDie)
		end
		cur:SetPlayer(self, true)
		return cur
	else
		local ent = ents.Create("status_"..sType)
		if ent:IsValid() then
			ent:Spawn()
			if fDie then
				ent:SetDie(fDie)
			end
			ent:SetPlayer(self)
			return ent
		end
	end
end

function meta:UnSpectateAndSpawn()
	self:UnSpectate()
	self:Spawn()
end

function meta:SecondWind(pl)
	if self.Gibbed or self:Alive() or P_Team(self) ~= TEAM_UNDEAD then return end

	local pos = self:GetPos()
	local angles = self:EyeAngles()
	local lastattacker = self:GetLastAttacker()
	local dclass = self.DeathClass
	self.DeathClass = nil
	self.Revived = true
	self:UnSpectateAndSpawn()
	self.Revived = nil
	self.DeathClass = dclass
	self:SetLastAttacker(lastattacker)
	self:SetPos(pos)
	self:SetHealth(self:Health() * 0.2)
	self:SetEyeAngles(angles)

	self:CallZombieFunction0("OnSecondWind")
end

function meta:DropAll()
	self:DropAllWeapons()
	self:DropAllAmmo()
	self:DropAllInventoryItems()
end

local function CreateRagdoll(pl)
	if pl:IsValid() then pl:OldCreateRagdoll() end
end
local function SetModel(pl, mdl)
	if pl:IsValid() then
		pl:SetModel(mdl)
		timer.Simple(0, function() CreateRagdoll(pl) end)
	end
end

meta.OldCreateRagdoll = meta.CreateRagdoll
function meta:CreateRagdoll()
	local status = self.status_overridemodel
	if status and status:IsValid() then
		local mdl = status:GetModel()
		timer.Simple(0, function() SetModel(self, mdl) end)
		status:SetRenderMode(RENDERMODE_NONE)
	else
		self:OldCreateRagdoll()
	end
end

function meta:DropWeaponByType(class)
	if GAMEMODE.ZombieEscape then return end

	local wep = self:GetWeapon(class)
	if wep and wep:IsValid() and not wep.Undroppable then
		local ent = ents.Create("prop_weapon")
		if ent:IsValid() then
			ent:SetWeaponType(class)
			ent:Spawn()

			if wep.AmmoIfHas then
				local ammocount = wep:GetPrimaryAmmoCount()
				local desiredrop = math.min(ammocount, wep.Primary.ClipSize) - wep:Clip1()
				if desiredrop > 0 then
					wep:TakeCombinedPrimaryAmmo(desiredrop)
					wep:SetClip1(desiredrop)
				end
			end
			ent:SetClip1(wep:Clip1())
			ent:SetClip2(wep:Clip2())
			ent.DroppedTime = CurTime()

			self:StripWeapon(class)
			self:UpdateAltSelectedWeapon()

			return ent
		end
	end
end

function meta:DropAllWeapons()
	local vPos = self:GetPos()
	local vVel = self:GetVelocity()
	local zmax = self:OBBMaxs().z * 0.75
	for _, wep in pairs(self:GetWeapons()) do
		if wep:IsValid() then
			local ent = self:DropWeaponByType(wep:GetClass())
			if ent and ent:IsValid() then
				ent:SetPos(vPos + Vector(math.Rand(-16, 16), math.Rand(-16, 16), math.Rand(2, zmax)))
				ent:SetAngles(VectorRand():Angle())
				local phys = ent:GetPhysicsObject()
				if phys:IsValid() then
					phys:AddAngleVelocity(Vector(math.Rand(-720, 720), math.Rand(-720, 720), math.Rand(-720, 720)))
					phys:ApplyForceCenter(phys:GetMass() * (math.Rand(32, 328) * VectorRand():GetNormalized() + vVel))
				end
			end
		end
	end

	if GAMEMODE.ZombieEscape then
		local zewep = self:GetWeapon("weapon_elite")
		if zewep and zewep:IsValid() then
			self:DropWeapon(zewep)
		end
	end
end

function meta:DropAmmoByType(ammotype, amount)
	if GAMEMODE.ZombieEscape then return end

	local mycount = self:GetAmmoCount(ammotype)
	amount = math.min(mycount, amount or mycount)
	if not amount or amount <= 0 then return end

	local ent = ents.Create("prop_ammo")
	if ent:IsValid() then
		ent:SetAmmoType(ammotype)
		ent:SetAmmo(amount)
		ent:Spawn()
		ent.DroppedTime = CurTime()

		self:RemoveAmmo(amount, ammotype)

		return ent
	end
end

function meta:DropAllAmmo()
	local vPos = self:GetPos()
	local vVel = self:GetVelocity()
	local zmax = self:OBBMaxs().z * 0.75
	for ammotype in pairs(GAMEMODE.AmmoCache) do
		local ent = self:DropAmmoByType(ammotype)
		if ent and ent:IsValid() then
			ent:SetPos(vPos + Vector(math.Rand(-16, 16), math.Rand(-16, 16), math.Rand(2, zmax)))
			ent:SetAngles(VectorRand():Angle())
			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:AddAngleVelocity(Vector(math.Rand(-720, 720), math.Rand(-720, 720), math.Rand(-720, 720)))
				phys:ApplyForceCenter(phys:GetMass() * (math.Rand(32, 328) * VectorRand():GetNormalized() + vVel))
			end
		end
	end
end

function meta:Resupply(owner, obj)
	if GAMEMODE:GetWave() <= 0 then return end

	local stockpiling = self:IsSkillActive(SKILL_STOCKPILE)
	local stowage = self:IsSkillActive(SKILL_STOWAGE)

	if (stowage and (self.StowageCaches or 0) <= 0) or (not stowage and CurTime() < (self.NextResupplyUse or 0)) then
		self:CenterNotify(COLOR_RED, translate.ClientGet(self, "no_ammo_here"))
		return
	end

	if not stowage then
		self.NextResupplyUse = CurTime() + GAMEMODE.ResupplyBoxCooldown * (self.ResupplyDelayMul or 1) * (stockpiling and 2.12 or 1)

		net.Start("zs_nextresupplyuse")
			net.WriteFloat(self.NextResupplyUse)
		net.Send(self)
	else
		self.StowageCaches = self.StowageCaches - 1

		net.Start("zs_stowagecaches")
			net.WriteInt(self.StowageCaches, 8)
		net.Send(self)
	end

	local ammotype = self:GetResupplyAmmoType()
	local amount = GAMEMODE.AmmoCache[ammotype]

	for i = 1, stockpiling and not stowage and 2 or 1 do
		net.Start("zs_ammopickup")
			net.WriteUInt(amount, 16)
			net.WriteString(ammotype)
		net.Send(self)

		self:GiveAmmo(amount, ammotype)

		if self:IsSkillActive(SKILL_FORAGER) and math.random(4) == 1 and #GAMEMODE.Food > 0 then
			self:Give(GAMEMODE.Food[math.random(#GAMEMODE.Food)])
		end

		if self ~= owner and owner:IsValidHuman() then
			if obj:GetClass() == "prop_resupplybox" then
				owner.ResupplyBoxUsedByOthers = owner.ResupplyBoxUsedByOthers + 1
			end

			owner:AddPoints(0.15, nil, nil, true)

			net.Start("zs_commission")
				net.WriteEntity(obj)
				net.WriteEntity(self)
				net.WriteFloat(0.15)
			net.Send(owner)
		end
	end

	return true
end

-- Lets other players know about our maximum health.
meta.OldSetMaxHealth = FindMetaTable("Entity").SetMaxHealth
function meta:SetMaxHealth(num)
	num = math.ceil(num)
	self:SetDTInt(0, num)
	self:OldSetMaxHealth(num)
end

function meta:PointCashOut(ent, fmtype)
	if self.PointQueue >= 1 and P_Team(self) == TEAM_HUMAN then
		local points = self.PointQueue --math.floor(self.PointQueue)
		self.PointQueue = self.PointQueue - points

		self:AddPoints(points, ent or self.LastDamageDealtPos or vector_origin, fmtype)
	end
end

function meta:AddPoints(points, floatingscoreobject, fmtype, nomul)
	if gamemode.Call("IsEscapeDoorOpen") then return end

	if points > 0 and not nomul and self.PointIncomeMul then
		points = points * self.PointIncomeMul
	end

	-- This lets us add partial amounts of points (floats)
	local wholepoints = math.floor(points)
	local remainder = points - wholepoints
	if remainder > 0 then
		self.PointsRemainder = self.PointsRemainder + remainder
		local carryover = math.floor(self.PointsRemainder)
		wholepoints = wholepoints + carryover
		self.PointsRemainder = self.PointsRemainder - carryover
	end

	local absorb = self.PointsToAbsorb
	if absorb and absorb > 0 then
		wholepoints = math.max(wholepoints - absorb, 0)
		self.PointsToAbsorb = absorb - wholepoints

		if wholepoints <= 0 then return end
		self.PointsToAbsorb = nil
	end

	self:AddFrags(wholepoints)
	self:SetPoints(self:GetPoints() + wholepoints)

	if self.PointsVault then
		self.PointsVault = self.PointsVault + wholepoints * GAMEMODE.PointSaving
	end

	if floatingscoreobject then
		self:FloatingScore(floatingscoreobject, "floatingscore", wholepoints, fmtype or FM_NONE)
	end

	local xp = wholepoints
	if GAMEMODE.HumanXPMulti and GAMEMODE.HumanXPMulti >= 0 then
		xp = xp * GAMEMODE.HumanXPMulti
		local wholexp = math.floor(xp)
		local xpremainder = xp - wholexp
		if xpremainder > 0 then
			self.XPRemainder = self.XPRemainder + xpremainder
			local xpcarryover = math.floor(self.XPRemainder)
			xp = wholexp + xpcarryover
			self.XPRemainder = self.XPRemainder - xpcarryover
		end
	end

	self:AddZSXP(xp * (self.RedeemBonus and 1.15 or 1))

	gamemode.Call("PlayerPointsAdded", self, wholepoints)
end

function meta:TakePoints(points)
	self:SetPoints(self:GetPoints() - points)

	if self.PointsVault then
		self.PointsVault = self.PointsVault - points
	end
end

function meta:UpdateAllZombieClasses()
	for _, pl in pairs(player.GetAll()) do
		if pl ~= self and pl:Team() == TEAM_UNDEAD then
			local id = pl:GetZombieClass()
			if id and 0 < id then
				net.Start("zs_zclass")
					net.WriteEntity(pl)
					net.WriteUInt(id, 8)
				net.Send(self)
			end
		end
	end
end

function meta:CreateAmbience(class)
	class = "status_"..class

	for _, ent in pairs(ents.FindByClass(class)) do
		if ent:GetOwner() == self then return end
	end

	local ent = ents.Create(class)
	if ent:IsValid() then
		ent:SetPos(self:LocalToWorld(self:OBBCenter()))
		self[class] = ent
		ent:SetOwner(self)
		ent:SetParent(self)
		ent:Spawn()
	end
end

function meta:SetZombieClass(cl, onlyupdate, filter)
	if onlyupdate then
		net.Start("zs_zclass")
			net.WriteEntity(self)
			net.WriteUInt(cl, 8)
		if filter then
			net.Send(filter)
		else
			net.Broadcast()
		end

		return
	end

	self:CallZombieFunction0("SwitchedAway")

	local classtab = GAMEMODE.ZombieClasses[cl]
	if classtab then
		self.Class = cl
		if P_Team(self) == TEAM_UNDEAD then
			self:DoHulls(cl)
		end
		self:CallZombieFunction0("SwitchedTo")

		net.Start("zs_zclass")
			net.WriteEntity(self)
			net.WriteUInt(cl, 8)
		if filter then
			net.Send(filter)
		else
			net.Broadcast()
		end
	end
end

function meta:DoHulls(classid, teamid)
	teamid = teamid or P_Team(self)
	classid = classid or self:GetZombieClass()

	if teamid == TEAM_UNDEAD then
		local classtab = GAMEMODE.ZombieClasses[classid]
		if classtab then
			if self:Alive() then
				self:SetMoveType(classtab.MoveType or MOVETYPE_WALK)
			end

			if classtab.ModelScale then
				self:SetModelScale(classtab.ModelScale, 0)
			elseif self:GetModelScale() ~= DEFAULT_MODELSCALE then
				self:SetModelScale(DEFAULT_MODELSCALE, 0)
			end

			if not classtab.Hull or not classtab.HullDuck then
				self:ResetHull()
			end
			if classtab.ViewOffset then
				self:SetViewOffset(classtab.ViewOffset)
			elseif self:GetViewOffset() ~= DEFAULT_VIEW_OFFSET then
				self:SetViewOffset(DEFAULT_VIEW_OFFSET)
			end
			if classtab.ViewOffsetDucked then
				self:SetViewOffsetDucked(classtab.ViewOffsetDucked)
			elseif self:GetViewOffsetDucked() ~= DEFAULT_VIEW_OFFSET_DUCKED then
				self:SetViewOffsetDucked(DEFAULT_VIEW_OFFSET_DUCKED)
			end
			if classtab.HullDuck then
				self:SetHullDuck(classtab.HullDuck[1], classtab.HullDuck[2])
			end
			if classtab.Hull then
				self:SetHull(classtab.Hull[1], classtab.Hull[2])
			end
			if classtab.StepSize then
				self:SetStepSize(classtab.StepSize)
			elseif self:GetStepSize() ~= DEFAULT_STEP_SIZE then
				self:SetStepSize(DEFAULT_STEP_SIZE)
			end
			if classtab.JumpPower then
				self:SetJumpPower(classtab.JumpPower)
			elseif self:GetJumpPower() ~= DEFAULT_JUMP_POWER then
				self:SetJumpPower(DEFAULT_JUMP_POWER)
			end
			if classtab.Gravity then
				self:SetGravity(classtab.Gravity)
			elseif self:GetGravity() ~= 1 then
				self:SetGravity(1)
			end
			local bloodcolor = classtab.BloodColor or 0
			if self:GetBloodColor() ~= bloodcolor then
				self:SetBloodColor(bloodcolor)
			end

			self:DrawShadow(not classtab.NoShadow)
			self:SetRenderMode(classtab.RenderMode or RENDERMODE_NORMAL)

			self.NoCollideAll = classtab.NoCollideAll or (classtab.ModelScale or 1) ~= DEFAULT_MODELSCALE
			--self.NoCollideInside = classtab.NoCollideInside or (classtab.ModelScale or 1) ~= DEFAULT_MODELSCALE
			self.AllowTeamDamage = classtab.AllowTeamDamage
			self.NeverAlive = classtab.NeverAlive
			self.KnockbackScale = classtab.KnockbackScale
			local phys = self:GetPhysicsObject()
			if phys:IsValid() then
				phys:SetMass(classtab.Mass or DEFAULT_MASS)
			end
		end
	else
		self:SetModelScale(DEFAULT_MODELSCALE, 0)
		self:ResetHull()
		self:SetViewOffset(DEFAULT_VIEW_OFFSET)
		self:SetViewOffsetDucked(DEFAULT_VIEW_OFFSET_DUCKED)
		self:SetStepSize(DEFAULT_STEP_SIZE)
		self:SetJumpPower(DEFAULT_JUMP_POWER)
		self:SetGravity(1)
		self:SetBloodColor(0)

		self:DrawShadow(true)
		self:SetRenderMode(RENDERMODE_NORMAL)

		self.NoCollideAll = nil
		--self.NoCollideInside = nil
		self.AllowTeamDamage = nil
		self.NeverAlive = nil
		self.KnockbackScale = nil
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:SetMass(DEFAULT_MASS)
		end
	end

	net.Start("zs_dohulls")
		net.WriteEntity(self)
		net.WriteUInt(classid, 8)
		net.WriteBool(teamid == TEAM_UNDEAD)
	net.Broadcast()

	self:CollisionRulesChanged()
end

function meta:ChangeTeam(teamid)
	local oldteam = P_Team(self)
	if oldteam ~= teamid then
		gamemode.Call("PreOnPlayerChangedTeam", self, oldteam, teamid)
	end
	self:SetTeam(teamid)
	self:CollisionRulesChanged()
	if oldteam ~= teamid then
		gamemode.Call("OnPlayerChangedTeam", self, oldteam, teamid)
	end
end

function meta:Redeem(silent, noequip)
	if gamemode.Call("PrePlayerRedeemed", self) then return end

	self:RemoveStatus("overridemodel", false, true)

	self:KillSilent()

	self:ChangeTeam(TEAM_HUMAN)
	if not GAMEMODE.InitialVolunteers[self:UniqueID()] then
		self:AddZSXP(50 * (GAMEMODE.ZombieXPMulti or 1))
		self.RedeemBonus = true
	end
	if not noequip then self.m_PreRedeem = true end

	self:Spawn()

	self.m_PreRedeem = nil
	self:DoHulls()

	local frags = self:Frags()
	if frags < 0 then
		self:SetFrags(frags * 5)
	else
		self:SetFrags(0)
	end
	self:SetDeaths(0)

	--[[self.DeathClass = nil
	self:SetZombieClass(GAMEMODE.DefaultZombieClass)]]
	self.DeathClass = GAMEMODE.DefaultZombieClass

	self.SpawnedTime = CurTime()

	if not silent then
		net.Start("zs_playerredeemed")
			net.WriteEntity(self)
		net.Broadcast()
	end

	gamemode.Call("PostPlayerRedeemed", self)
end

function meta:RedeemNextFrame()
	timer.Simple(0, function()
		if IsValid(self) then
			self:CheckRedeem(true)
		end
	end)
end

local walltrace = {mask = MASK_SOLID_BRUSHONLY, mins = Vector(-8, -8, -8), maxs = Vector(8, 8, 8)}
function meta:ShouldCrouchJumpPunish()
	if not self:OnGround() and self:Crouching() and self:GetZombieClassTable().CrouchedWalkSpeed ~= 1 then
		local pos = self:WorldSpaceCenter()

		walltrace.start = pos
		walltrace.endpos = pos + self:GetForward() * 22

		return not util.TraceHull(walltrace).Hit
	end

	return false
end

function meta:TakeBrains(amount)
	self:AddFrags(-amount)
	self.BrainsEaten = self.BrainsEaten - 1
end

function meta:AddBrains(amount)
	self:AddFrags(amount)
	self.BrainsEaten = self.BrainsEaten + 1
	self:CheckRedeem()
end

meta.GetBrains = meta.Frags

function meta:CheckRedeem(instant)
	if not self:IsValid() or P_Team(self) ~= TEAM_UNDEAD
	or GAMEMODE:GetRedeemBrains() <= 0 or self:GetBrains() < GAMEMODE:GetRedeemBrains()
	or GAMEMODE.NoRedeeming or self.NoRedeeming or self:GetZombieClassTable().Boss then return end

	if GAMEMODE:GetWave() ~= GAMEMODE:GetNumberOfWaves() or not GAMEMODE.ObjectiveMap and GAMEMODE:GetNumberOfWaves() == 1 and CurTime() < GAMEMODE:GetWaveEnd() - 300 then
		if instant then
			self:Redeem()
		else
			self:RedeemNextFrame()
		end
	end
end

function meta:AntiGrief(dmginfo, overridenostrict)
	if GAMEMODE.GriefStrict and not overridenostrict then
		dmginfo:SetDamage(0)
		dmginfo:ScaleDamage(0)
		return
	end

	dmginfo:SetDamage(dmginfo:GetDamage() * GAMEMODE.GriefForgiveness)

	self:GivePenalty(math.ceil(dmginfo:GetDamage() * 0.5))
	self:ReflectDamage(dmginfo:GetDamage())
end

function meta:GivePenalty(amount)
	self.m_PenaltyCarry = (self.m_PenaltyCarry or 0) + amount * 0.1
	local frags = math.floor(self.m_PenaltyCarry)
	if frags > 0 then
		self.m_PenaltyCarry = self.m_PenaltyCarry - frags
		self:GivePointPenalty(frags)
	end
end

function meta:GivePointPenalty(amount)
	self:SetFrags(self:Frags() - amount)

	net.Start("zs_penalty")
		net.WriteUInt(amount, 16)
	net.Send(self)
end

function meta:ReflectDamage(damage)
	local frags = self:Frags()
	if frags < GAMEMODE.GriefReflectThreshold then
		self:TakeDamage(math.ceil(damage * frags * -0.05 * GAMEMODE.GriefDamageMultiplier))
	end
end

function meta:GiveWeaponByType(weapon, plyr, ammo)
	local wep = self:GetActiveWeapon()
	if not wep or not wep:IsValid() then return end

	if wep.NoTransfer then return end

	if ammo or wep.AmmoIfHas then
		if not wep.Primary then return end

		local ammotype = wep:ValidPrimaryAmmo()
		local ammocount = wep:GetPrimaryAmmoCount()
		if ammotype and ammocount then
			local desiredgive = math.min(ammocount, math.ceil((GAMEMODE.AmmoCache[ammotype] or wep.Primary.ClipSize) * (ammo and 5 or 1)))
			if desiredgive >= 1 then
				wep:TakeCombinedPrimaryAmmo(desiredgive)
				plyr:GiveAmmo(desiredgive, ammotype)

				net.Start("zs_ammogive")
					net.WriteUInt(desiredgive, 16)
					net.WriteString(ammotype)
					net.WriteEntity(plyr)
				net.Send(self)

				net.Start("zs_ammogiven")
					net.WriteUInt(desiredgive, 16)
					net.WriteString(ammotype)
					net.WriteEntity(self)
				net.Send(plyr)

				self:PlayGiveAmmoSound()
				self:RestartGesture(ACT_GMOD_GESTURE_ITEM_GIVE)
			end
		end
	end

	local primary = wep:ValidPrimaryAmmo()
	if primary and 0 < wep:Clip1() then
		self:GiveAmmo(wep:Clip1(), primary, true)
		wep:SetClip1(0)
	end
	local secondary = wep:ValidSecondaryAmmo()
	if secondary and 0 < wep:Clip2() then
		self:GiveAmmo(wep:Clip2(), secondary, true)
		wep:SetClip2(0)
	end

	self:StripWeapon(weapon:GetClass())
	self:UpdateAltSelectedWeapon()

	local wep2 = plyr:Give(weapon:GetClass())
	if wep2 and wep2:IsValid() then
		if wep2.Primary then
			primary = wep2:ValidPrimaryAmmo()
			if primary then
				wep2:SetClip1(0)
				plyr:RemoveAmmo(math.max(0, wep2.Primary.DefaultClip - wep2.Primary.ClipSize), primary)
			end
		end
		if wep2.Secondary then
			secondary = wep2:ValidSecondaryAmmo()
			if secondary then
				wep2:SetClip2(0)
				plyr:RemoveAmmo(math.max(0, wep2.Secondary.DefaultClip - wep2.Secondary.ClipSize), secondary)
			end
		end
	end
end

function meta:Gib()
	local pos = self:WorldSpaceCenter()

	local effectdata = EffectData()
		effectdata:SetEntity(self)
		effectdata:SetOrigin(pos)
	util.Effect("gib_player", effectdata, true, true)

	self.Gibbed = CurTime()

	timer.Simple(0, function() GAMEMODE:CreateGibs(pos, pos2) end)
end

function meta:GetLastAttacker()
	local ent = self.LastAttacker
	if ent and ent:IsValid() and CurTime() <= self.LastAttacked + 10 then
		return ent
	end
	--self:SetLastAttacker()
end

function meta:SetLastAttacker(ent)
	if ent then
		if ent ~= self then
			self.LastAttacker = ent
			self.LastAttacked = CurTime()
		end
	else
		self.LastAttacker = nil
		self.LastAttacked = nil
	end
end

meta.OldUnSpectate = meta.UnSpectate
function meta:UnSpectate()
	if self:GetObserverMode() ~= OBS_MODE_NONE then
		self:OldUnSpectate(obsm)
	end
end

local function nocollidetimer(self, timername)
	if self:IsValid() then
		for _, e in pairs(ents.FindInBox(self:WorldSpaceAABB())) do
			if e and e:IsValid() and e:IsPlayer() and e ~= self and GAMEMODE:ShouldCollide(self, e) then
				return
			end
		end

		self:SetCollisionGroup(COLLISION_GROUP_PLAYER)
	end

	timer.Remove(timername)
end

function meta:TemporaryNoCollide(force)
	if self:GetCollisionGroup() ~= COLLISION_GROUP_PLAYER and not force then return end

	for _, e in pairs(ents.FindInBox(self:WorldSpaceAABB())) do
		if e and e:IsValid() and e:IsPlayer() and e ~= self and GAMEMODE:ShouldCollide(self, e) then
			self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

			local timername = "TemporaryNoCollide"..self:UniqueID()
			timer.Create(timername, 0, 0, function() nocollidetimer(self, timername) end)

			return
		end
	end

	self:SetCollisionGroup(COLLISION_GROUP_PLAYER)
end

function meta:PlayEyePainSound()
	local rf = RecipientFilter()
	rf:AddPAS(self:GetPos())
	net.Start("voice_eyepain")
	net.WriteEntity(self)
	net.Send(rf)
end

function meta:PlayGiveAmmoSound()
	local rf = RecipientFilter()
	rf:AddPAS(self:GetPos())
	net.Start("voice_giveammo")
	net.WriteEntity(self)
	net.Send(rf)
end

function meta:PlayDeathSound()
	local rf = RecipientFilter()
	rf:AddPAS(self:GetPos())
	net.Start("voice_death")
	net.WriteEntity(self)
	net.Send(rf)
end

function meta:PlayZombieDeathSound()
	local rf = RecipientFilter()
	rf:AddPAS(self:GetPos())
	net.Start("voice_zombiedeath")
	net.WriteEntity(self)
	net.Send(rf)
end

function meta:PlayPainSound()
	if CurTime() < self.NextPainSound then return end
	self.NextPainSound = CurTime() + 0.5

	local rf = RecipientFilter()
	rf:AddPAS(self:GetPos())
	net.Start("voice_pain")
	net.WriteEntity(self)
	net.WriteUInt(math.ceil(self:Health() / 25), 4)
	net.Send(rf)
end

function meta:PlayZombiePainSound()
	if CurTime() < self.NextPainSound then return end
	self.NextPainSound = CurTime() + 0.5

	local rf = RecipientFilter()
	rf:AddPAS(self:GetPos())
	net.Start("voice_zombiepain")
	net.WriteEntity(self)
	net.Send(rf)
end

function meta:DoSigilTeleport(target, from, corrupted)
	if not target then return end

	if corrupted == nil then corrupted = false end

	if from and not from:IsValid() or not from:IsWeapon() and self:GetPos():DistToSqr(from:GetPos()) > 16384 or from:IsWeapon() and self:GetActiveWeapon() ~= from then
		return
	end

	if self:IsValidLivingHuman() and target:IsValid() and corrupted == target:GetSigilCorrupted() then
		if CurTime() >= (self._NextSigilTeleportEffect or 0) then
			self._NextSigilTeleportEffect = CurTime() + 0.25

			local effect = corrupted and "corrupted_teleport" or "sigil_teleport"

			local effectdata = EffectData()
			effectdata:SetOrigin(self:WorldSpaceCenter())
			effectdata:SetEntity(self)
			util.Effect(effect, effectdata, true, true)
			effectdata:SetOrigin(target:WorldSpaceCenter())
			util.Effect(effect, effectdata, true, true)
		end

		local movepos = target:GetPos() % 2

		self:SetBarricadeGhosting(true, true)
		for i=1, 5 do
			self:SetPos(movepos)
			self:SetLocalPos(movepos)
		end
		hook.Add("Move", self, function(_, p, mv)
			if p == self then
				hook.Remove("Move", p)
				mv:SetOrigin(movepos)
			end
		end)

		for _, e in pairs(ents.FindInSphere(movepos, 64)) do
			if e:IsValidLivingZombie() then
				e:TemporaryNoCollide(true)
			end
		end

		if from and from:IsValid() and from:IsWeapon() then
			from:TakePrimaryAmmo(1)

			if from:GetPrimaryAmmoCount() <= 0 then
				self:StripWeapon(from:GetClass())
			end
		end
	end
end

local bossdrops = {
	"trinket_bleaksoul",
	"trinket_spiritess"
}

function meta:MakeBossDrop()
	local drop = table.Random(bossdrops)
	local inv = string.sub(drop, 1, 4) ~= "weap"

	local pos = self:LocalToWorld(self:OBBCenter())
	local ent = ents.Create(inv and "prop_invitem" or "prop_weapon")
	if ent:IsValid() then
		ent:SetPos(pos)
		ent:SetAngles(AngleRand())
		if inv then
			ent:SetInventoryItemType(drop)
		else
			ent:SetWeaponType(drop)
		end
		ent:Spawn()

		local phys = ent:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:SetVelocityInstantaneous(VectorRand():GetNormalized() * math.Rand(24, 100))
			phys:AddAngleVelocity(VectorRand() * 200)
		end
	end
end

function meta:UpdateAltSelectedWeapon()
	net.Start("zs_updatealtselwep")
	net.Send(self)
end

function meta:SendDeployableLostMessage(deployable)
	local deployableclass = deployable:GetClass()
	local deployableinfo = GAMEMODE.DeployableInfo[deployableclass]

	net.Start("zs_deployablelost")
		net.WriteString(deployableinfo.Name)
		net.WriteString(deployableinfo.WepClass)
	net.Send(self)
end

function meta:SendDeployableClaimedMessage(deployable)
	local deployableclass = deployable:GetClass()
	local deployableinfo = GAMEMODE.DeployableInfo[deployableclass]

	net.Start("zs_deployableclaim")
		net.WriteString(deployableinfo.Name)
		net.WriteString(deployableinfo.WepClass)
	net.Send(self)
end

function meta:SendDeployableOutOfAmmoMessage(deployable)
	local deployableclass = deployable:GetClass()
	local deployableinfo = GAMEMODE.DeployableInfo[deployableclass]

	net.Start("zs_deployableout")
		net.WriteString(deployableinfo.Name)
		net.WriteString(deployableinfo.WepClass)
	net.Send(self)
end

function meta:GetRandomStartingItem()
	local pool = {}

	if self:IsSkillActive(SKILL_PREPAREDNESS) and #GAMEMODE.Food > 0 then
		pool[#pool + 1] = GAMEMODE.Food[math.random(#GAMEMODE.Food)]
	end

	if self:IsSkillActive(SKILL_EQUIPPED) then
		pool[#pool + 1] = GAMEMODE.StarterTrinkets[math.random(#GAMEMODE.StarterTrinkets)]
	end

	if #pool > 0 then
		return pool[math.random(#pool)]
	end
end

function meta:PulseResonance(attacker, inflictor)
	-- Weird things happen with multishot weapons..

	timer.Create("PulseResonance" .. attacker:UniqueID(), 0.06, 1, function()
		if not attacker:IsValid() or not self:IsValid() then return end

		attacker.AccuPulse = 0

		local pos = self:WorldSpaceCenter()
		pos.z = pos.z + 16

		if attacker:IsValidLivingHuman() then
			util.BlastDamagePlayer(inflictor, attacker, pos, 100, 75, DMG_ALWAYSGIB, 0.95)
			for _, ent in pairs(util.BlastAlloc(inflictor, attacker, pos, 100 * (attacker.ExpDamageRadiusMul or 1))) do
				if ent:IsValidLivingPlayer() and gamemode.Call("PlayerShouldTakeDamage", ent, attacker) then
					ent:AddLegDamageExt(5, attacker, inflictor, SLOWTYPE_PULSE)
				end
			end
		end

		local effectdata = EffectData()
			effectdata:SetOrigin(pos)
			effectdata:SetNormal(attacker:GetShootPos())
		util.Effect("explosion_shockcore", effectdata)
	end)
end

function meta:CryogenicInduction(attacker, inflictor, damage)
	if self:Health() > self:GetMaxHealthEx() * (damage/100) or math.random(50) > damage then return end

	timer.Create("Cryogenic" .. attacker:UniqueID(), 0.06, 1, function()
		if not attacker:IsValid() or not self:IsValid() then return end

		local pos = self:WorldSpaceCenter()
		pos.z = pos.z + 16

		self:TakeSpecialDamage(self:Health() + 90, DMG_DIRECT, attacker, inflictor, pos)

		if attacker:IsValidLivingHuman() then
			util.BlastDamagePlayer(inflictor, attacker, pos, 100, self:GetMaxHealthEx() * 0.12, DMG_DROWN, 0.95)
			for _, ent in pairs(util.BlastAlloc(inflictor, attacker, pos, 100 * (attacker.ExpDamageRadiusMul or 1))) do
				if ent:IsValidLivingPlayer() and gamemode.Call("PlayerShouldTakeDamage", ent, attacker) then
					ent:AddLegDamageExt(6, attacker, inflictor, SLOWTYPE_COLD)
				end
			end
		end

		local effectdata = EffectData()
			effectdata:SetOrigin(pos)
			effectdata:SetNormal(attacker:GetShootPos())
		util.Effect("hit_ice", effectdata)
	end)
end

function meta:SetPhantomHealth(amount)
	self:SetDTFloat(DT_PLAYER_FLOAT_PHANTOMHEALTH, amount)
end

function meta:HasBarricadeExpert()
	return self:GetZSRemortLevel() > 0
end

function meta:BarricadeExpertPrecedence(otherpl)
	local mygrade, myexpert = self:GetZSRemortLevelGraded(), self:HasBarricadeExpert()
	local othergrade, otherexpert = otherpl:GetZSRemortLevelGraded(), otherpl:HasBarricadeExpert()

	if (myexpert and not otherexpert) or mygrade > othergrade then
		return 1
	elseif (not myexpert and not otherexpert) or (myexpert and mygrade == othergrade) then
		return 0
	end

	return -1
end
