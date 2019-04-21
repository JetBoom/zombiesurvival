SWEP.ZombieOnly = true
SWEP.IsMelee = true

SWEP.ViewModel = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"

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

SWEP.PounceDamage = 8
SWEP.PounceDamageType = DMG_SLASH

SWEP.NoHitRecovery = 0.75
SWEP.HitRecovery = 1

SWEP.BurrowTime = 1.5

function SWEP:Initialize()
	self:HideViewAndWorldModel()
end

if SERVER then SWEP.NextHeal = 0 end
function SWEP:Think()
	local curtime = CurTime()
	local owner = self:GetOwner()

	if self:GetBurrowTime() > 0 and curtime >= self:GetBurrowTime() then
		if not self:CanBurrow() then
			self:SetBurrowTime(-(curtime + self.BurrowTime))
		else
			owner:DrawShadow(false)
			if SERVER and curtime >= self.NextHeal then
				self.NextHeal = curtime + 0.333

				if owner:GetVelocity():LengthSqr() > 8 then
					local effectdata = EffectData()
						effectdata:SetOrigin(owner:GetPos() % 2)
					util.Effect("headcrab_dust", effectdata, true, true)
				end

				if owner:Health() < owner:GetMaxHealth() then
					owner:SetHealth(owner:Health() + 1)
				end
			end
		end
	elseif self:GetBurrowTime() < 0 and curtime >= -self:GetBurrowTime() then
		self:SetBurrowTime(0)
	elseif self:GetPouncing() then
		local delay = owner:GetMeleeSpeedMul()
		if owner:IsOnGround() or 1 < owner:WaterLevel() then
			self:SetPouncing(false)
			self:SetNextPrimaryFire(curtime + self.NoHitRecovery * delay)
		else
			--owner:LagCompensation(true)

			local shootpos = owner:GetShootPos()
			local trace = owner:CompensatedMeleeTrace(8, 12, shootpos, owner:GetForward())
			local ent = trace.Entity

			if trace.Hit then
				self:SetPouncing(false)
				self:SetNextPrimaryFire(curtime + self.HitRecovery * delay)
			end

			if ent:IsValid() then
				self:SetPouncing(false)

				if SERVER then
					self:EmitBiteSound()
				end

				local damage = self.PounceDamage

				if ent:IsPlayer() then
					ent:MeleeViewPunch(damage)
					if SERVER then
						local nearest = ent:NearestPoint(shootpos)
						util.Blood(nearest, math.Rand(damage * 0.5, damage * 0.75), (nearest - shootpos):GetNormalized(), math.Rand(damage * 5, damage * 10), true)
					end

					owner:AirBrake()
				else
					local phys = ent:GetPhysicsObject()
					if phys:IsValid() and phys:IsMoveable() then
						phys:ApplyForceOffset(damage * 600 * owner:EyeAngles():Forward(), (ent:NearestPoint(shootpos) + ent:GetPos() * 2) / 3)
						ent:SetPhysicsAttacker(owner)
					end
				end

				ent:TakeSpecialDamage(damage, self.PounceDamageType, owner, self, trace.HitPos)

				owner:ViewPunch(Angle(math.Rand(-20, 20), math.Rand(-20, 20), math.Rand(-20, 20)))
			elseif trace.HitWorld then
				if SERVER then
					self:EmitHitSound()
				end
			end

			--owner:LagCompensation(false)
		end
	end

	self:NextThink(curtime)
	return true
end

function SWEP:PrimaryAttack()
	local owner = self:GetOwner()
	if self:GetPouncing() or CurTime() < self:GetNextPrimaryFire() or not owner:IsOnGround() or self:IsBurrowing() then return end

	local vel = owner:GetAimVector()
	vel.z = math.max(0.45, vel.z)
	vel:Normalize()

	owner:SetGroundEntity(NULL)
	owner:SetLocalVelocity(vel * 450)
	owner:DoAnimationEvent(ACT_RANGE_ATTACK1)

	if SERVER then
		self:EmitAttackSound()
	end

	self.m_ViewAngles = owner:EyeAngles()

	self:SetPouncing(true)
end

function SWEP:SecondaryAttack()
	if CurTime() < self:GetNextSecondaryFire() then return end
	self:SetNextSecondaryFire(CurTime() + 2)

	if SERVER then
		self:EmitIdleSound()
	end
end

function SWEP:Reload()
	local owner = self:GetOwner()
	if self:GetPouncing() or CurTime() < self:GetNextPrimaryFire() or not owner:IsOnGround() then return end

	if self:GetBurrowTime() == 0 then
		if self:CanBurrow() then
			self:BurrowDown()
		end
	elseif self:GetBurrowTime() > 0 and CurTime() >= self:GetBurrowTime() then
		self:BurrowUp()
	end
end

function SWEP:BurrowDown()
	self:SetBurrowTime(CurTime() + self.BurrowTime)
	if SERVER then self:GetOwner():EmitSound("npc/antlion/digdown1.wav", 60, 100, 0.5) end
end

function SWEP:BurrowUp()
	self:SetBurrowTime(-(CurTime() + self.BurrowTime))
	if SERVER then self:GetOwner():EmitSound("npc/antlion/digup1.wav", 60, 100, 0.5) end
	self:GetOwner():DrawShadow(true)
end

local traceGround = {mask = MASK_SOLID_BRUSHONLY}
function SWEP:CanBurrow()
	local owner = self:GetOwner()
	if not owner:IsOnGround() or owner:WaterLevel() >= 2 then return false end

	traceGround.start = owner:GetPos() % 4
	traceGround.endpos = traceGround.start + Vector(0, 0, -128)
	local tr = util.TraceLine(traceGround)

	return tr.HitWorld and (tr.MatType == MAT_DIRT or tr.MatType == MAT_SAND or tr.MatType == MAT_SLOSH or tr.MatType == MAT_FOILAGE or tr.MatType == 88 or tr.HitTexture == "**displacement**")
end

function SWEP:Move(mv)
	if self:IsPouncing() then
		mv:SetSideSpeed(0)
		mv:SetForwardSpeed(0)
	elseif self:IsBurrowed() then
		mv:SetMaxSpeed(80)
		mv:SetMaxClientSpeed(80)
	elseif self:IsBurrowing() then
		mv:SetSideSpeed(0)
		mv:SetForwardSpeed(0)
		mv:SetVelocity(vector_origin)
		return true
	end
end

function SWEP:EmitHitSound()
	self:GetOwner():EmitSound(string.format("npc/headcrab_poison/ph_wallhit%d.wav", math.random(2)))
end

function SWEP:EmitBiteSound()
	self:GetOwner():EmitSound("NPC_HeadCrab.Bite")
end

function SWEP:EmitIdleSound()
	local ent = self:GetOwner():CompensatedMeleeTrace(4096, 24).Entity
	if ent:IsValidPlayer() then
		self:GetOwner():EmitSound("NPC_HeadCrab.Alert")
	else
		self:GetOwner():EmitSound("NPC_HeadCrab.Idle")
	end
end

function SWEP:EmitAttackSound()
	self:GetOwner():EmitSound("NPC_HeadCrab.Attack")
end

function SWEP:SetPouncing(pouncing)
	if not pouncing then
		self.m_ViewAngles = nil
	end

	self:SetDTBool(1, pouncing)
end

function SWEP:GetPouncing()
	return self:GetDTBool(1)
end
SWEP.IsPouncing = SWEP.GetPouncing

function SWEP:SetBurrowTime(time)
	local owner = self:GetOwner()

	self:SetDTFloat(1, time)

	if owner:IsValid() then
		if time == 0 then
			owner.NoCollideAll = nil
			owner:CollisionRulesChanged()
			if SERVER then
				owner:TemporaryNoCollide(true)
			end
		else
			owner.NoCollideAll = true
			owner:CollisionRulesChanged()
		end
	end
end

function SWEP:GetBurrowTime()
	return self:GetDTFloat(1)
end

function SWEP:IsBurrowing()
	return self:GetBurrowTime() ~= 0
end

function SWEP:IsBurrowed()
	return self:GetBurrowTime() > 0 and CurTime() >= self:GetBurrowTime()
end

util.PrecacheSound("npc/antlion/digdown1.wav")
util.PrecacheSound("npc/antlion/digup1.wav")
