AddCSLuaFile()

SWEP.Base = "weapon_zs_zombie"

SWEP.PrintName = "Flesh Creeper"

SWEP.MeleeDelay = 0.5
SWEP.MeleeReach = 52
SWEP.MeleeDamage = 15
SWEP.MeleeForceScale = 1.25
SWEP.MeleeSize = 3
SWEP.MeleeDamageType = DMG_SLASH
SWEP.Primary.Delay = 0.75

SWEP.Secondary.Automatic = false

AccessorFuncDT(SWEP, "RightClickStart", "Float", 2)
AccessorFuncDT(SWEP, "AttackAnimTime", "Float", 3)

SWEP.NextDigSound = 0
SWEP.NextMessage = 0

function SWEP:Think()
	self.BaseClass.Think(self)

	if self:GetHoldingRightClick() and not self.Owner:KeyDown(IN_ATTACK2) then
		self:SetRightClickStart(0)

		if self.BuildSoundPlaying then
			self.BuildSoundPlaying = false
			self.BuildSound:ChangeVolume(0, 0.5)
		end
	elseif self:IsBuilding() then
		if not self.BuildSoundPlaying then
			self.BuildSoundPlaying = true
			self.BuildSound:ChangeVolume(0.45, 0.5)
		end

		if SERVER then
			self:BuildingThink()
		end
	end

	self:NextThink(CurTime())
	return true
end

function SWEP:SendMessage(msg, friendly)
	if CurTime() >= self.NextMessage then
		self.NextMessage = CurTime() + 2
		self.Owner:CenterNotify(friendly and COLOR_GREEN or COLOR_RED, translate.ClientGet(self.Owner, msg))
	end
end

function SWEP:Initialize()
	self.BaseClass.Initialize(self)

	self.BuildSound = CreateSound(self, "npc/antlion/charge_loop1.wav")
	self.BuildSound:PlayEx(0, 100)
end

function SWEP:OnRemove()
	self.BaseClass.OnRemove(self)

	self.BuildSound:Stop()
end

function SWEP:BuildingThink()
	local owner = self.Owner
	local pos = owner:WorldSpaceCenter()
	local ang = owner:EyeAngles()
	ang.pitch = 0
	ang.roll = 0
	local forward = ang:Forward()
	local right = ang:Right()
	local endpos = pos + forward * 32

	local tr = util.TraceLine({start = pos, endpos = endpos, filter = player.GetAll(), mask = MASK_PLAYERSOLID})
	local trent = tr.Entity

	if trent and trent:IsValid() and trent:GetClass() == "prop_creepernest" then
		--[[if not trent:GetNestBuilt() and trent.LastBuilder and trent.LastBuild and trent.LastBuilder:IsValid() and trent.LastBuilder ~= owner and CurTime() < trent.LastBuild + 0.1 then
			owner:ConCommand("-attack2")
			self:SendMessage("nest_already_being_built")
			return
		end]]

		self:BuildNest(trent)

		return
	end

	if owner.NextNestSpawn and CurTime() < owner.NextNestSpawn then
		if CurTime() >= self.NextMessage then
			self.NextMessage = CurTime() + 2
			owner:CenterNotify(COLOR_RED, translate.ClientFormat(owner, "wait_x_seconds_before_making_a_new_nest", math.ceil(owner.NextNestSpawn - CurTime())))
		end

		return
	end

	tr = util.TraceLine({start = endpos, endpos = endpos + Vector(0, 0, -48), mask = MASK_PLAYERSOLID})
	local hitnormal = tr.HitNormal
	local z = hitnormal.z
	if not tr.HitWorld or tr.HitSky or z < 0.75 then
		self:SendMessage("not_enough_room_for_a_nest")
		return
	end

	local hitpos = tr.HitPos

	for x = -20, 20, 20 do
		for y = -20, 20, 20 do
			local start = endpos + x * right + y * forward
			tr = util.TraceLine({start = start, endpos = start + Vector(0, 0, -48), mask = MASK_PLAYERSOLID})
			if not tr.HitWorld or tr.HitSky or math.abs(tr.HitNormal.z - z) >= 0.2 then
				self:SendMessage("not_enough_room_for_a_nest")
				return
			end
		end
	end

	for _, ent in pairs(team.GetValidSpawnPoint(TEAM_UNDEAD)) do
		if ent.Disabled then continue end

		if util.SkewedDistance(ent:GetPos(), hitpos, 2.5) < GAMEMODE.DynamicSpawnDistBuild then
			self:SendMessage("too_close_to_a_spawn")
			return
		end
	end

	-- See if there's a nest nearby.
	for _, ent in pairs(ents.FindByClass("prop_creepernest")) do
		if util.SkewedDistance(ent:GetPos(), hitpos, 2.5) <= GAMEMODE.DynamicSpawnDistBuild then
			self:SendMessage("too_close_to_another_nest")
			return
		end
	end

	for _, human in pairs(team.GetPlayers(TEAM_HUMAN)) do
		if util.SkewedDistance(human:GetPos(), hitpos, 2.75) <= GAMEMODE.DynamicSpawnDistBuild then
			self:SendMessage("too_close_to_a_human")
			return
		end
	end

	-- I didn't make this check where trigger_hurt entities are. Rather I made it check the time since the last time you were hit with a trigger_hurt.
	-- I'm not sure if it's possible to check if a trigger_hurt is enabled or disabled through the Lua bindings.
	if owner.LastHitWithTriggerHurt and CurTime() < owner.LastHitWithTriggerHurt + 2 then
		return
	end

	local ent = ents.Create("prop_creepernest")
	if ent:IsValid() then
		nestang = hitnormal:Angle()
		nestang:RotateAroundAxis(nestang:Right(), 270)

		ent:SetPos(hitpos)
		ent:SetAngles(nestang)
		ent:Spawn()

		ent:SetNestHealth(1)
		ent:SetNestBuilt(false)

		self:SendMessage("nest_created")

		ent.Owner = owner

		owner.NextNestSpawn = CurTime() + 10
	end
end

function SWEP:BuildNest(ent)
	ent:BuildUp()

	ent.LastBuild = CurTime()
	ent.LastBuilder = self.Owner

	if not ent:GetNestBuilt() and ent:GetNestHealth() == ent:GetNestMaxHealth() then
		ent:SetNestBuilt(true)
		ent:EmitSound("physics/flesh/flesh_bloody_break.wav")

		local name = self.Owner:Name()
		for _, pl in pairs(team.GetPlayers(TEAM_UNDEAD)) do
			pl:CenterNotify(COLOR_GREEN, translate.ClientFormat(pl, "nest_built_by_x", name))
		end
	end
end

function SWEP:PrimaryAttack()
	if self:GetHoldingRightClick() or not self.Owner:OnGround() then return end

	self.BaseClass.PrimaryAttack(self)

	if self:IsSwinging() then
		self:SetAttackAnimTime(CurTime() + self.Primary.Delay)
	end
end

function SWEP:SecondaryAttack()
	if self:IsSwinging() or self:IsInAttackAnim() or not self.Owner:OnGround() then return end

	self:SetRightClickStart(CurTime())
end

function SWEP:GetHoldingRightClick()
	return self:GetRightClickStart() > 0
end

function SWEP:IsBuilding()
	return self:GetHoldingRightClick() and (CurTime() - self:GetRightClickStart()) >= 1
end

function SWEP:Reload()
	self.BaseClass.SecondaryAttack(self)
end

function SWEP:IsMoaning()
	return false
end

function SWEP:PlayAlertSound()
	self.Owner:EmitSound("npc/barnacle/barnacle_pull"..math.random(4)..".wav", 70)
end

function SWEP:PlayIdleSound()
	self.Owner:EmitSound("npc/barnacle/barnacle_pull"..math.random(4)..".wav", 70, 85)
end

function SWEP:PlayAttackSound()
end

function SWEP:PlayHitSound()
	self.Owner:EmitSound("physics/body/body_medium_impact_hard"..math.random(6)..".wav", 70, math.random(110, 120))
end

function SWEP:PlayMissSound()
	self.Owner:EmitSound("npc/zombie/claw_miss"..math.random(2)..".wav", 70, math.random(90, 100))
end

function SWEP:IsInAttackAnim()
	return self:GetAttackAnimTime() > 0 and CurTime() < self:GetAttackAnimTime()
end

if not CLIENT then return end

function SWEP:PreDrawViewModel(vm)
	return true
end
