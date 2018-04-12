local meta = FindMetaTable("Player")
if not meta then return end

function meta:FloatingScore(victim, effectname, frags, flags)
	if MySelf == self then
		gamemode.Call("FloatingScore", victim, effectname, frags, flags)
	end
end

function meta:FixModelAngles(velocity)
	local eye = self:EyeAngles()
	self:SetLocalAngles(eye)
	self:SetRenderAngles(eye)
	self:SetPoseParameter("move_yaw", math.NormalizeAngle(velocity:Angle().yaw - eye.y))
end

function meta:RemoveAllStatus(bSilent, bInstant)
end

function meta:RemoveStatus(sType, bSilent, bInstant, sExclude)
end

function meta:GetStatus(sType)
	local ent = self["status_"..sType]
	if ent and ent.Owner == self then return ent end
end

function meta:GiveStatus(sType, fDie)
end

function meta:IsFriend()
	return self.m_IsFriend
end

timer.Create("checkfriend", 5, 0, function()
	-- This probably isn't the fastest function in the world so I cache it.
	for _, pl in pairs(player.GetAll()) do
		pl.m_IsFriend = pl:GetFriendStatus() == "friend"
	end
end)

if not meta.SetGroundEntity then
	function meta:SetGroundEntity(ent) end
end

if not meta.Kill then
	function meta:Kill() end
end

if not meta.HasWeapon then
	function meta:HasWeapon(class)
		for _, wep in pairs(self:GetWeapons()) do
			if wep:GetClass() == class then return true end
		end

		return false
	end
end

function meta:SetMaxHealth(num)
	self:SetDTInt(0, math.ceil(num))
end

meta.OldGetMaxHealth = FindMetaTable("Entity").GetMaxHealth
function meta:GetMaxHealth()
	return self:GetDTInt(0)
end

function meta:DoHulls(classid, teamid)
	teamid = teamid or self:Team()
	classid = classid or self:GetZombieClass()

	if teamid == TEAM_UNDEAD then
		self:SetIK(false)

		local classtab = GAMEMODE.ZombieClasses[classid]
		if classtab then
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

			if classtab.ClientsideModelScale then
				self.ClientsideModelScale = Vector(1, 1, 1) * classtab.ClientsideModelScale
				local m = Matrix()
				m:Scale(self.ClientsideModelScale)
				self:EnableMatrix("RenderMultiply", m)
			end
			self.NoCollideAll = classtab.NoCollideAll
			self.AllowTeamDamage = classtab.AllowTeamDamage
			self.NeverAlive = classtab.NeverAlive
			local phys = self:GetPhysicsObject()
			if phys:IsValid() then
				phys:SetMass(classtab.Mass or DEFAULT_MASS)
			end
		end
	else
		self:SetIK(true)

		self:SetModelScale(DEFAULT_MODELSCALE, 0)
		self:ResetHull()
		self:SetViewOffset(DEFAULT_VIEW_OFFSET)
		self:SetViewOffsetDucked(DEFAULT_VIEW_OFFSET_DUCKED)
		self:SetStepSize(DEFAULT_STEP_SIZE)
		self:SetJumpPower(DEFAULT_JUMP_POWER)

		if self.ClientsideModelScale then
			self.ClientsideModelScale = nil
			self:DisableMatrix("RenderMultiply")
		end
		self.NoCollideAll = nil
		self.AllowTeamDamage = nil
		self.NeverAlive = nil
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:SetMass(DEFAULT_MASS)
		end
	end
end

function meta:GivePenalty(amount)
	surface.PlaySound("ambient/alarms/klaxon1.wav")
end

function meta:SetZombieClass(cl)
	self:CallZombieFunction("SwitchedAway")

	local classtab = GAMEMODE.ZombieClasses[cl]
	if classtab then
		self.Class = classtab.Index or cl
		self:CallZombieFunction("SwitchedTo")
	end
end

net.Receive("zs_penalty", function(length)
	local penalty = net.ReadUInt(16)

	MySelf:GivePenalty(penalty)
end)

net.Receive("zs_dohulls", function(length)
	local ent = net.ReadEntity()
	local classid = net.ReadUInt(16)
	local teamid = net.ReadUInt(16)

	if ent:IsValid() then
		ent:DoHulls(classid, teamid)
	end
end)

net.Receive("zs_zclass", function(length)
	local ent = net.ReadEntity()
	local id = net.ReadUInt(8)

	if ent:IsValid() and ent:IsPlayer() then
		ent:SetZombieClass(id)
	end
end)

net.Receive("zs_floatscore", function(length)
	local victim = net.ReadEntity()
	local effectname = net.ReadString()
	local frags = net.ReadInt(24)
	local flags = net.ReadUInt(8)

	if victim and victim:IsValid() then
		MySelf:FloatingScore(victim, effectname, frags, flags)
	end
end)

net.Receive("zs_floatscore_vec", function(length)
	local pos = net.ReadVector()
	local effectname = net.ReadString()
	local frags = net.ReadInt(24)
	local flags = net.ReadUInt(8)

	MySelf:FloatingScore(pos, effectname, frags, flags)
end)
