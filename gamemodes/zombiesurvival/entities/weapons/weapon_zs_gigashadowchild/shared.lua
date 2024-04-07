SWEP.Base = "weapon_zs_gigagorechild"

SWEP.PrintName = "Giga Shadow Child"

SWEP.MeleeDamage = 24
SWEP.MeleeForceScale = 1

function SWEP:PrimaryAttack()
	if self:IsThrowing() then return end

	self.BaseClass.BaseClass.PrimaryAttack(self)
end

function SWEP:Deploy()
	local vm = self:GetOwner():GetViewModel()
	vm:SendViewModelMatchingSequence(vm:LookupSequence("fists_draw"))

	return self.BaseClass.BaseClass.Deploy(self)
end

local anims = {"fists_uppercut", "fists_right", "fists_left"}
function SWEP:StartSwinging()
	self.BaseClass.BaseClass.StartSwinging(self)

	local vm = self:GetOwner():GetViewModel()
	vm:SendViewModelMatchingSequence(vm:LookupSequence(anims[math.random(#anims)]))
	vm:SetPlaybackRate(0.32)
end

function SWEP:ApplyMeleeDamage(ent, trace, damage)
	if ent:IsValidPlayer() then
		local vel = ent:GetPos() - self:GetOwner():GetPos()
		vel.z = 0
		vel:Normalize()
		vel = vel * 300
		vel.z = 150

		if CurTime() >= (ent.NextKnockdown or 0) then
			ent:KnockDown()
			ent.NextKnockdown = CurTime() + 4
		end
		ent:SetGroundEntity(NULL)
		ent:SetVelocity(vel)

		if SERVER then
			ent:GiveStatus("dimvision", 10)
		end
	end

	self.BaseClass.BaseClass.ApplyMeleeDamage(self, ent, trace, damage)
end

function SWEP:CheckThrow()
	if self:GetThrowing() and CurTime() >= self:GetThrowTime() then
		self:SetThrowTime(0)

		local owner = self:GetOwner()

		owner.LastRangedAttack = CurTime()
		owner:EmitSound("weapons/slam/throw.wav", 70, math.random(78, 82))

		if SERVER then
			local ent = ents.Create("prop_thrownshadowbaby")
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
					if SERVER then
						ent:GiveStatus("dimvision", 10)
					end
				end
			end
		end
	end
end
