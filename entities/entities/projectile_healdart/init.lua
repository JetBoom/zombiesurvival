AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

ENT.Heal = 3

function ENT:Initialize()
	self:SetModel("models/Items/CrossbowRounds.mdl")
	self:SetModelScale(0.5, 0)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMass(3)
		phys:SetBuoyancyRatio(0.002)
		phys:EnableMotion(true)
		phys:Wake()
	end

	self:Fire("kill", "", 30)
end

function ENT:Think()
	if self.PhysicsData then
		self:Hit(self.PhysicsData.HitPos, self.PhysicsData.HitNormal, self.PhysicsData.HitEntity, self.PhysicsData.OurOldVelocity)
	end

	local parent = self:GetParent()
	if parent:IsValid() and parent:IsPlayer() and not parent:Alive() then
		self:Remove()
	end
end

function ENT:Hit(vHitPos, vHitNormal, eHitEntity, vOldVelocity)
	if self:GetHitTime() ~= 0 then return end
	self:SetHitTime(CurTime())

	self:Fire("kill", "", 10)

	local owner = self:GetOwner()
	if not owner:IsValid() then owner = self end

	vHitPos = vHitPos or self:GetPos()
	vHitNormal = (vHitNormal or Vector(0, 0, -1)) * -1

	self:SetSolid(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)

	self:SetPos(vHitPos + vHitNormal)

	if eHitEntity:IsValid() then
		self:AddEFlags(EFL_SETTING_UP_BONES)

		local followed = false
		local bonecount = eHitEntity:GetBoneCount()
		if bonecount and bonecount > 1 then
			local boneindex = eHitEntity:NearestBone(vHitPos)
			if boneindex and boneindex > 0 then
				self:FollowBone(eHitEntity, boneindex)
				self:SetPos((eHitEntity:GetBonePositionMatrixed(boneindex) * 2 + vHitPos) / 3)
				followed = true
			end
		end
		if not followed then
			self:SetParent(eHitEntity)
		end
		self:SetOwner(eHitEntity)

		if eHitEntity:IsPlayer() and eHitEntity:Team() ~= TEAM_UNDEAD then
			eHitEntity:GiveStatus("healdartboost").DieTime = CurTime() + 10

			local oldhealth = eHitEntity:Health()
			local newhealth = math.min(oldhealth + self.Heal, eHitEntity:GetMaxHealth())
			if oldhealth ~= newhealth then
				eHitEntity:SetHealth(newhealth)

				if owner:IsPlayer() then
					gamemode.Call("PlayerHealedTeamMember", owner, eHitEntity, newhealth - oldhealth, self)
				end
			end
		end
	end

	self:SetAngles(vOldVelocity:Angle())

	local effectdata = EffectData()
		effectdata:SetOrigin(vHitPos)
		effectdata:SetNormal(vHitNormal)
		if eHitEntity:IsValid() then
			effectdata:SetEntity(eHitEntity)
		else
			effectdata:SetEntity(NULL)
		end
	util.Effect("hit_healdart", effectdata)
end

function ENT:PhysicsCollide(data, phys)
	if not self:HitFence(data, phys) then
		self.PhysicsData = data
	end

	self:NextThink(CurTime())
end
