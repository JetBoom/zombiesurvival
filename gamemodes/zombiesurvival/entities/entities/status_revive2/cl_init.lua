include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 80))

	local owner = self:GetOwner()
	if owner:IsPlayer() then
		owner.Revive = self
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
	if endtime <= 0 then return end

	local ct = CurTime()
	local owner = self:GetOwner()
	if owner:IsValid() then
		local rag = owner:GetRagdollEntity()
		if rag and rag:IsValid() then
			if endtime - 1 <= ct then
				if not self.m_DidSetModel then
					self.m_DidSetModel = true
					rag:SetModel(GAMEMODE.ZombieClasses["Zombie"].Model)
				end
				local delta = math.max(0.01, endtime - ct)
				for i = 0, rag:GetPhysicsObjectCount() do
					local translate = owner:TranslatePhysBoneToBone(i)
					if translate and 0 < translate then
						local pos, ang = owner:GetBonePosition(translate)
						if pos and ang then
							local phys = rag:GetPhysicsObjectNum(i)
							if phys and phys:IsValid() then
								phys:Wake()
								phys:ComputeShadowControl({secondstoarrive = delta, pos = pos, angle = ang, maxangular = 1000, maxangulardamp = 10000, maxspeed = 5000, maxspeeddamp = 1000, dampfactor = 0.85, teleportdistance = 100, deltatime = FrameTime()})
							end
						end
					end
				end
			else
				local phys = rag:GetPhysicsObject()
				if phys:IsValid() then
					phys:Wake()
					phys:ComputeShadowControl({secondstoarrive = 0.05, pos = owner:GetPos() + Vector(0,0,16), angle = phys:GetAngles(), maxangular = 2000, maxangulardamp = 10000, maxspeed = 5000, maxspeeddamp = 1000, dampfactor = 0.85, teleportdistance = 200, deltatime = FrameTime()})
				end
			end
		end
	end

	self:NextThink(ct)
	return true
end

function ENT:Draw()
end
