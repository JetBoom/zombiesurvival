include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 80))

	local owner = self:GetOwner()
	if owner:IsValid() then
		owner.Revive = self

		owner:CallWeaponFunction("KnockedDown", self, false)
		owner:CallZombieFunction("KnockedDown", self, false)
	end
end

function ENT:OnRemove()
	local owner = self:GetOwner()
	if owner:IsValid() then
		owner.Revive = nil
	end
end

function ENT:Think()
	local endtime = self:GetReviveTime()
	if endtime == 0 then return end

	local owner = self:GetOwner()
	if owner:IsValid() then
		local rag = owner:GetRagdollEntity()
		if rag and rag:IsValid() then
			local phys = rag:GetPhysicsObject()
			if phys:IsValid() then
				phys:Wake()
				phys:ComputeShadowControl({secondstoarrive = 0.05, pos = owner:GetPos() + Vector(0,0,16), angle = phys:GetAngles(), maxangular = 2000, maxangulardamp = 10000, maxspeed = 5000, maxspeeddamp = 1000, dampfactor = 0.85, teleportdistance = 200, deltatime = FrameTime()})
			end
		end
	end

	self:NextThink(CurTime())
	return true
end

function ENT:Draw()
end
