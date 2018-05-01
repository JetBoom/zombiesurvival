AddCSLuaFile()

SWEP.Base = "weapon_zs_headcrab"

SWEP.PrintName = "Bloodsucker Headcrab"

SWEP.PounceDamage = 6

SWEP.NoHitRecovery = 0.6
SWEP.HitRecovery = 0.75

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
		if owner:IsOnGround() or 1 < owner:WaterLevel() then
			self:SetPouncing(false)
			self:SetNextPrimaryFire(curtime + self.NoHitRecovery)
		else
			--owner:LagCompensation(true)

			local shootpos = owner:GetShootPos()
			local trace = owner:CompensatedMeleeTrace(8, 12, shootpos, owner:GetForward())
			local ent = trace.Entity

			if trace.Hit then
				self:SetPouncing(false)
				self:SetNextPrimaryFire(curtime + self.HitRecovery)
			end

			if ent:IsValid() then
				self:SetPouncing(false)

				local damage = self.PounceDamage

				local phys = ent:GetPhysicsObject()
				if ent:IsPlayer() then
					ent:MeleeViewPunch(damage)
					if SERVER then
						local nearest = ent:NearestPoint(shootpos)
						util.Blood(nearest, math.Rand(damage * 0.5, damage * 0.75), (nearest - shootpos):GetNormalized(), math.Rand(damage * 5, damage * 10), true)
					end

					owner:AirBrake()
				elseif phys:IsValid() and phys:IsMoveable() then
					phys:ApplyForceOffset(damage * 600 * owner:EyeAngles():Forward(), (ent:NearestPoint(shootpos) + ent:GetPos() * 2) / 3)
					ent:SetPhysicsAttacker(owner)
				end

				ent:TakeSpecialDamage(damage, self.PounceDamageType, owner, self, trace.HitPos)
				if ent:IsPlayer() then
					if SERVER then
						self:EmitBiteSound()
						ent:AddLegDamage(7.2)
					end

					if owner:Health() < owner:GetMaxHealth() then
						owner:SetHealth(math.min(owner:Health() + self.PounceDamage, owner:GetMaxHealth()))
					end

					ent:GiveStatus("sickness", 5)
				elseif SERVER then
					self:EmitBiteObjectSound()
				end

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

function SWEP:EmitBiteSound()
	self:GetOwner():EmitSound("NPC_FastHeadcrab.Bite")
	self:GetOwner():EmitSound("npc/barnacle/barnacle_gulp"..math.random(2)..".wav", 70, math.random(125, 130))
end

function SWEP:EmitBiteObjectSound()
	self:GetOwner():EmitSound("NPC_FastHeadcrab.Bite")
end

function SWEP:EmitIdleSound()
	self:GetOwner():EmitSound("NPC_FastHeadcrab.Idle")
end

function SWEP:EmitAttackSound()
	self:GetOwner():EmitSound("npc/headcrab_fast/attack"..math.random(3)..".wav", 70, math.random(215,220))
end

function SWEP:Reload()
end
