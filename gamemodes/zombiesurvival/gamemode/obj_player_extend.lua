local meta = FindMetaTable("Player")

local util_SharedRandom = util.SharedRandom
local PLAYERANIMEVENT_FLINCH_HEAD = PLAYERANIMEVENT_FLINCH_HEAD
local PLAYERANIMEVENT_ATTACK_PRIMARY = PLAYERANIMEVENT_ATTACK_PRIMARY
local GESTURE_SLOT_FLINCH = GESTURE_SLOT_FLINCH
local GESTURE_SLOT_ATTACK_AND_RELOAD = GESTURE_SLOT_ATTACK_AND_RELOAD
local HITGROUP_HEAD = HITGROUP_HEAD
local HITGROUP_CHEST = HITGROUP_CHEST
local HITGROUP_STOMACH = HITGROUP_STOMACH
local HITGROUP_LEFTLEG = HITGROUP_LEFTLEG
local HITGROUP_RIGHTLEG = HITGROUP_RIGHTLEG
local HITGROUP_LEFTARM = HITGROUP_LEFTARM
local HITGROUP_RIGHTARM = HITGROUP_RIGHTARM
local TEAM_UNDEAD = TEAM_UNDEAD
local TEAM_SPECTATOR = TEAM_SPECTATOR
local TEAM_HUMAN = TEAM_HUMAN
local IN_ZOOM = IN_ZOOM
local MASK_SOLID = MASK_SOLID
local MASK_SOLID_BRUSHONLY = MASK_SOLID_BRUSHONLY
local util_TraceLine = util.TraceLine
local util_TraceHull = util.TraceHull

local getmetatable = getmetatable

local M_Entity = FindMetaTable("Entity")

local P_Team = meta.Team

local E_IsValid = M_Entity.IsValid
local E_GetDTBool = M_Entity.GetDTBool
local E_GetTable = M_Entity.GetTable

function meta:LogID()
	return "<"..self:SteamID().."> "..self:Name()
end

function meta:GetMaxHealthEx()
	if P_Team(self) == TEAM_UNDEAD then
		return self:GetMaxZombieHealth()
	end

	return self:GetMaxHealth()
end

function meta:Dismember(dismembermenttype)
	local effectdata = EffectData()
		effectdata:SetOrigin(self:EyePos())
		effectdata:SetEntity(self)
		effectdata:SetScale(dismembermenttype)
	util.Effect("dismemberment", effectdata, true, true)
end

function meta:DoRandomEvent(event, maxrandom_s1)
	self:DoCustomAnimEvent(event, math.ceil(util_SharedRandom("anim", 0, maxrandom_s1, self:EntIndex())))
end

function meta:DoZombieEvent()
	self:DoRandomEvent(PLAYERANIMEVENT_ATTACK_PRIMARY, 7)
end

function meta:DoFlinchEvent(hitgroup)
	local base = util_SharedRandom("flinch", 1, self:EntIndex())
	if hitgroup == HITGROUP_HEAD then
		self:DoCustomAnimEvent(PLAYERANIMEVENT_FLINCH_HEAD, base * 2 + 4)
	elseif hitgroup == HITGROUP_CHEST  then
		self:DoCustomAnimEvent(PLAYERANIMEVENT_FLINCH_HEAD, base * 2 + 1)
	elseif hitgroup == HITGROUP_STOMACH then
		self:DoCustomAnimEvent(PLAYERANIMEVENT_FLINCH_HEAD, base * 2 + 10)
	elseif hitgroup == HITGROUP_LEFTARM then
		self:DoCustomAnimEvent(PLAYERANIMEVENT_FLINCH_HEAD, base + 8)
	elseif hitgroup == HITGROUP_RIGHTARM then
		self:DoCustomAnimEvent(PLAYERANIMEVENT_FLINCH_HEAD, base + 9)
	elseif hitgroup == HITGROUP_LEFTLEG then
		self:DoCustomAnimEvent(PLAYERANIMEVENT_FLINCH_HEAD, base + 6)
	elseif hitgroup == HITGROUP_RIGHTLEG then
		self:DoCustomAnimEvent(PLAYERANIMEVENT_FLINCH_HEAD, base + 7)
	elseif hitgroup == HITGROUP_BELT then
		self:DoCustomAnimEvent(PLAYERANIMEVENT_FLINCH_HEAD, base + 3)
	else
		self:DoCustomAnimEvent(PLAYERANIMEVENT_FLINCH_HEAD, base * 2)
	end
end

function meta:DoRandomFlinchEvent()
	self:DoRandomEvent(PLAYERANIMEVENT_FLINCH_HEAD, 12)
end

local FlinchSequences = {
	"flinch_01",
	"flinch_02",
	"flinch_back_01",
	"flinch_head_01",
	"flinch_head_02",
	"flinch_phys_01",
	"flinch_phys_02",
	"flinch_shoulder_l",
	"flinch_shoulder_r",
	"flinch_stomach_01",
	"flinch_stomach_02",
}
function meta:DoFlinchAnim(data)
	local seq = FlinchSequences[data] or FlinchSequences[1]
	if seq then
		local seqid = self:LookupSequence(seq)
		if seqid > 0 then
			self:AddVCDSequenceToGestureSlot(GESTURE_SLOT_FLINCH, seqid, 0, true)
		end
	end
end

local ZombieAttackSequences = {
	"zombie_attack_01",
	"zombie_attack_02",
	"zombie_attack_03",
	"zombie_attack_04",
	"zombie_attack_05",
	"zombie_attack_06"
}
function meta:DoZombieAttackAnim(data)
	local seq = ZombieAttackSequences[data] or ZombieAttackSequences[1]
	if seq then
		local seqid = self:LookupSequence(seq)
		if seqid > 0 then
			self:AddVCDSequenceToGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD, seqid, 0, true)
		end
	end
end

function meta:IsSpectator()
	return P_Team(self) == TEAM_SPECTATOR
end

function meta:GetAuraRange()
	if GAMEMODE.ZombieEscape then
		return 8192
	end

	local wep = self:GetActiveWeapon()
	return wep:IsValid() and wep.GetAuraRange and wep:GetAuraRange() or 2048
end

function meta:GetAuraRangeSqr()
	local r = self:GetAuraRange()
	return r * r
end

function meta:GetPoisonDamage()
	return self.Poison and self.Poison:IsValid() and self.Poison:GetDamage() or 0
end

function meta:GetBleedDamage()
	return self.Bleed and self.Bleed:IsValid() and self.Bleed:GetDamage() or 0
end

function meta:CallWeaponFunction(funcname, ...)
	local wep = self:GetActiveWeapon()
	if wep:IsValid() and wep[funcname] then
		return wep[funcname](wep, self, ...)
	end
end

function meta:ClippedName()
	local name = self:Name()
	if #name > 16 then
		name = string.sub(name, 1, 14)..".."
	end

	return name
end

function meta:SigilTeleportDestination(not_from_sigil, corrupted)
	local sigils = corrupted and GAMEMODE:GetCorruptedSigils() or GAMEMODE:GetUncorruptedSigils()

	if not_from_sigil then
		if #sigils == 0 then return end
	elseif #sigils <= 1 then return end

	local mypos = self:GetPos()
	local eyevector = self:GetAimVector()

	local dist = 999999999999
	local spos, d, icurrent, target, itarget

	if not not_from_sigil then
		for i, sigil in pairs(sigils) do
			d = sigil:GetPos():DistToSqr(mypos)
			if d < dist then
				dist = d
				icurrent = i
			end
		end
	end

	dist = -1
	for i, sigil in pairs(sigils) do
		if i == icurrent then continue end

		spos = sigil:GetPos() - mypos
		spos:Normalize()
		d = spos:Dot(eyevector)
		if d > dist then
			dist = d
			target = sigil
			itarget = i
		end
	end

	return target, itarget
end

function meta:DispatchAltUse()
	local tpexist = self:GetStatus("sigilteleport")
	if tpexist and tpexist:IsValid() then
		self:RemoveStatus("sigilteleport", false, true)
		return
	end

	local tr = self:CompensatedMeleeTrace(64, 4, nil, nil, nil, true)
	local ent = tr.Entity
	if ent and ent:IsValid() and ent.AltUse then
		return ent:AltUse(self, tr)
	end
end

function meta:MeleeViewPunch(damage)
	local maxpunch = (damage + 25) * 0.5
	local minpunch = -maxpunch
	self:ViewPunch(Angle(math.Rand(minpunch, maxpunch), math.Rand(minpunch, maxpunch), math.Rand(minpunch, maxpunch)))
end

function meta:NearArsenalCrate()
	local pos = self:EyePos()

	if self.ArsenalZone and self.ArsenalZone:IsValid() then return true end

	local arseents = {}
	table.Add(arseents, ents.FindByClass("prop_arsenalcrate"))
	table.Add(arseents, ents.FindByClass("status_arsenalpack"))

	for _, ent in pairs(arseents) do
		local nearest = ent:NearestPoint(pos)
		if pos:DistToSqr(nearest) <= 10000 and (WorldVisible(pos, nearest) or self:TraceLine(100).Entity == ent) then -- 80^2
			return true
		end
	end

	return false
end
meta.IsNearArsenalCrate = meta.NearArsenalCrate

function meta:NearRemantler()
	local pos = self:EyePos()

	local remantlers = ents.FindByClass("prop_remantler")

	for _, ent in pairs(remantlers) do
		local nearest = ent:NearestPoint(pos)
		if pos:DistToSqr(nearest) <= 10000 and (WorldVisible(pos, nearest) or self:TraceLine(100).Entity == ent) then -- 80^2
			return true
		end
	end

	return false
end

function meta:GetResupplyAmmoType()
	local ammotype
	if not self.ResupplyChoice then
		local wep = self:GetActiveWeapon()
		if wep:IsValid() then
			ammotype = wep.GetResupplyAmmoType and wep:GetResupplyAmmoType() or wep.ResupplyAmmoType or wep:GetPrimaryAmmoTypeString()
		end
	end

	ammotype = ammotype and ammotype:lower() or self.ResupplyChoice

	if not ammotype or not GAMEMODE.AmmoResupply[ammotype] then
		return "scrap"
	end

	return ammotype
end

function meta:SetZombieClassName(classname)
	if GAMEMODE.ZombieClasses[classname] then
		self:SetZombieClass(GAMEMODE.ZombieClasses[classname].Index)
	end
end

function meta:GetPoints()
	return self:GetDTInt(1)
end

function meta:GetBloodArmor()
	return self:GetDTInt(DT_PLAYER_INT_BLOODARMOR)
end

function meta:AddLegDamage(damage)
	if self.SpawnProtection then return end

	local legdmg = self:GetLegDamage() + damage

	if self:GetFlatLegDamage() - damage * 0.25 > damage then
		legdmg = self:GetFlatLegDamage()
	end

	self:SetLegDamage(legdmg)
end

function meta:AddLegDamageExt(damage, attacker, inflictor, type)
	inflictor = inflictor or attacker

	if type == SLOWTYPE_PULSE then
		local legdmg = damage * (attacker.PulseWeaponSlowMul or 1)
		local startleg = self:GetFlatLegDamage()

		self:AddLegDamage(legdmg)
		if attacker.PulseImpedance then
			self:AddArmDamage(legdmg)
		end

		if SERVER and attacker:HasTrinket("resonance") then
			attacker.AccuPulse = (attacker.AccuPulse or 0) + (self:GetFlatLegDamage() - startleg)

			if attacker.AccuPulse > 80 then
				self:PulseResonance(attacker, inflictor)
			end
		end
	elseif type == SLOWTYPE_COLD then
		if self:IsValidLivingZombie() and self:GetZombieClassTable().ResistFrost then return end

		self:AddLegDamage(damage)
		self:AddArmDamage(damage)

		if SERVER and attacker:HasTrinket("cryoindu") then
			self:CryogenicInduction(attacker, inflictor, damage)
		end
	end
end

function meta:SetLegDamage(damage)
	self.LegDamage = CurTime() + math.min(GAMEMODE.MaxLegDamage, damage * 0.125)
	if SERVER then
		self:UpdateLegDamage()
	end
end

function meta:RawSetLegDamage(time)
	self.LegDamage = math.min(CurTime() + GAMEMODE.MaxLegDamage, time)
	if SERVER then
		self:UpdateLegDamage()
	end
end

function meta:RawCapLegDamage(time)
	self:RawSetLegDamage(math.max(self.LegDamage or 0, time))
end

function meta:GetLegDamage()
	return math.max(0, (self.LegDamage or 0) - CurTime())
end

function meta:GetFlatLegDamage()
	return math.max(0, ((self.LegDamage or 0) - CurTime()) * 8)
end

function meta:AddArmDamage(damage)
	if self.SpawnProtection then return end

	local armdmg = self:GetArmDamage() + damage

	if self:GetFlatArmDamage() - damage * 0.25 > damage  then
		armdmg = self:GetFlatArmDamage()
	end

	self:SetArmDamage(armdmg)
end

function meta:SetArmDamage(damage)
	self.ArmDamage = CurTime() + math.min(GAMEMODE.MaxArmDamage, damage * 0.125)
	if SERVER then
		self:UpdateArmDamage()
	end
end

function meta:RawSetArmDamage(time)
	self.ArmDamage = math.min(CurTime() + GAMEMODE.MaxArmDamage, time)
	if SERVER then
		self:UpdateArmDamage()
	end
end

function meta:RawCapArmDamage(time)
	self:RawSetArmDamage(math.max(self.ArmDamage or 0, time))
end

function meta:GetArmDamage()
	return math.max(0, (self.ArmDamage or 0) - CurTime())
end

function meta:GetFlatArmDamage()
	return math.max(0, ((self.ArmDamage or 0) - CurTime()) * 8)
end

function meta:Flinch()
	if CurTime() >= (self.NextFlinch or 0) then
		self.NextFlinch = CurTime() + 0.75

		if P_Team(self) == TEAM_UNDEAD then
			self:DoFlinchEvent(self:LastHitGroup())
		else
			self:DoRandomFlinchEvent()
		end
	end
end

function meta:GetZombieClass()
	return self.Class or GAMEMODE.DefaultZombieClass
end

local ZombieClasses = {}
if GAMEMODE then
	ZombieClasses = GAMEMODE.ZombieClasses
end
hook.Add("Initialize", "LocalizeZombieClasses", function() ZombieClasses = GAMEMODE.ZombieClasses end)
function meta:GetZombieClassTable()
	return ZombieClasses[self:GetZombieClass()]
end

-- Called a lot, so optimized
-- vararg was culled out because it created tables. Should call the one with appropriate # of args.
local zctab
local zcfunc
function meta:CallZombieFunction0(funcname)
	if P_Team(self) == TEAM_UNDEAD then
		zctab = ZombieClasses[E_GetTable(self).Class or GAMEMODE.DefaultZombieClass]
		zcfunc = zctab[funcname]
		if zcfunc then
			return zcfunc(zctab, self)
		end
	end
end

function meta:CallZombieFunction1(funcname, a1)
	if P_Team(self) == TEAM_UNDEAD then
		zctab = ZombieClasses[E_GetTable(self).Class or GAMEMODE.DefaultZombieClass]
		zcfunc = zctab[funcname]
		if zcfunc then
			return zcfunc(zctab, self, a1)
		end
	end
end

function meta:CallZombieFunction2(funcname, a1, a2)
	if P_Team(self) == TEAM_UNDEAD then
		zctab = ZombieClasses[E_GetTable(self).Class or GAMEMODE.DefaultZombieClass]
		zcfunc = zctab[funcname]
		if zcfunc then
			return zcfunc(zctab, self, a1, a2)
		end
	end
end

function meta:CallZombieFunction3(funcname, a1, a2, a3)
	if P_Team(self) == TEAM_UNDEAD then
		zctab = ZombieClasses[E_GetTable(self).Class or GAMEMODE.DefaultZombieClass]
		zcfunc = zctab[funcname]
		if zcfunc then
			return zcfunc(zctab, self, a1, a2, a3)
		end
	end
end

function meta:CallZombieFunction4(funcname, a1, a2, a3, a4)
	if P_Team(self) == TEAM_UNDEAD then
		zctab = ZombieClasses[E_GetTable(self).Class or GAMEMODE.DefaultZombieClass]
		zcfunc = zctab[funcname]
		if zcfunc then
			return zcfunc(zctab, self, a1, a2, a3, a4)
		end
	end
end
meta.CallZombieFunction = meta.CallZombieFunction4 -- 4 should be enough for legacy.

function meta:CallZombieFunction5(funcname, a1, a2, a3, a4, a5)
	if P_Team(self) == TEAM_UNDEAD then
		zctab = ZombieClasses[E_GetTable(self).Class or GAMEMODE.DefaultZombieClass]
		zcfunc = zctab[funcname]
		if zcfunc then
			return zcfunc(zctab, self, a1, a2, a3, a4, a5)
		end
	end
end

function meta:TraceLine(distance, mask, filter, start)
	start = start or self:GetShootPos()
	return util_TraceLine({start = start, endpos = start + self:GetAimVector() * distance, filter = filter or self, mask = mask})
end

function meta:TraceHull(distance, mask, size, filter, start)
	start = start or self:GetShootPos()
	return util_TraceHull({start = start, endpos = start + self:GetAimVector() * distance, filter = filter or self, mask = mask, mins = Vector(-size, -size, -size), maxs = Vector(size, size, size)})
end

function meta:SetSpeed(speed)
	if not speed then speed = 200 end

	local runspeed = self:GetBloodArmor() > 0 and self:IsSkillActive(SKILL_CARDIOTONIC) and speed + 40 or speed

	self:SetWalkSpeed(speed)
	self:SetRunSpeed(runspeed)
	self:SetMaxSpeed(runspeed)
end

function meta:SetHumanSpeed(speed)
	if P_Team(self) == TEAM_HUMAN then self:SetSpeed(speed) end
end

function meta:ResetSpeed(noset, health)
	if not self:IsValid() then return end

	if P_Team(self) == TEAM_UNDEAD then
		local speed = math.max(140, self:GetZombieClassTable().Speed * GAMEMODE.ZombieSpeedMultiplier - (GAMEMODE.ObjectiveMap and 20 or 0))

		self:SetSpeed(speed)
		return speed
	end

	local wep = self:GetActiveWeapon()
	local speed

	if wep:IsValid() and wep.GetWalkSpeed then
		speed = wep:GetWalkSpeed()
	end

	if not speed then
		speed = wep.WalkSpeed or SPEED_NORMAL
	end

	if speed < SPEED_NORMAL then
		speed = SPEED_NORMAL - (SPEED_NORMAL - speed) * (self.WeaponWeightSlowMul or 1)
	end

	if self.SkillSpeedAdd and P_Team(self) == TEAM_HUMAN then
		speed = speed + self.SkillSpeedAdd
	end

	if self:IsSkillActive(SKILL_LIGHTWEIGHT) and wep:IsValid() and wep.IsMelee then
		speed = speed + 6
	end

	speed = math.max(1, speed)

	if 32 < speed and not GAMEMODE.ZombieEscape then
		health = health or self:Health()
		local maxhealth = self:GetMaxHealth() * 0.6666
		if health < maxhealth then
			speed = math.max(88, speed - speed * 0.4 * (1 - health / maxhealth) * (self.LowHealthSlowMul or 1))
		end
	end

	if not noset then
		self:SetSpeed(speed)
	end

	return speed
end

function meta:ResetJumpPower(noset)
	local power = DEFAULT_JUMP_POWER

	if P_Team(self) == TEAM_UNDEAD then
		power = self:CallZombieFunction0("GetJumpPower") or power

		local classtab = self:GetZombieClassTable()
		if classtab and classtab.JumpPower then
			power = classtab.JumpPower
		end
	else
		power = power * (self.JumpPowerMul or 1)

		if self:GetBarricadeGhosting() then
			power = power * 0.25
			if not noset then
				self:SetJumpPower(power)
			end

			return power
		end
	end

	local wep = self:GetActiveWeapon()
	if wep and wep.ResetJumpPower then
		power = wep:ResetJumpPower(power) or power
	end

	if not noset then
		self:SetJumpPower(power)
	end

	return power
end

function meta:SetBarricadeGhosting(b, fullspeed)
	if self == NULL then return end --???

	if b and self.NoGhosting and not self:GetBarricadeGhosting() then
		self:SetDTFloat(DT_PLAYER_FLOAT_WIDELOAD, CurTime() + 6)
	end

	if fullspeed == nil then fullspeed = false end

	self:SetDTBool(0, b)
	self:SetDTBool(1, b and fullspeed)
	--self:SetCustomCollisionCheck(b)
	self:CollisionRulesChanged()

	self:ResetJumpPower()
end

function meta:GetBarricadeGhosting()
	return E_GetDTBool(self, 0)
end
meta.IsBarricadeGhosting = meta.GetBarricadeGhosting

function meta:ShouldBarricadeGhostWith(ent)
	return ent:IsBarricadeProp()
end

function meta:BarricadeGhostingThink()
	if E_GetDTBool(self, 1) then
		if not self:ActiveBarricadeGhosting() then
			self:SetBarricadeGhosting(false)
		end
	else
		if self:KeyDown(IN_ZOOM) or self:ActiveBarricadeGhosting() then
			if self.FirstGhostThink then
				self:SetLocalVelocity(vector_origin)
				self.FirstGhostThink = false
			end

			return
		end

		self.FirstGhostThink = true
		self:SetBarricadeGhosting(false)
	end
end

-- Needs to be as optimized as possible.
function meta:ShouldNotCollide(ent)
	if E_IsValid(ent) then
		if getmetatable(ent) == meta then
			if P_Team(self) == P_Team(ent) or E_GetTable(self).NoCollideAll or E_GetTable(ent).NoCollideAll then
				return true
			end

			return false
		end

		return E_GetDTBool(self, 0) and ent:IsBarricadeProp()
	end

	return false
end

meta.OldSetHealth = FindMetaTable("Entity").SetHealth
function meta:SetHealth(health)
	self:OldSetHealth(health)
	if P_Team(self) == TEAM_HUMAN and 1 <= health then
		self:ResetSpeed(nil, health)
	end
end

function meta:IsHeadcrab()
	return P_Team(self) == TEAM_UNDEAD and GAMEMODE.ZombieClasses[self:GetZombieClass()].IsHeadcrab
end

function meta:IsTorso()
	return P_Team(self) == TEAM_UNDEAD and GAMEMODE.ZombieClasses[self:GetZombieClass()].IsTorso
end

function meta:AirBrake()
	local vel = self:GetVelocity()

	vel.x = vel.x * 0.15
	vel.y = vel.y * 0.15
	if vel.z > 0 then
		vel.z = vel.z * 0.15
	end

	self:SetLocalVelocity(vel)
end

local temp_attacker = NULL
local temp_attacker_team = -1
local temp_pen_ents = {}
local temp_override_team

local function MeleeTraceFilter(ent)
	if ent == temp_attacker
	or E_GetTable(ent).IgnoreMelee
	or getmetatable(ent) == meta and P_Team(ent) == temp_attacker_team
	or not temp_override_team and ent.IgnoreMeleeTeam and ent.IgnoreMeleeTeam == temp_attacker_team
	or temp_pen_ents[ent] then
		return false
	end

	return true
end

local function DynamicTraceFilter(ent)
	if ent.IgnoreTraces or ent:IsPlayer() then
		return false
	end

	return true
end

local function MeleeTraceFilterFFA(ent)
	if temp_pen_ents[ent] then
		return false
	end

	return ent ~= temp_attacker
end

local melee_trace = {filter = MeleeTraceFilter, mask = MASK_SOLID, mins = Vector(), maxs = Vector()}

function meta:GetDynamicTraceFilter()
	return DynamicTraceFilter
end

local function CheckFHB(tr)
	if tr.Entity.FHB and tr.Entity:IsValid() then
		tr.Entity = tr.Entity:GetParent()
	end
end

function meta:MeleeTrace(distance, size, start, dir, hit_team_members, override_team, override_mask)
	start = start or self:GetShootPos()
	dir = dir or self:GetAimVector()
	hit_team_members = hit_team_members or GAMEMODE.RoundEnded

	local tr

	temp_attacker = self
	temp_attacker_team = P_Team(self)
	temp_override_team = override_team
	melee_trace.start = start
	melee_trace.endpos = start + dir * distance
	melee_trace.mask = override_mask or MASK_SOLID
	melee_trace.mins.x = -size
	melee_trace.mins.y = -size
	melee_trace.mins.z = -size
	melee_trace.maxs.x = size
	melee_trace.maxs.y = size
	melee_trace.maxs.z = size
	melee_trace.filter = hit_team_members and MeleeTraceFilterFFA or MeleeTraceFilter

	tr = util_TraceLine(melee_trace)

	CheckFHB(tr)

	if tr.Hit then
		return tr
	end

	return util_TraceHull(melee_trace)
end

local function InvalidateCompensatedTrace(tr, start, distance)
	-- Need to do this or people with 300 ping will be hitting people across rooms
	if tr.Entity:IsValid() and tr.Entity:IsPlayer() and tr.HitPos:DistToSqr(start) > distance * distance + 144 then -- Give just a little bit of leeway
		tr.Hit = false
		tr.HitNonWorld = false
		tr.Entity = NULL
	end
end

function meta:CompensatedMeleeTrace(distance, size, start, dir, hit_team_members, override_team)
	start = start or self:GetShootPos()
	dir = dir or self:GetAimVector()

	self:LagCompensation(true)
	local tr = self:MeleeTrace(distance, size, start, dir, hit_team_members, override_team)
	CheckFHB(tr)
	self:LagCompensation(false)

	InvalidateCompensatedTrace(tr, start, distance)

	return tr
end

function meta:CompensatedPenetratingMeleeTrace(distance, size, start, dir, hit_team_members)
	start = start or self:GetShootPos()
	dir = dir or self:GetAimVector()

	self:LagCompensation(true)
	local t = self:PenetratingMeleeTrace(distance, size, start, dir, hit_team_members)
	self:LagCompensation(false)

	for _, tr in pairs(t) do
		InvalidateCompensatedTrace(tr, start, distance)
	end

	return t
end

function meta:CompensatedZombieMeleeTrace(distance, size, start, dir, hit_team_members)
	start = start or self:GetShootPos()
	dir = dir or self:GetAimVector()

	self:LagCompensation(true)

	local hit_entities = {}

	local t, hitprop = self:PenetratingMeleeTrace(distance, size, start, dir, hit_team_members)
	local t_legs = self:PenetratingMeleeTrace(distance, size, self:WorldSpaceCenter(), dir, hit_team_members)

	for _, tr in pairs(t) do
		hit_entities[tr.Entity] = true
	end

	if not hitprop then
		for _, tr in pairs(t_legs) do
			if not hit_entities[tr.Entity] then
				t[#t + 1] = tr
			end
		end
	end

	for _, tr in pairs(t) do
		InvalidateCompensatedTrace(tr, tr.StartPos, distance)
	end

	self:LagCompensation(false)

	return t
end

function meta:PenetratingMeleeTrace(distance, size, start, dir, hit_team_members)
	start = start or self:GetShootPos()
	dir = dir or self:GetAimVector()
	hit_team_members = hit_team_members or GAMEMODE.RoundEnded

	local tr, ent

	temp_attacker = self
	temp_attacker_team = P_Team(self)
	temp_pen_ents = {}
	melee_trace.start = start
	melee_trace.endpos = start + dir * distance
	melee_trace.mask = MASK_SOLID
	melee_trace.mins.x = -size
	melee_trace.mins.y = -size
	melee_trace.mins.z = -size
	melee_trace.maxs.x = size
	melee_trace.maxs.y = size
	melee_trace.maxs.z = size
	melee_trace.filter = hit_team_members and MeleeTraceFilterFFA or MeleeTraceFilter

	local t = {}
	local onlyhitworld
	for i=1, 50 do
		tr = util_TraceLine(melee_trace)

		if not tr.Hit then
			tr = util_TraceHull(melee_trace)
		end

		if not tr.Hit then break end

		if tr.HitWorld then
			table.insert(t, tr)
			break
		end

		if onlyhitworld then break end

		CheckFHB(tr)

		ent = tr.Entity
		if ent:IsValid() then
			if not ent:IsPlayer() then
				melee_trace.mask = MASK_SOLID_BRUSHONLY
				onlyhitworld = true
			end

			table.insert(t, tr)
			temp_pen_ents[ent] = true
		end
	end

	temp_pen_ents = {}

	return t, onlyhitworld
end

function meta:ActiveBarricadeGhosting(override)
	if P_Team(self) ~= TEAM_HUMAN and not override or not self:GetBarricadeGhosting() then return false end

	local min, max = self:WorldSpaceAABB()
	min.x = min.x + 1
	min.y = min.y + 1

	max.x = max.x - 1
	max.y = max.y - 1

	for _, ent in pairs(ents.FindInBox(min, max)) do
		if ent and ent:IsValid() and self:ShouldBarricadeGhostWith(ent) then return true end
	end

	return false
end

function meta:IsHolding()
	return self:GetHolding():IsValid()
end
meta.IsCarrying = meta.IsHolding

function meta:GetHolding()
	local status = self.status_human_holding
	if status and status:IsValid() then
		local obj = status:GetObject()
		if obj:IsValid() then return obj end
	end

	return NULL
end

function meta:NearestRemantler()
	local pos = self:EyePos()

	local remantlers = ents.FindByClass("prop_remantler")
	local min, remantler = 99999

	for _, ent in pairs(remantlers) do
		local nearpoint = ent:NearestPoint(pos)
		local trmatch = self:TraceLine(100).Entity == ent
		local dist = trmatch and 0 or pos:DistToSqr(nearpoint)
		if pos:DistToSqr(nearpoint) <= 10000 and dist < min then
			remantler = ent
		end
	end

	return remantler
end

function meta:GetMaxZombieHealth()
	return self:GetZombieClassTable().Health
end

local oldmaxhealth = FindMetaTable("Entity").GetMaxHealth
function meta:GetMaxHealth()
	if P_Team(self) == TEAM_UNDEAD then
		return self:GetMaxZombieHealth()
	end

	return oldmaxhealth(self)
end

if not meta.OldAlive then
	meta.OldAlive = meta.Alive
	function meta:Alive()
		return self:GetObserverMode() == OBS_MODE_NONE and not self.NeverAlive and self:OldAlive()
	end
end

-- Override these because they're different in 1st person and on the server.
function meta:SyncAngles()
	local ang = self:EyeAngles()
	ang.pitch = 0
	ang.roll = 0
	return ang
end
meta.GetAngles = meta.SyncAngles

function meta:GetForward()
	return self:SyncAngles():Forward()
end

function meta:GetUp()
	return self:SyncAngles():Up()
end

function meta:GetRight()
	return self:SyncAngles():Right()
end

function meta:GetZombieMeleeSpeedMul()
	return 1 * (1 + math.Clamp(self:GetArmDamage() / GAMEMODE.MaxArmDamage, 0, 1)) / (self:GetStatus("zombie_battlecry") and 1.2 or 1)
end

function meta:GetMeleeSpeedMul()
	if P_Team(self) == TEAM_UNDEAD then
		return self:GetZombieMeleeSpeedMul()
	end

	return 1 * (1 + math.Clamp(self:GetArmDamage() / GAMEMODE.MaxArmDamage, 0, 1)) / (self:GetStatus("frost") and 0.7 or 1)
end

function meta:GetPhantomHealth()
	return self:GetDTFloat(DT_PLAYER_FLOAT_PHANTOMHEALTH)
end
