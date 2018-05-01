AddCSLuaFile()

SWEP.Base = "weapon_zs_zombie"

SWEP.PrintName = "Slingshot Zombie Torso"

SWEP.ViewModel = Model("models/weapons/v_fza.mdl")

SWEP.MeleeDelay = 0.25
SWEP.MeleeDamage = 20
SWEP.MeleeReach = 40
SWEP.SwingAnimSpeed = 2.4

SWEP.PounceDamage = 20
SWEP.PounceDamageVsPlayerMul = 0.75
SWEP.PounceReach = 26
SWEP.PounceSize = 12

function SWEP:Think()
	self.BaseClass.Think(self)

	local curtime = CurTime()
	local owner = self:GetOwner()

	if self.NextAllowJump and self.NextAllowJump <= curtime then
		self.NextAllowJump = nil

		owner:ResetJumpPower()
	end

	if self:GetPouncing() then
		if owner:IsOnGround() or owner:WaterLevel() >= 2 then
			self:StopPounce()
		else
			local dir = owner:GetAimVector()
			dir.z = math.Clamp(dir.z, -0.5, 0.9)
			dir:Normalize()

			local traces = owner:CompensatedZombieMeleeTrace(self.PounceReach, self.PounceSize, owner:WorldSpaceCenter(), dir)
			local damage = self:GetDamage(self:GetTracesNumPlayers(traces), self.PounceDamage)

			local hit = false
			for _, trace in ipairs(traces) do
				if not trace.Hit then continue end

				if trace.HitWorld then
					if trace.HitNormal.z < 0.8 then
						hit = true
						self:MeleeHitWorld(trace)
					end
				else
					local ent = trace.Entity
					if ent and ent:IsValid() then
						hit = true
						self:MeleeHit(ent, trace, damage * (ent:IsPlayer() and self.PounceDamageVsPlayerMul or ent.PounceWeakness or 1), ent:IsPlayer() and 1 or 10)
						if ent:IsPlayer() then
							ent:GiveStatus("slow", 5)
							ent:AddLegDamage(24)
						end
					end
				end
			end

			if SERVER and hit then
				owner:EmitSound("physics/flesh/flesh_strider_impact_bullet1.wav")
				owner:EmitSound("npc/fast_zombie/wake1.wav")
			end

			if hit then
				self:StopPounce()
				self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
			end
		end
	end

	self:NextThink(curtime)
	return true
end

function SWEP:PrimaryAttack()
	if CurTime() < self:GetNextPrimaryFire() or self:IsPouncing() then return end

	local owner = self:GetOwner()
	local armdelay = owner:GetMeleeSpeedMul()

	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay * armdelay)
	self:SetNextSecondaryFire(self:GetNextPrimaryFire() + 0.5)

	self:StartSwinging()
end

function SWEP:Move(mv)
	if self:IsPouncing() then
		mv:SetMaxSpeed(0)
		mv:SetMaxClientSpeed(0)
	end
end

function SWEP:StopPounce()
	if not self:IsPouncing() then return end

	self:SetPouncing(false)
	self.m_ViewAngles = nil
	self.NextAllowJump = CurTime() + 0.25
	self:SetNextPrimaryFire(CurTime() + 0.1)
	self:GetOwner():ResetJumpPower()
end


function SWEP:PlayHitSound()
	self:EmitSound("NPC_FastZombie.AttackHit", nil, nil, nil, CHAN_AUTO)
end

function SWEP:PlayMissSound()
	self:EmitSound("NPC_FastZombie.AttackMiss", nil, nil, nil, CHAN_AUTO)
end

function SWEP:PlayAttackSound()
	self:EmitSound("npc/fast_zombie/leap1.wav", nil, nil, nil, CHAN_AUTO)
end

function SWEP:PlayIdleSound()
	self:GetOwner():EmitSound("NPC_FastZombie.AlertFar")
end

function SWEP:PlayAlertSound()
	self:GetOwner():EmitSound("NPC_FastZombie.Frenzy")
end

function SWEP:Reload()
	self:SecondaryAttack()
end

function SWEP:StartMoaning()
end

function SWEP:StopMoaning()
end

function SWEP:IsMoaning()
	return false
end

function SWEP:SetPouncing(leaping)
	self:SetDTBool(3, leaping)
end

function SWEP:GetPouncing()
	return self:GetDTBool(3)
end
SWEP.IsPouncing = SWEP.GetPouncing

if SERVER then

function SWEP:Deploy()
	self:GetOwner():CreateAmbience("fastzombieambience")

	return self.BaseClass.Deploy(self)
end

end

if not CLIENT then return end

local matSkin = Material("models/barnacle/barnacle_sheet")

function SWEP:PreDrawViewModel(vm)
	render.ModelMaterialOverride(matSkin)
	render.SetColorModulation(0.64, 0.37, 0.39)
end

function SWEP:ViewModelDrawn()
	render.ModelMaterialOverride()
	render.SetColorModulation(1, 1, 1)
end
