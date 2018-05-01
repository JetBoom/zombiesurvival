AddCSLuaFile()

SWEP.Base = "weapon_zs_zombie"

SWEP.PrintName = "Giga Gore Child"

SWEP.ViewModel = "models/weapons/c_arms_citizen.mdl"
SWEP.WorldModel	= ""

if CLIENT then
	SWEP.UseHands = true
	SWEP.ViewModelFOV = 40
	SWEP.BobScale = 2
end

SWEP.MeleeReach = 90
SWEP.MeleeDamage = 32
SWEP.MeleeForceScale = 2
SWEP.MeleeSize = 5 --3
SWEP.MeleeDamageType = DMG_SLASH
SWEP.Primary.Delay = 1.35
SWEP.Secondary.Delay = 2.5

SWEP.CryDelay = 8
SWEP.CryImpactDelay = 1
SWEP.ThrowDelay = 1

AccessorFuncDT(SWEP, "ThrowTime", "Float", 3)
AccessorFuncDT(SWEP, "CryTime", "Float", 4)

function SWEP:Think()
	self:CheckMeleeAttack()
	self:CheckThrow()
	self:CheckCry()
end

function SWEP:ApplyMeleeDamage(ent, trace, damage)
	if ent:IsValidPlayer() then
		local vel = ent:GetPos() - self:GetOwner():GetPos()
		vel.z = 0
		vel:Normalize()
		vel = vel * 400
		vel.z = 200

		if CurTime() >= (ent.NextKnockdown or 0) then
			ent:KnockDown()
			ent.NextKnockdown = CurTime() + 4
		end
		ent:SetGroundEntity(NULL)
		ent:SetVelocity(vel)
	end

	self.BaseClass.ApplyMeleeDamage(self, ent, trace, damage)
end

function SWEP:PrimaryAttack()
	if self:IsThrowing() then return end

	self.BaseClass.PrimaryAttack(self)
end

function SWEP:Deploy()
	local vm = self:GetOwner():GetViewModel()
	vm:SendViewModelMatchingSequence(vm:LookupSequence("fists_draw"))

	return self.BaseClass.Deploy(self)
end

local anims = {"fists_uppercut", "fists_right", "fists_left"}
function SWEP:StartSwinging()
	self.BaseClass.StartSwinging(self)

	local vm = self:GetOwner():GetViewModel()
	vm:SendViewModelMatchingSequence(vm:LookupSequence(anims[math.random(#anims)]))
	vm:SetPlaybackRate(0.32)
end

function SWEP:SecondaryAttack()
	if self:IsSwinging() or CurTime() <= self:GetNextSecondaryAttack() or IsValid(self:GetOwner().FeignDeath) then return end

	self:SetThrowTime(CurTime() + self.ThrowDelay)
	self:GetOwner():DoReloadEvent() -- Handled in the class file. Fires the throwing anim.

	self:SetNextSecondaryAttack(CurTime() + self.Secondary.Delay)
end

function SWEP:CheckThrow()
	if self:GetThrowing() and CurTime() >= self:GetThrowTime() then
		self:SetThrowTime(0)

		local owner = self:GetOwner()

		owner.LastRangedAttack = CurTime()
		owner:EmitSound("weapons/slam/throw.wav", 70, math.random(78, 82))

		if SERVER then
			local ent = ents.Create("prop_thrownbaby")
			if ent:IsValid() then
				ent:SetPos(owner:GetShootPos())
				ent:SetAngles(AngleRand())
				ent:SetOwner(owner)
				ent:Spawn()

				local phys = ent:GetPhysicsObject()
				if phys:IsValid() then
					phys:Wake()
					phys:SetVelocityInstantaneous(owner:GetAimVector() * 650)
					phys:AddAngleVelocity(VectorRand() * math.Rand(200, 300))

					ent:SetPhysicsAttacker(owner)
				end
			end
		end
	end
end

function SWEP:IsThrowing()
	return self:GetThrowTime() > 0
end
SWEP.GetThrowing = SWEP.IsThrowing

function SWEP:Reload()
	if self:IsSwinging() or CurTime() <= self:GetNextSecondaryAttack() or IsValid(self:GetOwner().FeignDeath) then return end

	self:PlayAlertSound()
	self:GetOwner():AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_TAUNT_ZOMBIE, true)

	self:SetCryTime(CurTime() + self.CryImpactDelay)
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetNextSecondaryAttack(CurTime() + self.CryDelay)
end

function SWEP:CheckCry()
	if self:IsCrying() and CurTime() >= self:GetCryTime() then
		self:SetCryTime(0)

		local owner = self:GetOwner()
		local worldspace = owner:WorldSpaceCenter()

		util.ScreenShake(worldspace, 5, 5, 2, 400)
		owner:EmitSound("physics/concrete/concrete_break2.wav", 77, 50)

		for k, ent in pairs(ents.FindInSphere(worldspace, 150)) do
			if ent:IsValid() and ent:IsValidLivingHuman() and WorldVisible(ent:GetPos(), worldspace) then
				if CurTime() >= (ent.NextKnockdown or 0) then
					ent:KnockDown()
					ent.NextKnockdown = CurTime() + 4
				end
			end
		end
	end
end

function SWEP:IsCrying()
	return self:GetCryTime() > 0
end

function SWEP:PlayAlertSound()
	self:GetOwner():EmitSound("ambient/creatures/town_child_scream1.wav", 82, 60)
	self:GetOwner():EmitSound("npc/stalker/go_alert2a.wav", 82, 45, 0.25)
end

function SWEP:PlayIdleSound()
	self:GetOwner():EmitSound("ambient/creatures/teddy.wav", 77, 60)
end

function SWEP:PlayAttackSound()
	self:EmitSound("ambient/creatures/teddy.wav", 77, 60)
end

function SWEP:PlayHitSound()
	self:EmitSound("physics/body/body_medium_impact_hard"..math.random(6)..".wav", 77, math.random(60, 70), nil, CHAN_AUTO)
end

function SWEP:PlayMissSound()
	self:EmitSound("npc/zombie/claw_miss"..math.random(2)..".wav", 77, math.random(60, 70), nil, CHAN_AUTO)
end
