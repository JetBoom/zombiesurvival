INC_SERVER()

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetSolid(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetModelScale(1.03, 0)
end

function ENT:AttachTo(ent)
	self:SetModel(ent:GetModel())
	self:SetSkin(ent:GetSkin() or 0)
	self:SetPos(ent:GetPos())
	self:SetAngles(ent:GetAngles())
	self:SetAlpha(ent:GetAlpha())
	self:SetParent(ent)

	self.ObjectPosition = ent:GetPos() + Vector(0, 0, 40)
end

local ShadowParams = {secondstoarrive = 0.05, maxangular = 15, maxangulardamp = 1, maxspeed = 100, maxspeeddamp = 1000, dampfactor = 0.65, teleportdistance = 0}
function ENT:Think()
	local owner = self:GetOwner()
	if owner:IsValid() and owner:IsPlayer() and owner:Alive() and owner:Team() == TEAM_UNDEAD and owner:GetZombieClassTable().Name == "Shade" then
		local ent = self:GetParent()
		if ent:IsValid() then
			local eyepos = owner:EyePos()
			if eyepos:DistToSqr(ent:NearestPoint(eyepos)) <= 160000 then --400^2
				local phys = ent:GetPhysicsObject()
				if phys:IsValid() and phys:IsMoveable() and phys:GetMass() <= 300 then
					local ct = CurTime()

					local frametime = ct - (self.LastThink or ct)
					self.LastThink = ct

					ent.DisableControlUntil = CurTime() + 2

					phys:Wake()

					ShadowParams.pos = (self.ObjectPosition or ent:GetPos()) + VectorRand():GetNormalized() * math.Rand(-24, 24)
					ShadowParams.angle = AngleRand()
					ShadowParams.deltatime = frametime
					phys:ComputeShadowControl(ShadowParams)

					ent:SetPhysicsAttacker(owner)

					self:NextThink(CurTime())
					return true
				end
			end
		end
	end

	self:Remove()
end
