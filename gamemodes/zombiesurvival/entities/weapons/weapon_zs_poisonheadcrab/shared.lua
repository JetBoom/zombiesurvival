SWEP.ZombieOnly = true
SWEP.IsMelee = true

SWEP.ViewModel = "models/weapons/v_knife_t.mdl"
SWEP.WorldModel = "models/weapons/w_knife_t.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 0.4

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.Delay = 0.22
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo	= "none"

SWEP.PounceDamage = 10
SWEP.PounceDamagePerTick = 5
SWEP.PounceDamageTicks = 10
SWEP.PounceDamageTime = 1
SWEP.PounceDamageVsPropsMultiplier = 2

function SWEP:Initialize()
	self:HideViewAndWorldModel()
end

local function DoPoisoned(hitent, owner, damage, timername)
	if not (hitent:IsValid() and hitent:Alive()) then
		timer.Destroy(timername)
		return
	end

	hitent:PoisonDamage(damage, owner)
end
function SWEP:Think()
	local curtime = CurTime()
	local owner = self.Owner

	if self:IsGoingToSpit() and self:GetNextSpit() <= curtime then
		self:SetNextSpit(0)
		self:SetNextPrimaryFire(curtime + 2)
		self:SetNextSecondaryFire(self:GetNextPrimaryFire())

		if SERVER then
			owner:EmitSound("weapons/crossbow/bolt_fly4.wav", 74, 150)

			local ent = ents.Create("projectile_poisonspit")
			if ent:IsValid() then
				ent:SetOwner(owner)
				local aimvec = owner:GetAimVector()
				aimvec.z = math.max(aimvec.z, -0.25)
				aimvec:Normalize()
				local vStart = owner:GetShootPos()
				local tr = util.TraceLine({start=vStart, endpos=vStart + owner:GetAimVector() * 30, filter=owner})
				if tr.Hit then
					ent:SetPos(tr.HitPos + tr.HitNormal * 4)
				else
					ent:SetPos(tr.HitPos)
				end
				ent:Spawn()
				local phys = ent:GetPhysicsObject()
				if phys:IsValid() then
					phys:SetVelocityInstantaneous(aimvec * 510)
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
			owner:LagCompensation(true)

			local vStart = owner:LocalToWorld(owner:OBBCenter())
			local trace = util.TraceHull({start = vStart, endpos = vStart + owner:GetForward() * (owner:BoundingRadius() + 8), mins = owner:OBBMins() * 0.8, maxs = owner:OBBMaxs() * 0.8, filter = owner:GetMeleeFilter()})
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
					ent:PoisonDamage(self.PounceDamage, owner, self)
					local timername = tostring(ent).."poisonedby"..tostring(owner)..CurTime()
					timer.CreateEx(timername, self.PounceDamageTime, self.PounceDamageTicks, DoPoisoned, ent, owner, self.PounceDamagePerTick, timername)
				else
					ent:PoisonDamage(self.PounceDamage * self.PounceDamageVsPropsMultiplier, owner, self)
				end
			elseif trace.HitWorld then
				if SERVER then
					owner:EmitSound("NPC_BlackHeadcrab.Impact")
				end
				self:SetLeaping(false)
				self:SetNextPrimaryFire(curtime + 1)
			end

			owner:LagCompensation(false)
		end
	end

	self:NextThink(curtime)
	return true
end

function SWEP:PrimaryAttack()
	local owner = self.Owner
	if self:IsLeaping() or self:IsGoingToSpit() or self:IsGoingToLeap() or CurTime() < self:GetNextPrimaryFire() or not owner:IsOnGround() then return end

	self:SetNextLeap(CurTime() + 1.25)

	self.m_ViewAngles = owner:EyeAngles()

	if SERVER then
		owner:EmitSound("NPC_BlackHeadcrab.Telegraph")
	end
end

function SWEP:SecondaryAttack()
	if self:IsLeaping() or self:IsGoingToSpit() or self:IsGoingToLeap() or CurTime() < self:GetNextSecondaryFire() or not self.Owner:IsOnGround() then return end

	self:SetNextSpit(CurTime() + 1)

	if SERVER then
		self.Owner:EmitSound("npc/headcrab_poison/ph_scream"..math.random(1, 3)..".wav")
	end
end

function SWEP:Reload()
	if self:GetNextReload() > CurTime() then return end
	self:SetNextReload(CurTime() + 3)

	if SERVER then
		self.Owner:LagCompensation(true)

		local ent = self.Owner:MeleeTrace(4096, 24, self.Owner:GetMeleeFilter()).Entity
		if ent:IsValid() and ent:IsPlayer() then
			self.Owner:EmitSound("npc/headcrab_poison/ph_warning"..math.random(1, 3)..".wav")
		else
			self.Owner:EmitSound("npc/headcrab_poison/ph_idle"..math.random(1, 3)..".wav")
		end

		self.Owner:LagCompensation(false)
	end

	return false
end

function SWEP:Move(mv)
	if self:IsLeaping() or self:IsGoingToLeap() or self:IsGoingToSpit() then
		mv:SetSideSpeed(0)
		mv:SetForwardSpeed(0)
	end
end

function SWEP:Precache()
	util.PrecacheSound("npc/headcrab_poison/ph_scream1.wav")
	util.PrecacheSound("npc/headcrab_poison/ph_scream2.wav")
	util.PrecacheSound("npc/headcrab_poison/ph_scream3.wav")
	util.PrecacheSound("npc/headcrab_poison/ph_jump1.wav")
	util.PrecacheSound("npc/headcrab_poison/ph_jump2.wav")
	util.PrecacheSound("npc/headcrab_poison/ph_jump3.wav")
	util.PrecacheSound("npc/headcrab_poison/ph_poisonbite1.wav")
	util.PrecacheSound("npc/headcrab_poison/ph_poisonbite2.wav")
	util.PrecacheSound("npc/headcrab_poison/ph_poisonbite3.wav")
end

function SWEP:SetLeaping(leap)
	if not leap then
		self.m_ViewAngles = nil
	end
	self:SetDTBool(0, leap)
end

function SWEP:GetLeaping()
	return self:GetDTBool(0)
end
SWEP.IsLeaping = SWEP.GetLeaping

function SWEP:SetNextLeap(time)
	self:SetDTFloat(0, time)
end

function SWEP:GetNextLeap()
	return self:GetDTFloat(0)
end

function SWEP:IsGoingToLeap()
	return self:GetNextLeap() > 0
end

function SWEP:ShouldPlayLeapAnimation()
	return self:IsLeaping() or self:IsGoingToLeap()
end

function SWEP:SetNextSpit(time)
	self:SetDTFloat(1, time)
end

function SWEP:GetNextSpit()
	return self:GetDTFloat(1)
end

function SWEP:IsGoingToSpit()
	return self:GetNextSpit() > 0
end
